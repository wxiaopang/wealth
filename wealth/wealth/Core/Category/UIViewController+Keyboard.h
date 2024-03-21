//
//  UIViewController+Keyboard.h
//  wealth
//
//  Created by wangyingjie on 15/3/4.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewControllerLogInformation;

typedef void(^KeyboardFrameAnimationBlock)(CGRect keyboardFrame);

@interface UIViewController (Keyboard)

@property (nonatomic, assign) BOOL enablePanHiddenKeyBoard;
@property (nonatomic, strong) ViewControllerLogInformation *viewControllerLogInformation;

- (void)setKeyboardWillShowAnimationBlock:(KeyboardFrameAnimationBlock)willShowBlock;
- (void)setKeyboardWillHideAnimationBlock:(KeyboardFrameAnimationBlock)willHideBlock;

- (void)setKeyboardDidShowActionBlock:(KeyboardFrameAnimationBlock)didShowBlock;
- (void)setKeyboardDidHideActionBlock:(KeyboardFrameAnimationBlock)didHideBlock;

@end
