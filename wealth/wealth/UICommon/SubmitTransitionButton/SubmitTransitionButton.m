//
//  SubmitTransitionButton.m
//  wealth
//
//  Created by wangyingjie on 16/1/7.
//  Copyright © 2016年 普惠金融. All rights reserved.
//

#import "SubmitTransitionButton.h"

@interface SubmitTransitionButton ()

@property (nonatomic, assign) CFTimeInterval shrinkDuration;

@property (nonatomic, strong) CAMediaTimingFunction *shrinkCurve;

@property (nonatomic, strong) CAMediaTimingFunction *expandCurve;

@property (nonatomic, copy) Completion block;

@property (nonatomic, strong) UIColor *color;

@end

@implementation SubmitTransitionButton

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _spiner = [[SpinerLayer alloc] initWithFrame:self.frame];
        _shrinkCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        _expandCurve = [CAMediaTimingFunction functionWithControlPoints:0.95 :0.02 :1 :0.05];
        self.shrinkDuration = 0.1;
        [self.layer addSublayer:_spiner];
        [self setup];

        @weakify(self);
        [[RACObserve(_spiner, hidden) distinctUntilChanged] subscribeNext:^(id x) {
            @strongify(self);
            if ( [x boolValue] ) {
                if ( self.block ) {
                    self.block();
                }
            }
        }];
    }
    return self;
}

-(void)setCompletion:(Completion)completion {
    _block = completion;
}

- (void)setup {
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
    self.clipsToBounds = YES;

    [self addTarget:self action:@selector(scaleToSmall)
   forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(scaleAnimation)
   forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(scaleToDefault)
   forControlEvents:UIControlEventTouchDragExit];
}

- (void)scaleToSmall {
    typeof(self) __weak weak = self;

    self.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
        weak.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {

    }];
}

- (void)scaleAnimation {
    typeof(self) __weak weak = self;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
        weak.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
    }];
    [self StartAnimation];
}

- (void)scaleToDefault {
    typeof(self) __weak weak = self;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:0.4f options:UIViewAnimationOptionLayoutSubviews animations:^{
        weak.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {

    }];
}

- (void)StartAnimation {
    [self performSelector:@selector(Revert) withObject:nil afterDelay:0.f];
    [self.layer addSublayer:_spiner];
    CABasicAnimation *shrinkAnim = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    shrinkAnim.fromValue = @(CGRectGetWidth(self.bounds));
    shrinkAnim.toValue = @(CGRectGetHeight(self.bounds));
    shrinkAnim.duration = _shrinkDuration;
    shrinkAnim.timingFunction = _shrinkCurve;
    shrinkAnim.fillMode = kCAFillModeForwards;
    shrinkAnim.removedOnCompletion = NO;
    [self.layer addAnimation:shrinkAnim forKey:shrinkAnim.keyPath];
    [_spiner animation];
    self.superview.userInteractionEnabled = NO;
}

- (void)ErrorRevertAnimationCompletion:(Completion)completion {
    _block = completion;
    CABasicAnimation *shrinkAnim = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    shrinkAnim.fromValue = @(CGRectGetHeight(self.bounds));
    shrinkAnim.toValue = @(CGRectGetWidth(self.bounds));
    shrinkAnim.duration = _shrinkDuration;
    shrinkAnim.timingFunction = _shrinkCurve;
    shrinkAnim.fillMode = kCAFillModeForwards;
    shrinkAnim.removedOnCompletion = NO;
    _color = self.backgroundColor;

    CABasicAnimation *backgroundColor = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    backgroundColor.toValue  = (__bridge id)self.backgroundColor.CGColor;
    backgroundColor.duration = 0.1f;
    backgroundColor.timingFunction = _shrinkCurve;
    backgroundColor.fillMode = kCAFillModeForwards;
    backgroundColor.removedOnCompletion = NO;

    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPoint point = self.layer.position;
    keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)],

                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],

                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],

                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],

                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],

                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],

                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],

                        [NSValue valueWithCGPoint:point]];
    keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    keyFrame.duration = 0.5f;
    keyFrame.delegate = self;
    self.layer.position = point;

    [self.layer addAnimation:backgroundColor forKey:backgroundColor.keyPath];
    [self.layer addAnimation:keyFrame forKey:keyFrame.keyPath];
    [self.layer addAnimation:shrinkAnim forKey:shrinkAnim.keyPath];
    [_spiner stopAnimation];
    self.superview.userInteractionEnabled = YES;
}

-(void)ExitAnimationCompletion:(Completion)completion {
    _block = completion;
    CABasicAnimation *expandAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnim.fromValue = @(1.0);
    expandAnim.toValue = @(33.0);
    expandAnim.timingFunction = _expandCurve;
    expandAnim.duration = 0.3;
    expandAnim.delegate = self;
    expandAnim.fillMode = kCAFillModeForwards;
    expandAnim.removedOnCompletion = NO;
    [self.layer addAnimation:expandAnim forKey:expandAnim.keyPath];
    [_spiner stopAnimation];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CABasicAnimation *cab = (CABasicAnimation *)anim;
    if ([cab.keyPath isEqualToString:@"transform.scale"]) {
        self.superview.userInteractionEnabled = YES;
        [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(DidStopAnimation) userInfo:nil repeats:NO];
    }
}

- (void)Revert {
    CABasicAnimation *backgroundColor = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    backgroundColor.toValue  = (__bridge id)self.backgroundColor.CGColor;
    backgroundColor.duration = 0.1f;
    backgroundColor.timingFunction = _shrinkCurve;
    backgroundColor.fillMode = kCAFillModeForwards;
    backgroundColor.removedOnCompletion = NO;
    [self.layer addAnimation:backgroundColor forKey:@"backgroundColors"];

}

- (void)DidStopAnimation {
    [self.layer removeAllAnimations];
}

@end
