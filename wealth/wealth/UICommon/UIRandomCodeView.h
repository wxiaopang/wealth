//
//  UIRandomCodeView.h
//  wealth
//
//  Created by wangyingjie on 15/7/9.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRandomCodeCount    5

typedef void(^UIRandomCodeViewBlock)(NSString *code);

@interface UIRandomCodeView : UIView

+ (BOOL)randomCodeViewCheckString:(NSString *)text withCodeString:(NSString *)code;

@property (nonatomic, assign) NSUInteger count;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, copy) UIRandomCodeViewBlock didChangeCode;

@end
