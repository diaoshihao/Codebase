//
//  NSString+Extension.h
//  Codebase
//
//  Created by suger on 2017/10/30.
//  Copyright © 2017年 diaoshihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+ (BOOL)isBlockString:(NSString *)string;
+ (BOOL)isNumber:(NSString*)string;
+ (BOOL)isPureInt:(NSString*)string;

- (BOOL)isQQ;
- (BOOL)isPhoneNumber;
- (BOOL)isEmail;
- (BOOL)isIPAddress;
- (BOOL)matchPassword;
- (BOOL)isCallNumber;
- (BOOL)isChinese;

@end
