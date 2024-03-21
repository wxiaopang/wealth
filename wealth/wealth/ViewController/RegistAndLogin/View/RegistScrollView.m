//
//  RegistScrollView.m
//  wealth
//
//  Created by wangyingjie on 16/3/21.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "RegistScrollView.h"

@interface RegistScrollView ()<REGTextFeildDelegate>

@end

@implementation RegistScrollView

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
        
        self.phoneString = kNullStr;
        self.codeString = kNullStr;
        self.pwd1String = kNullStr;
        self.pwd2String = kNullStr;
        
    }
    return self;
}


#pragma mark- SetupViews
- (void)setUpViews {
    //注册键盘弹起通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //注册键盘消失通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    self.phoneTextFeild = [[RegistTextFeildView alloc] initViewWithFrame:CGRectMake(0, 10.0f, ScreenWidth, 49.0f) backgroundColor:[UIColor clearColor]];
    [_phoneTextFeild setMessageWithText:@"请输入手机号" Andtype:RegisterTextFeildType_none];
    _phoneTextFeild.myTextField.tag = 1010;
    _phoneTextFeild.REGDelegate = self;
    _phoneTextFeild.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_phoneTextFeild];
    
    self.codeTextFeild = [[RegistTextFeildView alloc] initViewWithFrame:CGRectMake(0, _phoneTextFeild.bottom + 10.0f, ScreenWidth, 49.0f) backgroundColor:[UIColor clearColor]];
    [_codeTextFeild setMessageWithText:@"请输入短信验证码" Andtype:RegisterTextFeildType_code];
    _codeTextFeild.myTextField.tag = 1011;
    _codeTextFeild.myTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _codeTextFeild.REGDelegate = self;
    [self addSubview:_codeTextFeild];
    
    self.pwdEyeTextFeild = [[RegistTextFeildView alloc] initViewWithFrame:CGRectMake(0, _codeTextFeild.bottom + 10.0f, ScreenWidth, 49.0f) backgroundColor:[UIColor clearColor]];
    [_pwdEyeTextFeild setMessageWithText:@"请输入6-20位数字字母密码组合" Andtype:RegisterTextFeildType_PWD_eye];
    _pwdEyeTextFeild.myTextField.tag = 1012;
    _pwdEyeTextFeild.REGDelegate = self;
    [self addSubview:_pwdEyeTextFeild];
    
