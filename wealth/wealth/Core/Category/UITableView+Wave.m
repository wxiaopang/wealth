//
//  UITableView+Wave.m
//  wealth
//
//  Created by wangyingjie on 15/5/21.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UITableView+Wave.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <objc/message.h>

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end

@implementation UITableView (Wave)

- (void)reloadDataAnimateWithWave:(WaveAnimation)animation {
    [self setContentOffset:self.contentOffset animated:NO];
    //连续点击问题修复：cell复位已经确保之前动画被取消UIViewAnimationOptionCurveLinear UIViewAnimationOptionCurveEaseInOut
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [UIView transitionWithView:self
                      duration:.1
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^(void) {
                        self.hidden = YES;
                        [self reloadData];
                    } completion:^(BOOL finished) {
                        if(finished){
                            self.hidden = NO;
                            //动画效果
                            [self visibleRowsBeginAnimation:animation];
                        }
                    }
     ];
}

- (void)visibleRowsBeginAnimation:(WaveAnimation)animation {
    NSArray *array = [self indexPathsForVisibleRows];
    [array enumerateObjectsUsingBlock:^(NSIndexPath *path, NSUInteger idx, BOOL *stop) {
        UITableViewCell *cell = [self cellForRowAtIndexPath:path];
        cell.frame = [self rectForRowAtIndexPath:path];
        cell.hidden = YES;
        [cell.layer removeAllAnimations];
        NSArray *array = @[path,[NSNumber numberWithInt:animation]];
        [self performSelector:@selector(animationStart:) withObject:array afterDelay:.08*idx];
    }];
}

- (void)animationStart:(NSArray *)array {
    NSIndexPath *path = [array objectAtIndex:0];
    float i = [((NSNumber*)[array objectAtIndex:1]) floatValue] ;
    UITableViewCell *cell = [self cellForRowAtIndexPath:path];
    CGPoint originPoint = cell.center;
    CGPoint beginPoint = CGPointMake(cell.frame.size.width*i, originPoint.y);
    CGPoint endBounce1Point = CGPointMake(originPoint.x-i*2*kBOUNCE_DISTANCE, originPoint.y);
    CGPoint endBounce2Point  = CGPointMake(originPoint.x+i*kBOUNCE_DISTANCE, originPoint.y);
    cell.hidden = NO ;
    
    CAKeyframeAnimation *move = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    move.keyTimes=@[[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.8],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:1.]];
    move.values=@[[NSValue valueWithCGPoint:beginPoint],[NSValue valueWithCGPoint:endBounce1Point],[NSValue valueWithCGPoint:endBounce2Point],[NSValue valueWithCGPoint:originPoint]];
    move.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    CABasicAnimation *opaAnimation = [CABasicAnimation animationWithKeyPath: @"opacity"];
    opaAnimation.fromValue = @(0.f);
    opaAnimation.toValue = @(1.f);
    opaAnimation.autoreverses = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[move,opaAnimation];
    group.duration = kWAVE_DURATION;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    [cell.layer addAnimation:group forKey:nil];
}

@end
