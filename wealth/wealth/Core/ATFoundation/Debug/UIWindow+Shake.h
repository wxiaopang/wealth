//
//  UIWindow+Shake.h
//  wealth
//
//  Created by wangyingjie on 15/11/3.
//  Copyright © 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+DTRuntime.h"

@interface UIWindow (Shake)<UITextFieldDelegate>

- (void)shakeWindow:(UIEventSubtype)motion withEvent:(UIEvent *)event;

@end
