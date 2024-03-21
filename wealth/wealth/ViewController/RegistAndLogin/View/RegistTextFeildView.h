//
//  RegistTextFeildView.h
//  wealth
//
//  Created by wangyingjie on 16/3/21.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LARTextField.h"

@protocol REGTextFeildDelegate <NSObject>

@optional

- (void)REGTextFieldDidBeginEditing:(UITextField *)textField;
- (BOOL)REGTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)REGTextFieldDidEndEditing:(UITextField *)textField;
- (BOOL)REGTextFieldShouldReturn:(UITextField *)textField;
- (BOOL)REGTextFieldShouldClear:(UITextField *)textField;

- (void)clickTheDisPlay;


@end



@interface RegistTextFeildView : UIView

@property (nonatomic, strong) LARTextField *myTextField;
@property (nonatomic, strong) UIView *midViewLine;
@property (nonatomic, strong) UIView *botViewLine;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) UIButton *eyeButton;

@property (nonatomic, weak) id<REGTextFeildDelegate> REGDelegate; /**<*/

@property (nonatomic, copy) VoidBlock getCodeBlock;

- (void)setMessageWithText:(NSString *)placeholderText Andtype:(RegisterTextFeildType) type;


#pragma mark -刷新倒计时
-(void)refreshVertifyButtonText;
#pragma mark - 开始倒计时
-(void)startCountdown;
#pragma mark - 结束倒计时
-(void)stopCountdown;


@end
