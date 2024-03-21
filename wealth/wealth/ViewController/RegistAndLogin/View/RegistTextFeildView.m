//
//  RegistTextFeildView.m
//  wealth
//
//  Created by wangyingjie on 16/3/21.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "RegistTextFeildView.h"

@interface RegistTextFeildView ()<TextFieldDelegate,UITextFieldDelegate>


@property (nonatomic, strong) NSTimer *timer;        /**<*/
@property (nonatomic, assign) NSInteger currentSecond;  /**<*/


@end

@implementation RegistTextFeildView

- (void)dealloc {
    
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
        
        self.currentSecond = kTime;
    }
    return self;
}


#pragma mark- SetupViews
- (void)setUpViews {
    
    self.myTextField  = [[LARTextField alloc] initTextFieldWithFrame:CGRectMake(kLeftCommonMargin, 15.0f, ScreenWidth - kLeftCommonMargin * 2, 18.0f)
                                                                     text:@""
                                                                     font:[UIFont get_C30_CN_NOR_Font]
                                                                textColor:[UIColor get_3_Color]
                                                                  enabled:YES
                                                            textAlignment:NSTextAlignmentCenter
                                                              placeholder:@""];
    _myTextField.returnKeyType = UIReturnKeyDone;
    _myTextField.textColor = [UIColor get_1_Color];
    _myTextField.tintColor = [UIColor get_9_Color];
    [_myTextField setValue:[UIColor get_3_Color] forKeyPath:@"_placeholderLabel.textColor"];
    _myTextField.textAlignment = NSTextAlignmentLeft;
    _myTextField.delegate = self;
    [self addSubview:_myTextField];
    
    self.eyeButton = [[UIButton alloc] initButtonWithFrame:CGRectMake(ScreenWidth - kLeftCommonMargin *2.0f -30.0f, 2, 30.0f + kLeftCommonMargin*2.0f, 30.0f)
                                          backgroundColor:[UIColor clearColor]
                                                     font:[UIFont get_C30_CN_NOR_Font]
                                               titleColor:[UIColor clearColor]
                                                    title:@""];
    [_eyeButton addTarget:self action:@selector(clickTheDis) forControlEvents:UIControlEventTouchUpInside];
    _eyeButton.imageEdgeInsets = UIEdgeInsetsMake(11, kLeftCommonMargin+7, 3,  kLeftCommonMargin+7);
    _eyeButton.backgroundColor = [UIColor clearColor];
    [self addSubview:_eyeButton];
    
    self.botViewLine = [[UIView alloc] initViewWithFrame:CGRectMake(kLeftCommonMargin, self.height-1.0f, ScreenWidth - (kLeftCommonMargin)*2.0f, 0.5f)
                                        backgroundColor:[UIColor get_4_Color]];
    [self addSubview:_botViewLine];
    
    self.midViewLine = [[UIView alloc] initViewWithFrame:CGRectMake(ScreenWidth - 100.0f, (self.height - 18.0f)/2.0f, 0.5, 18.0f)
                                         backgroundColor:[UIColor get_4_Color]];
    [self addSubview:_midViewLine];
    
    self.codeButton = [[UIButton alloc] initButtonWithFrame:CGRectMake(ScreenWidth - 95, _myTextField.top-5.0f, 100-kLeftCommonMargin, 30) backgroundColor:[UIColor clearColor] font:[UIFont get_C30_CN_BOL_Font] titleColor:[UIColor get_9_Color] title:@"获取验证码"];
//    [_codeButton setBackgroundImage:timeImage forState:UIControlStateNormal];
//    [_timeButton setBackgroundImage:timeImage forState:UIControlStateHighlighted];
    [_codeButton addTapGestureRecognizerWithTarget:self action:@selector(getVertify)];
    [self addSubview:_codeButton];
    
    
    _codeButton.hidden = YES;
    _eyeButton.hidden = YES;
    _midViewLine.hidden = YES;
    
}


- (void)clickTheDis{
    _myTextField.secureTextEntry = !_myTextField.secureTextEntry;
    NSRange range = [_myTextField getRangeWithTextField:_myTextField];
    if (range.location == 0) {
        range = NSMakeRange(range.location+1, 0);
        [_myTextField setSelectedRange:range];
        range = NSMakeRange(range.location-1, 0);
    }else{
        range = NSMakeRange(range.location-1, 0);
        [_myTextField setSelectedRange:range];
        range = NSMakeRange(range.location+1, 0);
    }
    
    [_myTextField setSelectedRange:range];
    [self refreshTheButtonImage];
}


//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

