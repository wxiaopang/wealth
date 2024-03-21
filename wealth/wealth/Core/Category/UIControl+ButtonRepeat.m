//
//  UIControl+ButtonRepeat.m
//  wealth
//
//  Created by wangyingjie on 15/11/7.
//  Copyright © 2015年 普惠金融. All rights reserved.
//

#import "UIControl+ButtonRepeat.h"
#import <objc/runtime.h>

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end

static void *const kUIControlButtonRepeat = (void *)&kUIControlButtonRepeat;

@interface UIControl()

@property (nonatomic,assign) BOOL uxy_ignoreEvent;

@end

@implementation UIControl (ButtonRepeat)

- (NSTimeInterval)acceptEventInterval {
    return [objc_getAssociatedObject(self, kUIControlButtonRepeat) doubleValue];
}

- (void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval {
    objc_setAssociatedObject(self, kUIControlButtonRepeat, @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    Method a = class_getClassMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getClassMethod(self, @selector(__uxy_sendAction:to:forEvent:));
    method_exchangeImplementations(a, b);
}

- (void)__uxy_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (self.uxy_ignoreEvent) return;
    if (self.acceptEventInterval > 0) {
        self.uxy_ignoreEvent = YES;
        [self performSelector:@selector(setUxy_ignoreEvent:) withObject:@(NO) afterDelay:self.acceptEventInterval];
    }
    [self __uxy_sendAction:action to:target forEvent:event];
}

@end
