//
//  UIAlertView+Params.m
//  wealth
//
//  Created by wangyingjie on 15/4/13.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UIAlertView+Params.h"
#import <objc/runtime.h>

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
                                    @implementation TT_FIX_CATEGORY_BUG_##name @end

static void * const kUIAlertViewParamsKey = (void*)&kUIAlertViewParamsKey;

static void * const kNSCBAlertWrapper = (void*)&kNSCBAlertWrapper;

@interface NSCBAlertWrapper : NSObject <UIAlertViewDelegate>

@property (nonatomic, copy) void(^completionBlock)(UIAlertView *alertView, NSInteger buttonIndex);

@end

@implementation NSCBAlertWrapper

#pragma mark - UIAlertViewDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.completionBlock) {
        self.completionBlock(alertView, buttonIndex);
    }
    
    objc_setAssociatedObject(alertView, &kNSCBAlertWrapper, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView {
    // Just simulate a cancel button click
    if (self.completionBlock) {
        self.completionBlock(alertView, alertView.cancelButtonIndex);
    }
    
    objc_setAssociatedObject(alertView, &kNSCBAlertWrapper, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

static __weak UIAlertView *__global__alertView__ = nil;

@implementation UIAlertView (Params)

+ (UIAlertView *)isExistAlertView {
    return __global__alertView__;
}

- (NSDictionary *)userInfo {
    return objc_getAssociatedObject(self, kUIAlertViewParamsKey);
}

- (void)setUserInfo:(NSDictionary *)userInfo {
    objc_setAssociatedObject(self, kUIAlertViewParamsKey, userInfo, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - Class Public

- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion {
    __global__alertView__ = self;

    NSCBAlertWrapper *alertWrapper = [[NSCBAlertWrapper alloc] init];
    alertWrapper.completionBlock = completion;
    self.delegate = alertWrapper;
    
    // Set the wrapper as an associated object
    objc_setAssociatedObject(self, &kNSCBAlertWrapper, alertWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // Show the alert as normal
    [self show];
}

@end
