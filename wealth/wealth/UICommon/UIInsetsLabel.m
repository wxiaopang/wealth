//
//  UIInsetsLabel.m
//  wealth
//
//  Created by wangyingjie on 15/2/14.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UIInsetsLabel.h"

@implementation UIInsetsLabel

- (instancetype)initWithInsets:(UIEdgeInsets)insets {
    return [self initWithFrame:CGRectZero andInsets:insets];
}

- (instancetype)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if ( self ) {
        self.insets = insets;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end
