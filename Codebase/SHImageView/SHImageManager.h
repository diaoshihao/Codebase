//
//  SHImageManager.h
//  Codebase
//
//  Created by suger on 2018/2/9.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteHandle)(UIImage *image, NSError *error);

@interface SHImageManager : NSObject

+ (instancetype)shareManager;

- (void)requestImageWithUrl:(NSString *)url size:(CGSize)size complete:(CompleteHandle)completeHandle;

@end
