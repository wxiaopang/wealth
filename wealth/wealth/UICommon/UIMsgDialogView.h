//
//  UIMsgDialogView.h
//  AiShiDai
//
//  Created by wangyingjie on 15/4/29.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//
//  信息文本提示视图  显示在导航栏下方
//

#import <UIKit/UIKit.h>

@interface UIMsgDialogView : UIView

@property (nonatomic, strong) UIView * bgView;

- (id)initWithText:(NSString *)text withSuperView:(UIView *)superView;
- (id)initWithText:(NSString *)text withSuperView:(UIView *)superView bottomView:(UIView *)bottomView space:(CGFloat)space;
- (void)show;

@end
