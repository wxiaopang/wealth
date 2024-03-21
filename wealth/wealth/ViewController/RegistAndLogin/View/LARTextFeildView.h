//
//  LARTextFeildView.h
//  iqianjin
//
//  Created by wangyingjie on 15/12/21.
//  Copyright © 2015年 iqianjin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LARTextField.h"

@protocol LARTextFeildDelegate <NSObject>

@optional

- (void)LARTextFieldDidBeginEditing:(UITextField *)textField;
- (BOOL)LARTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)LARTextFieldDidEndEditing:(UITextField *)textField;
- (BOOL)LARTextFieldShouldReturn:(UITextField *)textField;
- (BOOL)LARTextFieldShouldClear:(UITextField *)textField;

- (void)clickTheDisPlay;


@end



@interface LARTextFeildView : UIView

@property (nonatomic, strong) LARTextField *contentTextField;        /**<*/
@property (nonatomic, weak) id<LARTextFeildDelegate> LARDelegate; /**<*/
@property (nonatomic, assign) BOOL isSecure;            /**<*/
@property (nonatomic, assign) BOOL isVertifyCode;            /**<*/

@property (nonatomic, strong) NSString *labelText;        /**<*/
@property (nonatomic, strong) UIButton *cleanBut;                   /**<*/

- (void)setupThePlaceholderText:(NSString *)placeholderText AndTextColor:(UIColor *)textColor AndTextFont:(UIFont *)textFont AndIsSecure:(BOOL)isSecure AndTextFieldTag:(NSInteger)LARtag;

- (void)resignfirstResponder;

- (void)becomeFirst;

- (void)clearTheTextField;

- (void)shakeThePlaceholderLabel;


@end
