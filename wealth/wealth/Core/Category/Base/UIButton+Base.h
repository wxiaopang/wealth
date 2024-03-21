//
//  UIButton+Base.h
//  iqianjin
//
//  Created by yangzhaofeng on 15/7/15.
//  Copyright (c) 2015年 iqianjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Base)

#pragma mark- init
- (UIButton *)initButtonWithFrame:(CGRect)frame
                  backgroundColor:(UIColor *)backgroundColor
                             font:(UIFont *)font
                       titleColor:(UIColor *)titleColor
                            title:(NSString *)title;

//设置图片和文字垂直摆放的按钮，padding为image与text的垂直距离
- (void)setVerticalAlignmentWithPadding:(CGFloat)padding;

//传统的红色
+ (UIButton *)buttonCustomRedButtonWithFrame:(CGRect)frame title:(NSString *)title;
//白色按钮
+ (UIButton *)buttonCustomWhiteButtonWithFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor boundscolor:(UIColor *)boundscolor;



//带下划线的按钮
+ (UIButton *)buttonUnderlineButtonWithFrame:(CGRect)frame font:(UIFont *)font title:(NSString *)title color:(UIColor *)color;

//上线两条线的按钮
+ (UIButton *)buttonWhiteDoubleLineButtonWithFrame:(CGRect)frame title:(NSString *)title color:(UIColor *)color;

+ (UIButton *)buttonColorLineWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font color:(UIColor *)textColor useLine:(BOOL)line;

//上面是图片下面文字的按钮
+ (UIButton *)buttonVerticalWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image padding:(CGFloat)padding;

@end
