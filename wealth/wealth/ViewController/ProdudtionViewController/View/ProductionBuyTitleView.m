//
//  ProductionBuyTitleView.m
//  wealth
//
//  Created by wangyingjie on 16/3/29.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "ProductionBuyTitleView.h"



@interface ProductionBuyTitleView ()

@end

@implementation ProductionBuyTitleView

- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


#pragma mark- SetupViews
- (void)setUpViews {
    
}

- (void)drawRect:(CGRect)rect{
    CGFloat width = 239;
    CGFloat height = 61;
    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
    CGFloat radius = 3;
    
    // 获取CGContext，注意UIKit里用的是一个专门的函数
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 移动到初始点
    CGContextMoveToPoint(context, radius + (self.width-239.0f)/2.0f, 25.0f);
    
    // 绘制第1条线和第1个1/4圆弧
    CGContextAddLineToPoint(context, width - radius+ (self.width-239.0f)/2.0f, 25.0f);
    CGContextAddArc(context, width - radius+ (self.width-239.0f)/2.0f, radius+ 25.0f, radius, -0.5 * M_PI, 0.0, 0);
    
    // 绘制第2条线和第2个1/4圆弧
    CGContextAddLineToPoint(context, width+ (self.width-239.0f)/2.0f, height - radius + 25.0f);
    CGContextAddArc(context, width - radius+ (self.width-239.0f)/2.0f, height - radius+ 25.0f, radius, 0.0, 0.5 * M_PI, 0);
    
    // 绘制第3条线和第3个1/4圆弧
    CGContextAddLineToPoint(context, radius+ (self.width-239.0f)/2.0f, height + 25.0f);
    CGContextAddArc(context, radius+ (self.width-239.0f)/2.0f, height - radius+ 25.0f, radius, 0.5 * M_PI, M_PI, 0);
    
    // 绘制第4条线和第4个1/4圆弧
    CGContextAddLineToPoint(context, (self.width-239.0f)/2.0f, radius + 25.0f);
    CGContextAddArc(context, radius+ (self.width-239.0f)/2.0f, radius+ 25.0f, radius, M_PI, 1.5 * M_PI, 0);
    
    CGContextClosePath(context);
    CGContextSetRGBStrokeColor(context, 219.0f/255.0f, 183.0f/255.0f, 107.0f/255.0f, 1.0);
    CGContextStrokePath(context);
    
    NSString *message1 = @"理财师已经为你预留出借金额";
    [message1 drawAtPoint:CGPointMake((self.width-239.0f)/2.0f+20.0f, 35.0f) withAttributes:@{ NSFontAttributeName: [UIFont get_C30_CN_NOR_Font],NSForegroundColorAttributeName : [UIColor get_9_Color] }];
    NSString *message2 = @"请您确认出借信息并支付。";
    [message2 drawAtPoint:CGPointMake((self.width-239.0f)/2.0f+35.0f, 55.0f) withAttributes:@{ NSFontAttributeName: [UIFont get_C30_CN_NOR_Font],NSForegroundColorAttributeName : [UIColor get_9_Color] }];
}

//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

@end
