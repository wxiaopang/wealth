//
//  TouchIDEngine.h
//  wealth
//
//  Created by wangyingjie on 15/5/22.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TouchIDErrorCode) {
    TouchIDErrorCode_Notsuport,
    TouchIDErrorCode_Notset,
    TouchIDErrorCode_ChangeDigtal,
    TouchIDErrorCode_Cancel,
    TouchIDErrorCode_Failed,
};

typedef void(^TouchIDCallback)(BOOL success, NSError *err);

@interface TouchIDEngine : NSObject

//Returns YES if device has Touch ID
+ (BOOL)canUseTouchID;

//Callback block handles YES, if Touch ID validated. No if handled error.
+ (void)AuthenticationWithTouchId:(TouchIDCallback)callback;

@end
