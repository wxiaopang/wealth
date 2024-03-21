//
//  UIViewController+Keyboard.m
//  wealth
//
//  Created by wangyingjie on 15/3/4.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UIViewController+Keyboard.h"
#import <objc/runtime.h>

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
                                    @implementation TT_FIX_CATEGORY_BUG_##name @end

typedef NS_ENUM(NSInteger, KeyboardMoveDirection) {
    KeyboardMoveDirectionNone,
    KeyboardMoveDirectionUp,
    KeyboardMoveDirectionDown,
    KeyboardMoveDirectionRight,
    KeyboardMoveDirectionLeft,
};

static void * const kWillShowBlockKey                   = (void*)&kWillShowBlockKey;
static void * const kWillHideBlockKey                   = (void*)&kWillHideBlockKey;
static void * const kDidShowBlockKey                    = (void*)&kDidShowBlockKey;
static void * const kDidHideBlockKey                    = (void*)&kDidHideBlockKey;
static void * const kNotificationsOnKey                 = (void*)&kNotificationsOnKey;
static void * const kKeyboardPanRecognizerKey           = (void*)&kKeyboardPanRecognizerKey;
static void * const kViewControllerLogInformationKey   = (void*)&kViewControllerLogInformationKey;

@interface UIViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *keyboardPanRecognizer;

@end

@implementation UIViewController (Keyboard)

- (void)setEnablePanHiddenKeyBoard:(BOOL)enablePanHiddenKeyBoard
{
    if ( enablePanHiddenKeyBoard ) {
        if ( self.keyboardPanRecognizer == nil ) {
            UIPanGestureRecognizer *keyboardPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                                    action:@selector(panGestureDidChange:)];
            keyboardPanRecognizer.minimumNumberOfTouches = 1;
            keyboardPanRecognizer.delegate = self;
            keyboardPanRecognizer.cancelsTouchesInView = NO;
            [self.view addGestureRecognizer:keyboardPanRecognizer];
            self.keyboardPanRecognizer = keyboardPanRecognizer;
        }
    } else {
        self.keyboardPanRecognizer = nil;
    }
}

- (BOOL)enablePanHiddenKeyBoard
{
    return self.keyboardPanRecognizer != nil ? YES : NO;
}

- (void)panGestureDidChange:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:self.view];
    if ( translation.y > kNavigationBarHeight ) {
        [UIView animateWithDuration:0.25f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                         } completion:^(BOOL finished){

                         }];
    }
}

- (void)setKeyboardPanRecognizer:(UIPanGestureRecognizer *)keyboardPanRecognizer
{
    objc_setAssociatedObject(self, kKeyboardPanRecognizerKey, keyboardPanRecognizer, OBJC_ASSOCIATION_RETAIN);
}

- (UIPanGestureRecognizer *)keyboardPanRecognizer
{
    return objc_getAssociatedObject(self, kKeyboardPanRecognizerKey);
}

#pragma mark - willShow

- (void)bht_setWillShowAnimationBlock:(KeyboardFrameAnimationBlock)willShowBlock
{
    objc_setAssociatedObject(self, kWillShowBlockKey, willShowBlock, OBJC_ASSOCIATION_COPY);
}

- (KeyboardFrameAnimationBlock)bht_willShowAnimationBlock
{
    return (KeyboardFrameAnimationBlock)objc_getAssociatedObject(self, kWillShowBlockKey);
}

#pragma mark - willHide

- (void)bht_setWillHideAnimationBlock:(KeyboardFrameAnimationBlock)willHideBlock
{
    objc_setAssociatedObject(self, kWillHideBlockKey, willHideBlock, OBJC_ASSOCIATION_COPY);
}

- (KeyboardFrameAnimationBlock)bht_willHideAnimationBlock
{
    return (KeyboardFrameAnimationBlock)objc_getAssociatedObject(self, kWillHideBlockKey);
}

#pragma mark - didShow

- (void)bht_setDidShowActionBlock:(KeyboardFrameAnimationBlock)didShowBlock
{
    objc_setAssociatedObject(self, kDidShowBlockKey, didShowBlock, OBJC_ASSOCIATION_COPY);
}

- (KeyboardFrameAnimationBlock)bht_didShowActionBlock
{
    return (KeyboardFrameAnimationBlock)objc_getAssociatedObject(self, kDidShowBlockKey);
}

#pragma mark - didHide

- (void)bht_setDidHideActionBlock:(KeyboardFrameAnimationBlock)didHideBlock
{
    objc_setAssociatedObject(self, kDidHideBlockKey, didHideBlock, OBJC_ASSOCIATION_COPY);
}