//    self.pwdTextFeild = [[RegistTextFeildView alloc] initViewWithFrame:CGRectMake(0, _pwdEyeTextFeild.bottom + 10.0f, ScreenWidth, 49.0f) backgroundColor:[UIColor clearColor]];
//    [_pwdTextFeild setMessageWithText:@"请再次输入密码" Andtype:RegisterTextFeildType_PWD];
//    _pwdTextFeild.myTextField.tag = 1013;
//    _pwdTextFeild.REGDelegate = self;
//    [self addSubview:_pwdTextFeild];
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _pwdEyeTextFeild.bottom + 10.0f, ScreenWidth, 23)];
    [_messageLabel setAdaptionWidthWithAttributedText:@"注册账户表示您同意" textFont:FONT_CN_NORMAL(28) textColor:[UIColor get_2_Color] textLineStyle:NSUnderlineStyleNone unitText:@"《注册及服务协议》" unitFont:FONT_CN_NORMAL(28) unitColor:[UIColor get_9_Color] unitLineStyle:NSUnderlineStyleSingle];
    _messageLabel.center = CGPointMake(ScreenWidth/2.0f, _messageLabel.center.y);
    _messageLabel.userInteractionEnabled = YES;
    [_messageLabel addTapGestureRecognizerWithTarget:self action:@selector(messageLabelClick)];
    [self addSubview:_messageLabel];
    
    
    UIImage *normalImage = [[UIImage imageNamed:@"big_button"] stretchableImageWithLeftCapWidth:50 topCapHeight:45];
    UIImage *highlightedImage = [[UIImage imageNamed:@"big_button_click"] stretchableImageWithLeftCapWidth:50 topCapHeight:45];
    
    self.topButton = [[UIButton alloc] initButtonWithFrame:CGRectMake(45.0f, _messageLabel.bottom + (10.0f)*1.5f, ScreenWidth-90.0f, 45.0f) backgroundColor:[UIColor clearColor] font:FONT_CN_NORMAL(34) titleColor:[UIColor whiteColor] title:@"注册"];
    [_topButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [_topButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [_topButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_topButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_topButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _topButton.layer.masksToBounds = YES;
    _topButton.layer.cornerRadius = 3.0f;
    [_topButton addTapGestureRecognizerWithTarget:self action:@selector(topButtonClick)];
    [self addSubview:_topButton];
    
    self.botButton = [[UIButton alloc] initButtonWithFrame:CGRectMake(45.0f, _topButton.bottom + (10.0f)*0.6, ScreenWidth-90.0f, 45.0f) backgroundColor:[UIColor clearColor] font:FONT_CN_NORMAL(34) titleColor:[UIColor get_9_Color] title:@"登录"];
    [_botButton addTapGestureRecognizerWithTarget:self action:@selector(botButtonClick)];
    [self addSubview:_botButton];
    
}


//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}



- (void)topButtonClick{
    if (self.topButtonBlock) {
        self.topButtonBlock();
    }
}

- (void)botButtonClick{
    if (self.botButtonBlock) {
        self.botButtonBlock();
    }
}

- (void)messageLabelClick{
    if (self.messageBlock) {
        self.messageBlock();
    }
}


#pragma mark - notification
- (void)keyboardWillShow:(NSNotification *)note
{
//    [UIView animateWithDuration:0.26 animations:^{
        self.contentSize = CGSizeMake(ScreenWidth, ScreenHeight+(ScreenHeight>568 ? 80 : 40));
//        self.contentOffset = CGPointMake(0, (ScreenHeight>568 ? 150 : 120));
//        if (ScreenHeight > 568) {
//            _messageLabel.frame = CGRectMake(_messageLabel.left, _height1 - 10.0f, _messageLabel.width, _messageLabel.height);
//            _topButton.frame = CGRectMake(_topButton.left, _height2 - 20.0f, _topButton.width, _topButton.height);
//            _botButton.frame = CGRectMake(_botButton.left, _height3 - 30.0f, _botButton.width, _botButton.height);
//        }
//    } completion:^(BOOL finished) {
//        
//    }];
}

- (void)keyboardWillHide:(NSNotification *)note{
//    [UIView animateWithDuration:0.26 animations:^{
        self.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
        self.contentOffset = CGPointMake(0, 0);
//        if (ScreenHeight > 568) {
//            _messageLabel.frame = CGRectMake(_messageLabel.left, _height1, _messageLabel.width, _messageLabel.height);
//            _topButton.frame = CGRectMake(_topButton.left, _height2, _topButton.width, _topButton.height);
//            _botButton.frame = CGRectMake(_botButton.left, _height3, _botButton.width, _botButton.height);
//        }
//    } completion:^(BOOL finished) {
//        
//    }];
}



#pragma mark -LARDelegate

- (BOOL)REGTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString length] > 25) { //如果输入框内容大于20则弹出警告
        textField.text = [toBeString substringToIndex:25];
        if (textField.tag == 1010) {
            self.phoneString = toBeString;
        }else if (textField.tag == 1011) {
            self.codeString = toBeString;
        }else if (textField.tag == 1012) {
            self.pwd1String = toBeString;
        }else if (textField.tag == 1013) {
            self.pwd2String = toBeString;
        }
        return NO;
    }else{
        if (textField.tag == 1010) {
            if ([toBeString length] > 11) {
                textField.text = [toBeString substringToIndex:11];
                self.phoneString = toBeString;
                return NO;
            }
        }else if (textField.tag == 1011) {
            if ([toBeString length] > 11) {
                textField.text = [toBeString substringToIndex:11];
                self.codeString = toBeString;
                return NO;
            }
        }
    }
    
    
    if (textField.tag == 1010) {
        self.phoneString = toBeString;
    }else if (textField.tag == 1011) {
        self.codeString = toBeString;
    }else if (textField.tag == 1012) {
        self.pwd1String = toBeString;
    }else if (textField.tag == 1013) {
        self.pwd2String = toBeString;
    }
    
    
    return YES;
}
- (void)REGTextFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1010) {
        self.phoneString = textField.text;
    }else if (textField.tag == 1011) {
        self.codeString = textField.text;
    }else if (textField.tag == 1012) {
        self.pwd1String = textField.text;
    }else if (textField.tag == 1013) {
        self.pwd2String = textField.text;
    }
    
    
}
- (BOOL)REGTextFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}
- (BOOL)REGTextFieldShouldClear:(UITextField *)textField{
    
    return YES;
}



@end
