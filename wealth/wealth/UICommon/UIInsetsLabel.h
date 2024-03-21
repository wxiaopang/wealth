//
//  UIInsetsLabel.h
//  wealth
//
//  Created by wangyingjie on 15/2/14.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIInsetsLabel : UILabel

@property(nonatomic, assign) UIEdgeInsets insets;

- (instancetype)initWithInsets:(UIEdgeInsets)insets;

- (instancetype)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets;

@end