- (KeyboardFrameAnimationBlock)bht_didHideActionBlock
{
    return (KeyboardFrameAnimationBlock)objc_getAssociatedObject(self, kDidHideBlockKey);
}

#pragma mark - areNotificationsOn

- (void)bht_setNotificationsOn:(BOOL)notificationsOn
{
    objc_setAssociatedObject(self, kNotificationsOnKey, @(notificationsOn), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)bht_areNotificationsOn
{
    return [objc_getAssociatedObject(self, kNotificationsOnKey) boolValue];
}

#pragma mark -  viewControllerLogInformation

- (void)setViewControllerLogInformation:(ViewControllerLogInformation *)viewControllerLogInformation {
    objc_setAssociatedObject(self, kViewControllerLogInformationKey, viewControllerLogInformation, OBJC_ASSOCIATION_RETAIN);
}

- (ViewControllerLogInformation *)viewControllerLogInformation {
    return objc_getAssociatedObject(self, kViewControllerLogInformationKey);
}

#pragma mark - public

- (void)setKeyboardWillShowAnimationBlock:(KeyboardFrameAnimationBlock)showBlock
{
    if ([self bht_areNotificationsOn])
    {
        KeyboardFrameAnimationBlock prevWillShowBlock = [self bht_willShowAnimationBlock];
        
        if (!showBlock && prevWillShowBlock)
            [self unregisterWillShowNotification];
        else if (showBlock && !prevWillShowBlock)
            [self registerWillShowNotification];
    }
    
    [self bht_setWillShowAnimationBlock:showBlock];
}

- (void)setKeyboardWillHideAnimationBlock:(KeyboardFrameAnimationBlock)hideBlock
{
    if ([self bht_areNotificationsOn])
    {
        KeyboardFrameAnimationBlock prevWillHideBlock = [self bht_willHideAnimationBlock];
        
        if (!hideBlock && prevWillHideBlock)
            [self unregisterWillHideNotification];
        else if (hideBlock && !prevWillHideBlock)
            [self registerWillHideNotification];
    }
    
    [self bht_setWillHideAnimationBlock:hideBlock];
}

- (void)setKeyboardDidShowActionBlock:(KeyboardFrameAnimationBlock)didShowBlock
{
    if ([self bht_areNotificationsOn])
    {
        KeyboardFrameAnimationBlock prevDidShowBlock = [self bht_didShowActionBlock];
        
        if (!didShowBlock && prevDidShowBlock)
            [self unregisterDidShowNotification];
        else if (didShowBlock && !prevDidShowBlock)
            [self registerDidShowNotification];
    }
    
    [self bht_setDidShowActionBlock:didShowBlock];
}

- (void)setKeyboardDidHideActionBlock:(KeyboardFrameAnimationBlock)didHideBlock
{
    if ([self bht_areNotificationsOn])
    {
        KeyboardFrameAnimationBlock prevDidHideBlock = [self bht_didHideActionBlock];
        
        if (!didHideBlock && prevDidHideBlock)
            [self unregisterDidHideNotification];
        else if (didHideBlock && !prevDidHideBlock)
            [self registerDidHideNotification];
    }
    
    [self bht_setDidHideActionBlock:didHideBlock];
}

#pragma mark - registering notifications

- (void)bht_registerForKeyboardNotifications
{
    [self bht_setNotificationsOn:YES];
    
    if ([self bht_willShowAnimationBlock])
        [self registerWillShowNotification];
    
    if ([self bht_willHideAnimationBlock])
        [self registerWillHideNotification];
    
    if ([self bht_didShowActionBlock])
        [self registerDidShowNotification];
    
    if ([self bht_didHideActionBlock])
        [self registerDidHideNotification];
}

- (void)registerWillShowNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bht_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)registerWillHideNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bht_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)registerDidShowNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bht_keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)registerDidHideNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bht_keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)bht_unregisterForKeyboardNotifications
{
    [self bht_setNotificationsOn:NO];
    
    if ([self bht_willShowAnimationBlock])
        [self unregisterWillShowNotification];
    
    if ([self bht_willHideAnimationBlock])
        [self unregisterWillHideNotification];
    
    if ([self bht_didShowActionBlock])
        [self unregisterDidShowNotification];
    
    if ([self bht_didHideActionBlock])
        [self unregisterDidHideNotification];
}

- (void)unregisterWillShowNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
- (void)unregisterWillHideNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)unregisterDidShowNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}
- (void)unregisterDidHideNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


#pragma mark - notification callbacks

- (void)bht_keyboardWillShow:(NSNotification *)notification
{
    [self bht_performAnimationBlock:[self bht_willShowAnimationBlock]
                   withNotification:notification];
}

