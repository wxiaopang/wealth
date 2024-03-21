//
//  UIImageView+Base.h
//  iqianjin
//
//  Created by yangzhaofeng on 15/7/15.
//  Copyright (c) 2015年 iqianjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Base)

#pragma mark -init
- (UIImageView *)initImageViewWithFrame:(CGRect)frame
                                  image:(UIImage *)image
                        backgroundColor:(UIColor *)backgroundColor;
//按frame截取图片
+ (UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool;

@end
