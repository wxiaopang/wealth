//
//  SetChangePWDView.m
//  wealth
//
//  Created by wangyingjie on 16/3/23.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "SetChangePWDView.h"

@interface SetChangePWDView ()<REGTextFeildDelegate>

@end

@implementation SetChangePWDView

- (void)dealloc {
    
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
        
        self.phoneString = @"";
        self.codeString = @"";
    }
    return self;
}


#pragma mark- SetupViews
- (void)setUpViews {
    GreateLabelf(self.messageLabel, [UIColor get_1_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentLeft, self);
    GreateLabelf(self.phoneLabel, [UIColor get_9_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentLeft, self);
    
    self.phoneTextField = [[RegistTextFeildView alloc] initViewWithFrame:CGRectMake(0, 49.0f, ScreenWidth, 49.0f) backgroundColor:[UIColor whiteColor]];
    [_phoneTextField setMessageWithText:@"请输入手机号" Andtype:RegisterTextFeildType_none];
    _phoneTextField.botViewLine.frame = CGRectMake(0, _phoneTextField.botViewLine.frame.origin.y, ScreenWidth, 0.5f);
    _phoneTextField.myTextField.tag = 1010;
    _phoneTextField.REGDelegate = self;
    _phoneTextField.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_phoneTextField];
    _phoneTextField.botViewLine.backgroundColor = [UIColor get_5_Color];
    
    self.codeTextField = [[RegistTextFeildView alloc] initViewWithFrame:CGRectMake(0, _phoneTextField.bottom, ScreenWidth, 49.0f) backgroundColor:[UIColor whiteColor]];
    [_codeTextField setMessageWithText:@"请输短信验证码" Andtype:RegisterTextFeildType_code];
    _codeTextField.botViewLine.hidden = YES;
    _codeTextField.myTextField.tag = 1011;
    _codeTextField.REGDelegate = self;
    _codeTextField.myTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self addSubview:_codeTextField];
    _codeTextField.midViewLine.backgroundColor = [UIColor get_5_Color];

    GreateButtonType(self.nextButton, CGRectMake(kLeftCommonMargin, _codeTextField.bottom + 25.0f, ScreenWidth-2*kLeftCommonMargin, 49.0f), @"验证信息", YES, self);
    [_nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setMessage:(NSString *)message AndPhone:(NSString *)phone{
    if (message && message.length > 0) {
        [_messageLabel setAdaptionWidthWithText:message];
        _messageLabel.frame = CGRectMake(kLeftCommonMargin, (49.0f-16.0)/2.0f, _messageLabel.width, 16.0f);
    }
    if (phone && phone.length > 0) {
        [_phoneLabel setAdaptionWidthWithText:phone];
        _phoneLabel.frame = CGRectMake(_messageLabel.right+2.0f, (49.0f-16.0)/2.0f, _phoneLabel.width, 16.0f);
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

#pragma mark -LARDelegate

- (BOOL)REGTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString length] > 11) { //如果输入框内容大于20则弹出警告
        textField.text = [toBeString substringToIndex:11];
        if (textField.tag == 1010) {
            self.phoneString = toBeString;
        }else if (textField.tag == 1011) {
            self.codeString = toBeString;
        }
        return NO;
    }
    
    if (textField.tag == 1010) {
        self.phoneString = toBeString;
    }else if (textField.tag == 1011) {
        self.codeString = toBeString;
    }
    
    
    return YES;
}
- (void)REGTextFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1010) {
        self.phoneString = textField.text;
    }else if (textField.tag == 1011) {
        self.codeString = textField.text;
    }
    
    
}
- (BOOL)REGTextFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}
- (BOOL)REGTextFieldShouldClear:(UITextField *)textField{
    
    return YES;
}



@end
