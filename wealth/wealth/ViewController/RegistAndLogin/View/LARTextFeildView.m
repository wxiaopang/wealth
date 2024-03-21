//
//  LARTextFeildView.m
//  iqianjin
//
//  Created by wangyingjie on 15/12/21.
//  Copyright © 2015年 iqianjin. All rights reserved.
//

#import "LARTextFeildView.h"


#define kbottomLineWidth (ScreenWidth - (kLeftCommonMargin+5.0f)*2.0f)
#define ktime1 0.3
#define ktime2 0.5


@interface LARTextFeildView ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *placeholderLabel;            /**<*/

@property (nonatomic, strong) UIView *bottomLine;                   /**<*/


@property (nonatomic, assign) BOOL isDisplay;                       /**<*/

@property (nonatomic, strong) UIColor *labelColor;                   /**<*/
@property (nonatomic, strong) UIFont *labelFont;                   /**<*/

@end

@implementation LARTextFeildView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isSecure = NO;
        self.isDisplay = NO;
//        self.labelColor = [UIColor f3Color];
        self.labelFont = FONT_CN_NORMAL(15);
        self.labelText = @"";
        self.isVertifyCode = NO;
        [self setUpViews];
    }
    return self;
}


#pragma mark- SetupViews
- (void)setUpViews {

    GreateLabel(self.placeholderLabel, _labelColor, 15.0f, NSTextAlignmentCenter, self);
    _placeholderLabel.frame = CGRectMake(kLeftCommonMargin, 5.0f, ScreenWidth - kLeftCommonMargin * 2, 30.0f);
    _placeholderLabel.textColor = [UIColor get_3_Color];
    
    self.contentTextField  = [[LARTextField alloc] initTextFieldWithFrame:CGRectMake(kLeftCommonMargin, 5.0f, ScreenWidth - kLeftCommonMargin * 2, 30.0f)
                                                                     text:@""
                                                                     font:FONT_CN_NORMAL(30)
                                                                textColor:[UIColor get_3_Color]
                                                                  enabled:YES
                                                            textAlignment:NSTextAlignmentCenter
                                                              placeholder:@""];
    _contentTextField.returnKeyType = UIReturnKeyDone;
    _contentTextField.delegate = self;
    _contentTextField.textColor = [UIColor get_1_Color];
    _contentTextField.tintColor = [UIColor get_9_Color];
    [_contentTextField setValue:[UIColor get_3_Color] forKeyPath:@"_placeholderLabel.textColor"];
    [self addSubview:_contentTextField];
    
    self.cleanBut = [[UIButton alloc] initButtonWithFrame:CGRectMake(ScreenWidth - kLeftCommonMargin *2.0f -30.0f, 2, 30.0f + kLeftCommonMargin*2.0f, 30.0f)
                                           backgroundColor:[UIColor clearColor]
                                                      font:[UIFont get_C30_CN_NOR_Font]
                                                titleColor:[UIColor clearColor]
                                                     title:@""];
    [_cleanBut addTarget:self action:@selector(clickTheDis) forControlEvents:UIControlEventTouchUpInside];
    _cleanBut.imageEdgeInsets = UIEdgeInsetsMake(11, kLeftCommonMargin+7, 3,  kLeftCommonMargin+7);
    _cleanBut.backgroundColor = [UIColor clearColor];
    [self addSubview:_cleanBut];
    
    self.bottomLine = [[UIView alloc] initViewWithFrame:CGRectMake(kLeftCommonMargin+5.0f, _contentTextField.bottom + 10, ScreenWidth - (kLeftCommonMargin+5.0f)*2.0f, 0.5f)
                                         backgroundColor:[UIColor get_4_Color]];
    [self addSubview:_bottomLine];
    
}


- (void)setupThePlaceholderText:(NSString *)placeholderText AndTextColor:(UIColor *)textColor AndTextFont:(UIFont *)textFont AndIsSecure:(BOOL)isSecure AndTextFieldTag:(NSInteger)LARtag{
    
    [_placeholderLabel setAdaptionWidthWithText:placeholderText];
    _placeholderLabel.center = CGPointMake(ScreenWidth/2.0f, _placeholderLabel.center.y);
    _labelText = placeholderText;
    if (textColor) {
        _placeholderLabel.textColor = [UIColor get_3_Color];
        _contentTextField.textColor = textColor;
        _labelColor = textColor;
    }
    if (textFont) {
        _contentTextField.font = textFont;
        _placeholderLabel.font = textFont;
        _labelFont = textFont;
    }
    self.isSecure = isSecure;
    _contentTextField.tag = LARtag;
}

#pragma mark  ----- set方法
-(void)setIsSecure:(BOOL)isSecure{
    _isSecure = isSecure;
    if (isSecure) {
        _contentTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _cleanBut.hidden = NO;
    }else{
        _cleanBut.hidden = _contentTextField.text.length <= 0;
    }
    
    [self refreshTheButtonImage];
}

- (void)setIsVertifyCode:(BOOL)isVertifyCode{
    _isVertifyCode = isVertifyCode;
    if (_isVertifyCode) {
        [self.cleanBut removeFromSuperview];
        _contentTextField.keyboardType = UIKeyboardTypeASCIICapable;
    }
}

