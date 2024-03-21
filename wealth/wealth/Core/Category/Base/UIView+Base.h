//
//  UIView+Base.h
//  iqianjin
//
//  Created by yangzhaofeng on 15/7/15.
//  Copyright (c) 2015年 iqianjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Base)

#pragma mark- init
- (UIView *)initViewWithFrame:(CGRect)frame
              backgroundColor:(UIColor *)backgroundColor;

#pragma mark- 添加手势
- (void)addTapGestureRecognizerWithTarget:(id)target action:(SEL)action;
- (void)addTapGestureRecognizerWithTarget:(id)target delegate:(id)delegate action:(SEL)action;
- (void)addSwipeGestureRecognizerWithTarget:(id)target action:(SEL)action;
- (void)addSwipeGestureRecognizerWithTarget:(id)target delegate:(id)delegate action:(SEL)action;
- (void)addLeftSwipeGestureRecognizerWithTarget:(id)target action:(SEL)action;
- (void)addLeftSwipeGestureRecognizerWithTarget:(id)target delegate:(id)delegate action:(SEL)action;
- (void)addRightSwipeGestureRecognizerWithTarget:(id)target action:(SEL)action;
- (void)addRightSwipeGestureRecognizerWithTarget:(id)target delegate:(id)delegate action:(SEL)action;
- (void)addLongPressGestureRecognizerWithTarget:(id)target action:(SEL)action;
- (void)addLongPressGestureRecognizerWithTarget:(id)target delegate:(id)delegate action:(SEL)action;


#pragma mark- 画线
- (void)addLineWithFrame:(CGRect)frame;
- (void)addLineWithFrame:(CGRect)frame color:(UIColor *)color;
- (UIView *)addGetLineWithFrame:(CGRect)frame color:(UIColor *)color;
- (UIView *)addGetLineWithFrame:(CGRect)frame;
#pragma mark- 画点线
- (void)addPointsHorizontalLineFrame:(CGRect)frame;
- (void)addPointsVerticalLineFrame:(CGRect)frame;

#pragma mark 给View指定方位设置圆角
- (void)setViewWithRoundingCorners:(UIRectCorner)roundingCorners cornerRadius:(CGFloat)cornerRadius;
#pragma mark 截屏
- (UIImage *)getCurrentBackImage;

@end


@interface UIView (Dashed)

@property (assign, nonatomic) BOOL borderTypeDashed;            /**<*/
@property (strong, nonatomic) UIColor *borderColor;             /**<线的颜色（不设置为透明色）*/
@property (assign, nonatomic) CGFloat cornerRadius;             /**<圆角弧度（可以直接设置layer这个属性，也可直接设置这个）*/
@property (assign, nonatomic) CGFloat borderWidth;              /**<线宽度，当设置frame的宽或者高小于等于两倍的线宽将认为是直线*/
@property (assign, nonatomic) NSUInteger dashPattern;           /**<实线宽度（划线宽度）*/
@property (assign, nonatomic) NSUInteger spacePattern;          /**<虚线宽度（空白宽度）*/

@property (nonatomic, copy) CAShapeLayer *shapeLayer;           /**<划线的layer（不用进行设置）*/

/**
 *  绘画虚线&虚线边框的View以及子类
 *
 *  @param cornerRadius 圆角弧度
 *  @param borderWidth  线宽
 *  @param dashPattern  实线长度
 *  @param spacePattern 虚线长度
 *  @param borderColor  线的颜色
 */
- (void)drawDashedBorderWithCornerRadius:(double)cornerRadius AndBorderWidth:(double)borderWidth AndDashPattern:(NSInteger)dashPattern AndSpacePattern:(NSInteger)spacePattern AndLineColor:(UIColor *)borderColor;


@end


