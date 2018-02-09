//
//  CameraViewController.m
//  KTBook
//
//  Created by suger on 2017/12/25.
//  Copyright © 2017年 Frank. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Extension.h"

@interface CameraViewController ()<AVCapturePhotoCaptureDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) AVCaptureDevice *device;

@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;

@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIImageView *focusView;

@property (nonatomic, assign) CGFloat preScale;

@property (nonatomic, assign) BOOL animationForFocus;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self checkVideoStatus];
    
    [self setupCamera];
    [self setupPreviewLayer];
    [self setupButtonViews];
    
    [self.captureSession startRunning];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignCamera) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)resignCamera {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //自动对焦
    [self focusAtPoint:self.view.center];
}

///图像设备设置
- (void)setupCamera {
    self.captureSession = [[AVCaptureSession alloc] init];
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    }
    
    // 获取视频输入设备，该方法默认返回iPhone的后置摄像头
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 将捕捉设备加入到捕捉会话中
    self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    if ([self.captureSession canAddInput:self.deviceInput]) {
        [self.captureSession addInput:self.deviceInput];
    }
    
    // 将设备输出加入到捕捉会话中
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    if ([self.captureSession canAddOutput:self.imageOutput]) {
        [self.captureSession addOutput:self.imageOutput];
    }
    
}

///图像实时预览
- (void)setupPreviewLayer {
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] init];
    self.previewLayer.frame = self.view.bounds;
    self.previewLayer.contentsGravity = AVLayerVideoGravityResizeAspect;
    self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    [self.view.layer addSublayer:self.previewLayer];
    self.previewLayer.session = self.captureSession;
    
    //焦点手势
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToFocus:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:singleTapGesture];
    
    //双击切换设备
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToFlipDevice:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:doubleTapGesture];
    
    //单击依赖双击手势识别失败
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    //缩放手势
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchToScale:)];
    [self.view addGestureRecognizer:pinchGesture];
    
    self.focusView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_focus"]];
    [self.previewLayer addSublayer:self.focusView.layer];
}

#pragma mark - gesture action

- (void)tapToFocus:(UITapGestureRecognizer *)tap {
    if (self.animationForFocus) {
        return;
    }
    CGPoint tapPoint = [tap locationInView:tap.view];
    [self focusAtPoint:tapPoint];
}

- (void)tapToFlipDevice:(UITapGestureRecognizer *)tap {
    [self flipCamera:nil];
}

- (void)pinchToScale:(UIPinchGestureRecognizer *)pinch {
    [self zoomDeviceIn:pinch.scale];
    pinch.scale = 1.0;
    
    //手势结束自动对焦
    if (pinch.state == UIGestureRecognizerStateEnded) {
        [self focusAtPoint:self.view.center];
    }
}

///在point处对焦
- (void)focusAtPoint:(CGPoint)point {
    CGPoint focusPoint = CGPointMake(point.x/self.view.bounds.size.width, point.y/self.view.bounds.size.height);
    
    if ([self.device lockForConfiguration:nil]) {
        if ([self.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus] && self.device.isFocusPointOfInterestSupported) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        if ([self.device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure] && self.device.isExposurePointOfInterestSupported) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        }
        [self.device unlockForConfiguration];
    }
    
    [self focusViewAnimationCenter:point];
}

///数码对焦（缩放）
- (void)zoomDeviceIn:(CGFloat)scale {
    NSError *error = nil;
    if ([self.device lockForConfiguration:&error]) {
        self.preScale *= scale;
        if (self.preScale < 1.0) {
            self.preScale = 1.0;
        }
        if (self.preScale > 20.0) {
            self.preScale = 20.0;
        }
        [self.device rampToVideoZoomFactor:self.preScale withRate:50];
        [self.device unlockForConfiguration];
    }
}

