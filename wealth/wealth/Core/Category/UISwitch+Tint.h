//
//  UISwitch+Tint.h
//  wealth
//
//  Created by wangyingjie on 15/7/20.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UISwitchStateChanged)(UISwitch *btn);

@interface UISwitch (Tint)

@property (nonatomic, copy) UISwitchStateChanged didStateChanged;

@end
