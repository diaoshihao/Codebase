//
//  DeviceInfoManager.h
//  Device
//
//  Created by pro on 2017/11/8.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfoManager : NSObject

+ (instancetype)sharedManager;

+ (const NSString *)getDeviceName;

@end