- (void)bht_keyboardWillHide:(NSNotification *)notification
{
    [self bht_performAnimationBlock:[self bht_willHideAnimationBlock]
                   withNotification:notification];
}

- (void)bht_keyboardDidShow:(NSNotification *)notification
{
    [self bht_performAnimationBlock:[self bht_didShowActionBlock]
                   withNotification:notification];
}

- (void)bht_keyboardDidHide:(NSNotification *)notification
{
    [self bht_performAnimationBlock:[self bht_didHideActionBlock]
                   withNotification:notification];
}

- (void)bht_performAnimationBlock:(KeyboardFrameAnimationBlock)animationBlock withNotification:(NSNotification *)notification
{
    if (!animationBlock)
        return;
    
    NSDictionary *info = [notification userInfo];
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger curve                  = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
    CGRect keyboardFrame             = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:curve
                     animations:^{ animationBlock(keyboardFrame); }
                     completion:nil];
}

#pragma mark - methods swizzling

+ (void)load
{
    [self bht_swizzleViewWillApper];
    [self bht_swizzleViewDidDisapper];
    [self bht_swizzleViewDidLoad];
}

#pragma mark viewDidAppear

+ (void)bht_swizzleViewWillApper
{
    Method original, swizz;
    
    original = class_getInstanceMethod([self class], @selector(viewWillAppear:));
    swizz = class_getInstanceMethod([self class], @selector(bht_viewWillAppear:));
    
    method_exchangeImplementations(original, swizz);
}

- (void)bht_viewWillAppear:(BOOL)animated
{
    [self bht_registerForKeyboardNotifications];
    
    [self bht_viewWillAppear:animated];

//    Class selfClass = [self class];
//    if ( (self.view.tag != ViewControllerType_9 || self.view.tag != ViewControllerType_22)
//        && ![selfClass isSubclassOfClass:[UINavigationController class]]
//        && ![selfClass isSubclassOfClass:objc_getClass("_UIRemoteInputViewController")]
//        && ![selfClass isSubclassOfClass:objc_getClass("UIAlertController")]
//        && ![selfClass isSubclassOfClass:objc_getClass("UICompatibilityInputViewController")]
//        && ![selfClass isSubclassOfClass:objc_getClass("MainViewController")]
//        && ![selfClass isSubclassOfClass:objc_getClass("LoanViewController")] )
//    {
//        ViewControllerLogInformation *viewControllerLogInformation = [[ViewControllerLogInformation alloc] initWithUsrId:kClientManagerUid];
//        viewControllerLogInformation.begTime = GET_SYSTEM_DATE_STRING;   // 进入页面时间
//        viewControllerLogInformation.leaveType = 2;
//        viewControllerLogInformation.pageId = self.view.tag;           // 页面id
//        self.viewControllerLogInformation = viewControllerLogInformation;
//    }
}

#pragma mark viewDidDisappear

+ (void)bht_swizzleViewDidDisapper
{
    Method original, swizz;
    
    original = class_getInstanceMethod([self class], @selector(viewDidDisappear:));
    swizz = class_getInstanceMethod([self class], @selector(bht_viewDidDisappear:));
    method_exchangeImplementations(original, swizz);
}

- (void)bht_viewDidDisappear:(BOOL)animated
{
    [self bht_unregisterForKeyboardNotifications];
    
    [self bht_viewDidDisappear:animated];

    if ( self.viewControllerLogInformation ) {
//        NSInteger pageid = self.viewControllerLogInformation.pageId;
//        NSString *userid = self.viewControllerLogInformation.userId;
//        if ( [userid isEqualToString:kNullStr] ) {
//            NSLog(@"userid = %@", userid);
//        }
        self.viewControllerLogInformation.endTime = GET_SYSTEM_DATE_STRING;
        [AnalyticsManager logAppViewController:self.viewControllerLogInformation];
    }
}

#pragma mark

+ (void)bht_swizzleViewDidLoad {
    Method original, swizz;

    original = class_getInstanceMethod([self class], @selector(viewDidLoad));
    swizz = class_getInstanceMethod([self class], @selector(bht_viewDidLoad));
    method_exchangeImplementations(original, swizz);
}

- (void)bht_viewDidLoad {
    [self bht_viewDidLoad];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

//- (UIView *)recursiveFindFirstResponder:(UIView *)view {
//    if ([view isFirstResponder]) {
//        return view;
//    }
//    
//    UIView *found = nil;
//    for (UIView *v in view.subviews) {
//        found = [self recursiveFindFirstResponder:v];
//        if (found) {
//            break;
//        }
//    }
//    return found;
//}

@end
