//
//  SetPWDView.m
//  wealth
//
//  Created by wangyingjie on 16/3/23.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "SetPWDView.h"

@interface SetPWDView ()<REGTextFeildDelegate>

@end


@implementation SetPWDView

- (void)dealloc {
    
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}


#pragma mark- SetupViews
- (void)setUpViews {
    GreateLabelf(self.messageLabel, [UIColor get_1_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentLeft, self);
    
    
    self.pwdTextField = [[RegistTextFeildView alloc] initViewWithFrame:CGRectMake(0, 49.0f, ScreenWidth, 49.0f) backgroundColor:[UIColor whiteColor]];
    [_pwdTextField setMessageWithText:@"请输入6-20位数字字母密码组合" Andtype:RegisterTextFeildType_PWD_eye];
    _pwdTextField.botViewLine.hidden = YES;
    _pwdTextField.myTextField.tag = 1010;
    _pwdTextField.REGDelegate = self;
    [self addSubview:_pwdTextField];
    
    GreateButtonType(self.nextButton, CGRectMake(kLeftCommonMargin, _pwdTextField.bottom + 25.0f, ScreenWidth-2*kLeftCommonMargin, 49.0f), @"完成", YES, self);
    [_nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self setMessage:@"请重新设置您的登录密码"];
    
}

- (void)setMessage:(NSString *)message{
    if (message && message.length > 0) {
        [_messageLabel setAdaptionWidthWithText:message];
        _messageLabel.frame = CGRectMake(kLeftCommonMargin, (49.0f-16.0)/2.0f, _messageLabel.width, 16.0f);
    }

}


- (void)nextClick{
    if (self.nextBlock) {
        self.nextBlock();
    }
}


//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

- (BOOL)REGTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString length] > 25) { //如果输入框内容大于20则弹出警告
        textField.text = [toBeString substringToIndex:25];
        if (textField.tag == 1010) {
            self.pwdString = toBeString;
        }
        return NO;
    }
    if (textField.tag == 1010) {
        self.pwdString = toBeString;
    }
    return YES;
}
- (void)REGTextFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1010) {
        self.pwdString = textField.text;
    }
}
- (BOOL)REGTextFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}
- (BOOL)REGTextFieldShouldClear:(UITextField *)textField{
    
    return YES;
}

@end
