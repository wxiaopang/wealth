//
//  UICustomSwitch.m
//  UICommon
//
//  Created by aimy on 13-10-23.
//  Copyright (c) 2013年 p. All rights reserved.
//

#import "UICustomSwitch.h"

@interface UICustomSwitch ()

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, strong) UIView  *background;
@property (nonatomic, strong) UIView  *knob;
@property (nonatomic, assign) BOOL    isAnimating;

- (void)showOn:(BOOL)animated;
- (void)showOff:(BOOL)animated;
- (void)setup;

@end

@implementation UICustomSwitch

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.isRounded     = YES;
    self.inactiveColor = [UIColor getColorWithR236G236B236];
    self.activeColor   = [UIColor whiteColor];
    self.onColor       = [UIColor button2BackgroundNormalColor];
    self.knobColor     = [UIColor whiteColor];

    // background
    self.background                        = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.background.layer.cornerRadius     = self.height * 0.5;
    self.background.backgroundColor        = self.activeColor;
    self.background.userInteractionEnabled = NO;
    [self addSubview:self.background];

    // knob
    self.knob                     = [[UIView alloc] initWithFrame:CGRectMake(1, 1, self.height - 2, self.height - 2)];
    self.knob.backgroundColor     = self.knobColor;
    self.knob.layer.cornerRadius  = self.knob.height * 0.5;
    self.knob.layer.masksToBounds = NO;
    [self addSubview:self.knob];
    self.on     = NO;
    self.isAnimating = NO;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self addGestureRecognizer:tap];

    //    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    //    [self addGestureRecognizer:pan];
}

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tap {
    self.on = !self.on;
}

//- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan {
//    CGPoint point = [pan translationInView:self];
//    CGPoint newCenter = CGPointMake(self.knob.center.x + point.x, self.knob.center.y + point.y);
//    if ( CGRectContainsRect(self.bounds, self.knob.bounds) ) {
//        self.knob.center = newCenter;
//    }
//    [pan setTranslation:CGPointZero inView:self];
//}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!self.isAnimating) {
        CGRect frame = self.frame;

        // background
        self.background.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        //        self.background.layer.borderWidth = SINGLE_LINE_WIDTH;
        //        self.background.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.background.layer.cornerRadius = self.isRounded ? frame.size.height * 0.5 : 2;

        // knob
        CGFloat normalKnobWidth = frame.size.height - 2;
        if (self.on) {
            self.knob.frame = CGRectMake(frame.size.width - (normalKnobWidth + 1), 1, frame.size.height - 2, normalKnobWidth);
        }
        else {
            self.knob.frame = CGRectMake(1, 1, normalKnobWidth, normalKnobWidth);
        }
        self.knob.layer.borderWidth  = SINGLE_LINE_WIDTH;
        self.knob.layer.borderColor  = [UIColor getColorWithR229G232B239].CGColor;
        self.knob.layer.cornerRadius = self.isRounded ? (frame.size.height * 0.5) - 1 : 2;
    }
}

#pragma mark Setters

- (void)setInactiveColor:(UIColor *)color {
    _inactiveColor = color;
    if (!self.on && !self.isTracking) {
        self.background.backgroundColor = color;
    }
}

- (void)setOnColor:(UIColor *)color {
    _onColor = color;
    if (self.on && !self.isTracking) {
        self.background.backgroundColor = color;
    }
}

- (void)setKnobColor:(UIColor *)color {
    self.knobColor            = color;
    self.knob.backgroundColor = color;
}

- (void)setIsRounded:(BOOL)rounded {
    _isRounded = rounded;
    if (_isRounded) {
        self.background.layer.cornerRadius = self.height * 0.5;
        self.knob.layer.cornerRadius       = (self.height * 0.5) - 1;
    }
    else {
        self.background.layer.cornerRadius = 2;
        self.knob.layer.cornerRadius       = 2;
    }
}

- (void)setOn:(BOOL)isOn {
    [self setOn:isOn animated:NO];
}

- (void)setOn:(BOOL)isOn animated:(BOOL)animated {
    _on = isOn;
    if (_on) {
        [self showOn:animated];
    }
    else {
        [self showOff:animated];
    }

    if (self.compelete) {
        self.compelete(self);
    }
}

#pragma mark State Changes

- (void)showOn:(BOOL)animated {
    CGFloat normalKnobWidth = self.bounds.size.height - 2;
    CGFloat activeKnobWidth = normalKnobWidth + 5;
    if (animated) {
        self.isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking) {
                self.knob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), self.knob.top, activeKnobWidth, self.knob.height);
            }
            else {
                self.knob.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), self.knob.top, normalKnobWidth, self.knob.height);
            }
            self.background.backgroundColor = self.onColor;
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }
    else {
        if (self.tracking) {
            self.knob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), self.knob.top, activeKnobWidth, self.knob.height);
        }
        else {
            self.knob.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), self.knob.top, normalKnobWidth, self.knob.height);
        }
        self.background.backgroundColor = self.onColor;
    }
}

- (void)showOff:(BOOL)animated {
    CGFloat normalKnobWidth = self.bounds.size.height - 2;
    CGFloat activeKnobWidth = normalKnobWidth + 5;
    if (animated) {
        self.isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking) {
                self.knob.frame = CGRectMake(1, self.knob.top, activeKnobWidth, self.knob.height);
                self.background.backgroundColor = self.activeColor;
            }
            else {
                self.knob.frame = CGRectMake(1, self.knob.top, normalKnobWidth, self.knob.height);
                self.background.backgroundColor = self.inactiveColor;
            }
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }
    else {
        if (self.tracking) {
            self.knob.frame                 = CGRectMake(1, self.knob.top, activeKnobWidth, self.knob.height);
            self.background.backgroundColor = self.activeColor;
        }
        else {
            self.knob.frame                 = CGRectMake(1, self.knob.top, normalKnobWidth, self.knob.height);
            self.background.backgroundColor = self.inactiveColor;
        }
    }
}

@end