- (void)setLabelText:(NSString *)labelText{
    if (_labelText != labelText) {
        _labelText = labelText;
    }    
}

#pragma mark  ----- 点击清除按钮
- (void)clickTheDis{
    NSRange range = [_contentTextField getRangeWithTextField:_contentTextField];
    if (range.location == 0) {
        range = NSMakeRange(range.location+1, 0);
        [_contentTextField setSelectedRange:range];
        range = NSMakeRange(range.location-1, 0);
    }else{
        range = NSMakeRange(range.location-1, 0);
        [_contentTextField setSelectedRange:range];
        range = NSMakeRange(range.location+1, 0);
    }
    
    [_contentTextField setSelectedRange:range];
    if (_isSecure) {
        if (self.LARDelegate && [self.LARDelegate respondsToSelector:@selector(clickTheDisPlay)]) {
            [self.LARDelegate clickTheDisPlay];
        }
        _isDisplay = !_isDisplay;
        _contentTextField.secureTextEntry = !_isDisplay;
        NSString *ddd = [_contentTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        _contentTextField.text = ddd;
    }else{
        _contentTextField.text = @"";
        _cleanBut.hidden = YES;
        _placeholderLabel.hidden = NO;
        [_contentTextField becomeFirstResponder];
    }
    [self refreshTheButtonImage];
    
}

#pragma mark  ----- 刷新清除按钮显示
- (void)refreshTheButtonImage{
    UIImage *image = _isSecure ? (_isDisplay ? [UIImage imageNamed:@"open_eyes"] : [UIImage imageNamed:@"cloes_eyes"]) : [UIImage imageNamed:@"icon_clean"];
    [_cleanBut setImage:image forState:UIControlStateNormal];
    [_cleanBut setImage:image forState:UIControlStateDisabled];
    [_cleanBut setImage:image forState:UIControlStateHighlighted];
}


#pragma mark- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.LARDelegate && [self.LARDelegate respondsToSelector:@selector(LARTextFieldDidBeginEditing:)]) {
        [self.LARDelegate LARTextFieldDidBeginEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL result = YES;
    if ([string isEqualToString:@" "] || [string isEqualToString:@"\n"] || [string isEqualToString:@"\t"]) {
        return NO;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (!_isSecure) {
        if (toBeString.length > 0 || textField.text.length > 1) {
            _cleanBut.hidden = NO;
        }else{
            _cleanBut.hidden = YES;
        }
    }
    if (toBeString.length > 0 || textField.text.length > 1) {
        _placeholderLabel.hidden = YES;
//        if (_isSecure) {
//            if (string.length < 1 && !_isDisplay) {
//                _placeholderLabel.hidden = NO;
//            }else{
//                _placeholderLabel.hidden = YES;
//            }
//        }
    }else{
        _placeholderLabel.hidden = NO;
    }
    
    
    
    if (self.LARDelegate && [self.LARDelegate respondsToSelector:@selector(LARTextField:shouldChangeCharactersInRange:replacementString:)]) {
        result = [self.LARDelegate LARTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return result;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    if (textField.text.length < 1) {
        _placeholderLabel.hidden = NO;
    }else{
        _placeholderLabel.hidden = YES;
    }
    if (self.LARDelegate && [self.LARDelegate respondsToSelector:@selector(LARTextFieldDidEndEditing:)]) {
        [self.LARDelegate LARTextFieldDidEndEditing:textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL result = YES;
    [self resignfirstResponder];
    if (self.LARDelegate && [self.LARDelegate respondsToSelector:@selector(LARTextFieldShouldReturn:)]) {
        [self.LARDelegate LARTextFieldShouldReturn:textField];
    }
    return result;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    BOOL result = YES;
    if (self.LARDelegate && [self.LARDelegate respondsToSelector:@selector(LARTextFieldShouldClear:)]) {
        [self.LARDelegate LARTextFieldShouldClear:textField];
    }
    return result;
}

#pragma mark  ----- 点击页面停止编辑
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignfirstResponder];
}

#pragma mark  ----- textField停止编辑
- (void)resignfirstResponder{
    if ([_contentTextField isFirstResponder]) {
        [_contentTextField resignFirstResponder];
    }
}

#pragma mark  ----- textField开始编辑
- (void)becomeFirst{
    [_contentTextField becomeFirstResponder];
}

#pragma mark  ----- 清除textfield
- (void)clearTheTextField{
    _contentTextField.text = @"";
    _placeholderLabel.hidden = NO;
//    [self resignfirstResponder];
    if (_isSecure) {
        _contentTextField.secureTextEntry = !_isDisplay;
    }else{
        _cleanBut.hidden = YES;
    }
    [self refreshTheButtonImage];
}

#pragma mark  ----- aleLabel 抖动
- (void)shakeThePlaceholderLabel{
    [self shakeAnimationForView:_placeholderLabel];
}

- (void)shakeAnimationForView:(UILabel *) view{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint x = CGPointMake(position.x + 10, position.y);
    CGPoint y = CGPointMake(position.x - 10, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:.06];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}

@end
