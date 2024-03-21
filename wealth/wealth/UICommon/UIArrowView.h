//
//  UIArrowView.h
//  wealth
//
//  Created by wangyingjie on 15/3/9.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ArrowViewDirection) {
    ArrowViewDirection_DOWN,
    ArrowViewDirection_UP,
    ArrowViewDirection_LEFT,
    ArrowViewDirection_RIGHT,
};

@interface UIArrowView : UIView

@property (nonatomic, assign) ArrowViewDirection type;

@property (nonatomic, strong) UIColor *arrowColor;

-(void)drawWithColor:(UIColor *)color;

@end
