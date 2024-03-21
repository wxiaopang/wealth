//
//  UIViewController+CustomToast.h
//  wealth
//
//  Created by wangyingjie on 15/3/24.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILoadDialogView.h"

@interface UIViewController (CustomToast)

- (void)showToastView:(NSString *)title dismissAnimationCompletion:(dispatch_block_t)block;

- (UITipsView *)tipsView;

- (UITipsView *)showTipsView:(NSString *)title
                      detail:(NSString *)detail
                    viewType:(TipsViewType)type;

- (UITipsView *)showTipsView:(NSString *)title
                      detail:(NSString *)detail
                    viewType:(TipsViewType)type
                      target:(NSObject *)target
                      action:(SEL)action;

- (void)dismissTipsView;

- (void)showLoadView:(UILoadStatus)status message:(NSString *)message;

- (void)showLoadView:(UILoadStatus)status message:(NSString *)message complete:(dispatch_block_t)complete;

@end