- (void)setMessageWithText:(NSString *)placeholderText Andtype:(RegisterTextFeildType) type{
    _myTextField.placeholder = placeholderText;
    switch (type) {
        case RegisterTextFeildType_code:{
            _codeButton.hidden = NO;
            _eyeButton.hidden = YES;
            _midViewLine.hidden = NO;
        }break;
        case RegisterTextFeildType_PWD:{
            _codeButton.hidden = YES;
            _eyeButton.hidden = YES;
            _midViewLine.hidden = YES;
            _myTextField.secureTextEntry = YES;
        }break;
        case RegisterTextFeildType_PWD_eye:{
            _codeButton.hidden = YES;
            _eyeButton.hidden = NO;
            _midViewLine.hidden = YES;
            _myTextField.secureTextEntry = YES;
        }break;
        
            
        case RegisterTextFeildType_none:
        default:{
            _codeButton.hidden = YES;
            _eyeButton.hidden = YES;
            _midViewLine.hidden = YES;
        }break;
    }
    [self refreshTheButtonImage];
    
}

- (void)refreshTheButtonImage{
    UIImage *image = _myTextField.secureTextEntry ? [UIImage imageNamed:@"cloes_eyes"] : [UIImage imageNamed:@"open_eyes"];
    [_eyeButton setImage:image forState:UIControlStateNormal];
    [_eyeButton setImage:image forState:UIControlStateDisabled];
    [_eyeButton setImage:image forState:UIControlStateHighlighted];
}


- (void)getVertify{
    if (_currentSecond != 0 && _currentSecond != kTime) {
        return;
    }
    if (self.getCodeBlock) {
        self.getCodeBlock();
    }
}

#pragma mark -刷新倒计时
-(void)refreshVertifyButtonText{
    _currentSecond--;
    if (_currentSecond>0) {
        [_codeButton setTitle:[NSString stringWithFormat:@"剩余%ld秒",(long)_currentSecond] forState:UIControlStateNormal];
        [_codeButton setEnabled:NO];
    }else{
        [_codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
        if (_timer!=nil) {
            [_timer invalidate];
            _timer=nil;
        }
        [_codeButton setEnabled:YES];
    }
}
#pragma mark - 开始倒计时
-(void)startCountdown{
    if (_timer!=nil) {
        [_timer invalidate];
        _timer=nil;
    }
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshVertifyButtonText) userInfo:nil repeats:YES];
    _currentSecond=kTime;
    [_codeButton setTitle:[NSString stringWithFormat:@"剩余%ld秒",(long)_currentSecond] forState:UIControlStateNormal];
    [_codeButton setEnabled:NO];
}
#pragma mark - 结束倒计时
-(void)stopCountdown{
    if (_timer!=nil) {
        [_timer invalidate];
        _timer=nil;
    }
    [_codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [_codeButton setEnabled:YES];
    _currentSecond = kTime;
}


#pragma mark- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.REGDelegate && [self.REGDelegate respondsToSelector:@selector(REGTextFieldDidBeginEditing:)]) {
        [self.REGDelegate REGTextFieldDidBeginEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL result = YES;
    if ([string isEqualToString:@" "] || [string isEqualToString:@"\n"] || [string isEqualToString:@"\t"]) {
        return NO;
    }
    
    if (self.REGDelegate && [self.REGDelegate respondsToSelector:@selector(REGTextField:shouldChangeCharactersInRange:replacementString:)]) {
        result = [self.REGDelegate REGTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return result;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.REGDelegate && [self.REGDelegate respondsToSelector:@selector(REGTextFieldDidEndEditing:)]) {
        [self.REGDelegate REGTextFieldDidEndEditing:textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL result = YES;
    [self resignfirstResponder];
    if (self.REGDelegate && [self.REGDelegate respondsToSelector:@selector(REGTextFieldShouldReturn:)]) {
        [self.REGDelegate REGTextFieldShouldReturn:textField];
    }
    return result;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    BOOL result = YES;
    if (self.REGDelegate && [self.REGDelegate respondsToSelector:@selector(REGTextFieldShouldClear:)]) {
        [self.REGDelegate REGTextFieldShouldClear:textField];
    }
    return result;
}

#pragma mark  ----- 点击页面停止编辑
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignfirstResponder];
}

#pragma mark  ----- textField停止编辑
- (void)resignfirstResponder{
    if ([_myTextField isFirstResponder]) {
        [_myTextField resignFirstResponder];
    }
}

#pragma mark  ----- textField开始编辑
- (void)becomeFirst{
    [_myTextField becomeFirstResponder];
}

#pragma mark  ----- 清除textfield
- (void)clearTheTextField{
//    _contentTextField.text = @"";
//    _placeholderLabel.hidden = NO;
//    //    [self resignfirstResponder];
//    if (_isSecure) {
//        _contentTextField.secureTextEntry = !_isDisplay;
//    }else{
//        _cleanBut.hidden = YES;
//    }
//    [self refreshTheButtonImage];
}




@end
