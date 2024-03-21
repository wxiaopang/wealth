//
//  UIView+BadgeView.m
//  wealth
//
//  Created by wangyingjie on 15/2/28.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UIView+BadgeView.h"
#import <objc/runtime.h>

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end

@implementation CircleBadgeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect)));
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.829 green:0.194 blue:0.257 alpha:1.000].CGColor);
    
    CGContextFillPath(context);
}

@end

static NSString const * BadgeViewKey = @"BadgeViewKey";
static NSString const * BadgeViewFrameKey = @"BadgeViewFrameKey";
static NSString const * CircleBadgeViewKey = @"CircleBadgeViewKey";

@implementation UIView (BadgeView)

- (void)setBadgeViewFrame:(CGRect)badgeViewFrame {
    objc_setAssociatedObject(self, &BadgeViewFrameKey, NSStringFromCGRect(badgeViewFrame), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)badgeViewFrame {
    return CGRectFromString(objc_getAssociatedObject(self, &BadgeViewFrameKey));
}

- (LKBadgeView *)badgeView {
    LKBadgeView *badgeView = objc_getAssociatedObject(self, &BadgeViewKey);
    if (badgeView) {
        badgeView.frame = self.badgeViewFrame;
        return badgeView;
    }
    
    badgeView = [[LKBadgeView alloc] initWithFrame:self.badgeViewFrame];
    [self addSubview:badgeView];
    
    self.badgeView = badgeView;
    
    return badgeView;
}

- (void)setBadgeView:(LKBadgeView *)badgeView {
    objc_setAssociatedObject(self, &BadgeViewKey, badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CircleBadgeView *)setupCircleBadge {
    self.opaque = NO;
    self.clipsToBounds = NO;
    CircleBadgeView *circleView = objc_getAssociatedObject(self, &CircleBadgeViewKey);
    if (circleView)
        return circleView;
    
    if (!circleView) {
        circleView = [[CircleBadgeView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, 8, 8)];
        [self addSubview:circleView];
        objc_setAssociatedObject(self, &CircleBadgeViewKey, circleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return circleView;
}

@end
