//
//  UIViewController+CustomToast.m
//  wealth
//
//  Created by wangyingjie on 15/3/24.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UIViewController+CustomToast.h"
//#import "IDCompleteView.h"

#define   kLeftMargin     16.0f
#define   kCompleteHeight 78.0f
#define   kBottomMargin   28.0f

static void * const kCustomToastViewKey = (void*)&kCustomToastViewKey;
static void * const kCustomEmptyViewKey = (void*)&kCustomEmptyViewKey;
static void * const kCustomEmptyViewTapGestureRecognizerKey = (void*)&kCustomEmptyViewTapGestureRecognizerKey;
static void * const kCustomLoadingViewKey = (void*)&kCustomLoadingViewKey;

@interface UIViewController ()

//@property (nonatomic, readonly) IDCompleteView *customToastView;

@end

@implementation UIViewController (CustomToast)

- (void)showToastView:(NSString *)title dismissAnimationCompletion:(dispatch_block_t)block {
    // 先收起键盘
    ENDEDITING;
    
//    IDCompleteView *toastView = objc_getAssociatedObject(self, &kCustomToastViewKey);
//    if ( toastView == nil ) {
//        toastView = [[IDCompleteView alloc] initWithFrame:CGRectMake(kLeftMargin,
//                                                                     self.view.height + 100,
//                                                                     self.view.width - kLeftMargin * 2,
//                                                                     kCompleteHeight)];
//        objc_setAssociatedObject(self, &kCustomToastViewKey, toastView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    toastView.text = title;
//    [self.view addSubview:toastView];
//    
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        toastView.top = self.view.height - kBottomMargin - toastView.height;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.3 delay:1.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            toastView.top = self.view.height + 100;
//        } completion:^(BOOL finished) {
//            [toastView removeFromSuperview];
//            
//            if ( block ) {
//                block();
//            }
//        }];
//    }];
}

- (UITipsView *)tipsView {
    return objc_getAssociatedObject(self, &kCustomEmptyViewKey);
}

- (UITipsView *)showTipsView:(NSString *)title
                      detail:(NSString *)detail
                    viewType:(TipsViewType)type
{
    return [self showTipsView:title detail:detail viewType:type target:nil action:nil];
}

- (UITipsView *)showTipsView:(NSString *)title
                      detail:(NSString *)detail
                    viewType:(TipsViewType)type
                      target:(NSObject *)target
                      action:(SEL)action
{
    UITipsView *emptyView = objc_getAssociatedObject(self, &kCustomEmptyViewKey);
    if ( emptyView == nil ) {
        emptyView = [[UITipsView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight-kNavigationBarHeight)];
        [self.view addSubview:emptyView];
        objc_setAssociatedObject(self, &kCustomEmptyViewKey, emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    emptyView.title = title;
    emptyView.detaiText = detail;
    emptyView.type = type;
    UITapGestureRecognizer *tapGestureRecognizer = objc_getAssociatedObject(self, &kCustomEmptyViewTapGestureRecognizerKey);
    if ( target && action ) {
        if ( tapGestureRecognizer == nil ) {
            tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
            [emptyView addGestureRecognizer:tapGestureRecognizer];
        } else {
            [emptyView removeGestureRecognizer:tapGestureRecognizer];
            tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
            [emptyView addGestureRecognizer:tapGestureRecognizer];
        }
        objc_setAssociatedObject(self, &kCustomEmptyViewTapGestureRecognizerKey, tapGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        if ( tapGestureRecognizer ) {
            [emptyView removeGestureRecognizer:tapGestureRecognizer];
            objc_setAssociatedObject(self, &kCustomEmptyViewTapGestureRecognizerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    return emptyView;
}

- (void)dismissTipsView {
    UITipsView *emptyView = objc_getAssociatedObject(self, &kCustomEmptyViewKey);
    if ( emptyView ) {
        [emptyView removeFromSuperview];
        
        UITapGestureRecognizer *tapGestureRecognizer = objc_getAssociatedObject(self, &kCustomEmptyViewTapGestureRecognizerKey);
        if ( tapGestureRecognizer ) {
            [emptyView removeGestureRecognizer:tapGestureRecognizer];
            objc_setAssociatedObject(self, &kCustomEmptyViewTapGestureRecognizerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        objc_setAssociatedObject(self, &kCustomEmptyViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)showLoadView:(UILoadStatus)status message:(NSString *)message {
    [self showLoadView:status message:message complete:nil];
}

- (void)showLoadView:(UILoadStatus)status message:(NSString *)message complete:(dispatch_block_t)complete {
    ENDEDITING;
    
    UILoadDialogView *loadingView = objc_getAssociatedObject(self, &kCustomLoadingViewKey);
    if ( loadingView == nil ) {
        loadingView = [[UILoadDialogView alloc] initWithFrame:self.view.frame];
        loadingView.userInteractionEnabled = NO;
        self.view.userInteractionEnabled = NO;
        [self.view addSubview:loadingView];
        objc_setAssociatedObject(self, &kCustomLoadingViewKey, loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    if ( complete || status == UILoadStart) {
        @weakify(self);
        loadingView.finishBlock = ^(void){
            @strongify(self);
            [UIView animateWithDuration:0.75f animations:^{
                //加载完成后移除视图
                UILoadDialogView *tmpView = objc_getAssociatedObject(self, &kCustomLoadingViewKey);
                [tmpView removeFromSuperview];
                self.view.userInteractionEnabled = YES;
                objc_setAssociatedObject(self, &kCustomLoadingViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            } completion:^(BOOL finished) {
                if ( complete ) {
                    complete();
                }
            }];
        };
    }

    //设置加载视图的提示文案和状态
    loadingView.msg = message;
    loadingView.loadStatus = status;
}

@end