///对焦动画
- (void)focusViewAnimationCenter:(CGPoint)center {
    self.focusView.frame = CGRectMake(0, 0, 100, 100);
    self.focusView.center = center;
    self.focusView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.animationForFocus = YES;
        CGRect frame = self.focusView.frame;
        frame.size = CGSizeMake(60, 60);
        self.focusView.frame = frame;
        self.focusView.center = center;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.focusView.hidden = YES;
            self.animationForFocus = NO;
        });
    }];
}

///设置按钮
- (void)setupButtonViews {
    UIButton *flipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [flipButton setImage:[UIImage imageNamed:@"camera_flip"] forState:UIControlStateNormal];
    flipButton.frame = CGRectMake(self.view.width - 60, 0, 60, 60);
    [self.view addSubview:flipButton];
    
    UIButton *takeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"camera_take"];
    [takeButton setImage:image forState:UIControlStateNormal];
    takeButton.frame = CGRectMake(0, self.view.height-130, image.size.width, image.size.height);
    takeButton.centerX = self.view.centerX;
    [self.view addSubview:takeButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = takeButton.frame;
    frame.origin.x = self.view.width / 4.0 - frame.size.width / 2.0;
    cancelButton.frame = frame;
    cancelButton.centerY = takeButton.centerY;
    [cancelButton setImage:[UIImage imageNamed:@"camera_back"] forState:UIControlStateNormal];
    cancelButton.tintColor = [UIColor whiteColor];
    [self.view addSubview:cancelButton];
    
    [takeButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [flipButton addTarget:self action:@selector(flipCamera:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton addTarget:self action:@selector(cancelPick:) forControlEvents:UIControlEventTouchUpInside];
}

///拍照
- (void)takePhoto:(UIButton *)sender {
    AVCaptureConnection *captureConnection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (![self.imageOutput isCapturingStillImage]) {
        [self.imageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
            if (imageDataSampleBuffer == nil) {
                return;
            }
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            //调整图片方向
            UIImage *image = [UIImage imageWithData:imageData];
            if ([self.delegate respondsToSelector:@selector(didPickedImageFromCamera:image:)]) {
                [self.delegate didPickedImageFromCamera:self image:image];
            }
            [self.captureSession stopRunning];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
    }
}

///切换摄像头
- (void)flipCamera:(UIButton *)sender {
    
    [self.captureSession stopRunning];
    
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        //给摄像头的切换添加翻转动画
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = @"oglFlip";
        
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        //拿到另外一个摄像头位置
        AVCaptureDevicePosition position = [self.deviceInput.device position];
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;//动画翻转方向
        }
        else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;//动画翻转方向
        }
        //生成新的输入
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        [self.previewLayer addAnimation:animation forKey:nil];
        
        if (newInput != nil) {
            [self.captureSession beginConfiguration];
            [self.captureSession removeInput:self.deviceInput];
            if ([self.captureSession canAddInput:newInput]) {
                [self.captureSession addInput:newInput];
                self.deviceInput = newInput;
                
            } else {
                [self.captureSession addInput:self.deviceInput];
            }
            [self.captureSession commitConfiguration];
            
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
    
    [self.captureSession startRunning];
}

///根据方向获取设备
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ){
            return device;
        }
    return nil;
}

- (void)cancelPick:(UIButton *)sender {
    [self.captureSession stopRunning];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//检查权限
- (void) checkVideoStatus {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            //没有询问是否开启相机
            [self videoAuthAction];
            break;
        case AVAuthorizationStatusRestricted:
            //未授权，家长限制
            [self showAVAuthorizationAlert];
            break;
        case AVAuthorizationStatusDenied:
            //未授权
            [self showAVAuthorizationAlert];
            break;
        case AVAuthorizationStatusAuthorized:
            //玩家授权
            break;
        default:
            break;
    }
}

//相机授权
- (void)videoAuthAction {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (!granted) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)showAVAuthorizationAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请打开允许访问相机权限" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:actionCacel];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
