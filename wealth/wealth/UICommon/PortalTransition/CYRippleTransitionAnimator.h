//
//  CYRippleTransitionAnimator.h
//  wealth
//
//  Created by wangyingjie on 15/7/25.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYRippleTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) BOOL isPresentingRipple;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning>transitionContext;

- (instancetype)initWithTouchRect:(CGRect)touchRect;

@end
