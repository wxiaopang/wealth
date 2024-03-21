//
//  TouchIDEngine.m
//  wealth
//
//  Created by wangyingjie on 15/5/22.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "TouchIDEngine.h"

@import LocalAuthentication;

static NSString *const kTouchIdErrorDomain = @"TouchIdAuthenticationDomain";

@implementation TouchIDEngine

+ (BOOL)canUseTouchID {
    if ( NSClassFromString(@"LAContext") != nil ) { // 不支持touch id
        LAContext *context = [[LAContext alloc] init];
        return [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL];
    } else {
        return NO;
    }
}

+ (void)AuthenticationWithTouchId:(TouchIDCallback)callback {
    if ( NSClassFromString(@"LAContext") != nil ) { // 不支持touch id
        NSError *authError = nil;
        LAContext *context = [[LAContext alloc] init];
        if ( [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError] ) {
            NSString *myLocalizedReasonString = [NSString stringWithFormat:@"通过Home键验证指纹解锁%@",
                                                 [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                    localizedReason:myLocalizedReasonString
                              reply:^(BOOL success, NSError *error)
            {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if ( callback ) {
                         if ( success ) {
                             callback(YES, nil);
                         } else {
                             NSString *errMsg = error.userInfo[NSLocalizedDescriptionKey];
                             if ( [errMsg isEqualToString:@"Fallback authentication mechanism selected."] ) {
                                 // todo: 改输入密码模式
                                 callback(NO, [NSError errorWithDomain:kTouchIdErrorDomain code:TouchIDErrorCode_ChangeDigtal userInfo:error.userInfo]);
                             } else if ( [errMsg isEqualToString:@"Canceled by user."] ) {
                                 // todo: 用户取消
                                 callback(NO, [NSError errorWithDomain:kTouchIdErrorDomain code:TouchIDErrorCode_Cancel userInfo:error.userInfo]);
                             } else {
                                 // todo: 超出Touch ID重试次数
                                 callback(NO, [NSError errorWithDomain:kTouchIdErrorDomain code:TouchIDErrorCode_Failed userInfo:error.userInfo]);
                             }
                         }
                     }
                 });
            }];
        } else { // 未设置touch id
            if ( callback ) {
                callback(NO, [NSError errorWithDomain:kTouchIdErrorDomain code:TouchIDErrorCode_Notset userInfo:authError.userInfo]);
            }
//            NSString *title = [NSString stringWithFormat:@"未开启%@指纹解锁",
//                               [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
//            NSString *message = [NSString stringWithFormat:@"请在%@更多-安全管理-启用Touch ID",
//                                 [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"忽略" otherButtonTitles:@"前往设置", nil ];
//            [alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                if ( buttonIndex == 1 ) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                }
//            }];
        }
    } else {
        if ( callback ) {
            callback(NO, [NSError errorWithDomain:kTouchIdErrorDomain code:TouchIDErrorCode_Notsuport userInfo:@{NSLocalizedDescriptionKey:@"Touch ID isn't availiable"}]);
        }
    }
}

@end
