//
//  UIAlertView+Params.h
//  wealth
//
//  Created by wangyingjie on 15/4/13.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Params)

@property (nonatomic, strong) NSDictionary *userInfo;

+ (UIAlertView *)isExistAlertView;

- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion;

@end
