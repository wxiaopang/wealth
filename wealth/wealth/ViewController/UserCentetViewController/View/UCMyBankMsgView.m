//
//  UCMyBankMsgView.m
//  wealth
//
//  Created by wangyingjie on 16/4/19.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UCMyBankMsgView.h"



@interface UCMyBankMsgView ()<UITextFieldDelegate>

@end

@implementation UCMyBankMsgView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
        self.name = @"";
        self.idcard = @"";
        self.bankid = @"";
        self.bankNo = @"";
        self.phone = @"";
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
    
    
    self.nameView = [[UCBankMsgInputView alloc] initWithFrame:CGRectMake(0, 15.0, self.width, 49.0f)];
    [self addSubview:_nameView];
    
    self.idView = [[UCBankMsgInputView alloc] initWithFrame:CGRectMake(0, _nameView.bottom, self.width, 49.0f)];
    _idView.upLine.hidden = YES;
    [self addSubview:_idView];
    
    self.bankView = [[UCBankMsgInputView alloc] initWithFrame:CGRectMake(0, _idView.bottom+15.0f, self.width, 49.0f)];
    [self addSubview:_bankView];
    
    self.bankNoView = [[UCBankMsgInputView alloc] initWithFrame:CGRectMake(0, _bankView.bottom, self.width, 49.0f)];
    _bankNoView.upLine.hidden = YES;
    [self addSubview:_bankNoView];
    
    self.phoneView = [[UCBankMsgInputView alloc] initWithFrame:CGRectMake(0, _bankNoView.bottom, self.width, 49.0f)];
    _phoneView.upLine.hidden = YES;
    [self addSubview:_phoneView];
    
    GreateButtonType(self.nextButton, CGRectMake(kLeftCommonMargin, _phoneView.bottom + 44.0f, self.width-2*kLeftCommonMargin, 49.0f), @"立即鉴权", YES, self);
    [_nextButton addTapGestureRecognizerWithTarget:self action:@selector(nextClicked)];
    
    
    [_nameView setNameKey:@"姓名" AndValue:@"请填写您的开户姓名"];
    [_idView setNameKey:@"身份证号" AndValue:@"请填写您的身份证号"];
    [_bankView setNameKey:@"选择银行" AndValue:@"请选择您的开户银行" UseNext:YES];
    [_bankNoView setNameKey:@"银行卡号" AndValue:@"请填写您的银行卡号"];
    [_phoneView setNameKey:@"手机号码" AndValue:@"请填写您的银行预留手机号"];
    
    [_bankView addTapGestureRecognizerWithTarget:self action:@selector(selectTheBank)];
    
    _nameView.inputTextField.tag = 1010;
    _idView.inputTextField.tag = 1011;
    _bankView.inputTextField.tag = 1012;
    _bankNoView.inputTextField.tag = 1013;
    _phoneView.inputTextField.tag = 1014;
    
    _nameView.inputTextField.delegate = self;
    _idView.inputTextField.delegate = self;
    _bankView.inputTextField.delegate = self;
    _bankNoView.inputTextField.delegate = self;
    _phoneView.inputTextField.delegate = self;
    
    _idView.inputTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _bankNoView.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneView.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    
}

- (void)selectTheBank{
    ENDEDITING
    if (self.bankSelectBlock) {
        self.bankSelectBlock();
    }
}

- (void)nextClicked{
    ENDEDITING
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

#pragma mark - notification
- (void)keyboardWillShow:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
//    [UIView animateWithDuration:0.26 animations:^{
        self.contentSize = CGSizeMake(ScreenWidth, MAX(self.height, 368.0f + keyboardSize.height + 40.0f));
//        if ([_nameView.inputTextField isEditing]) {
//            self.contentOffset = CGPointMake(0, 0);
//        }else if ([_idView.inputTextField isEditing]) {
//            self.contentOffset = CGPointMake(0, ((self.contentSize.height-self.height)*1.0f/4.0f));
//        }else if ([_bankView.inputTextField isEditing]) {
//            self.contentOffset = CGPointMake(0, ((self.contentSize.height-self.height)*2.0f/4.0f));
//        }else if ([_bankNoView.inputTextField isEditing]) {
//            self.contentOffset = CGPointMake(0, ((self.contentSize.height-self.height)*3.0f/4.0f));
//        }else if ([_phoneView.inputTextField isEditing]) {
//            self.contentOffset = CGPointMake(0, ((self.contentSize.height-self.height)*4.0f/4.0f));
//        }else{
//            self.contentOffset = CGPointMake(0, 0);
//        }
////        self.contentOffset = CGPointMake(0, (ScreenHeight>568 ? 150 : 120));
//    } completion:^(BOOL finished) {
//        
//    }];
}

- (void)keyboardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:0.26 animations:^{
        self.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
        self.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        
    }];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
     NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (textField.tag) {
        case 1010:{
            if (toBeString.length > 30) {
                textField.text = [toBeString substringToIndex:30];
                return NO;
            }
            
        }break;
        case 1011:{
            NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789xX"];
            NSRange range = [string rangeOfCharacterFromSet:tmpSet];
            if (range.length == 0 && string.length > 0) {
                return NO;
            }
            if (toBeString.length > 20) {
                textField.text = [toBeString substringToIndex:20];
                return NO;
            }
        }break;
        case 1012:{
            if (toBeString.length > 20) {
                textField.text = [toBeString substringToIndex:20];
                return NO;
            }
        }break;
        case 1013:{
            if (toBeString.length > 20) {
                textField.text = [toBeString substringToIndex:20];
                return NO;
            }
        }break;
        case 1014:{
            if (toBeString.length > 15) {
                textField.text = [toBeString substringToIndex:15];
                return NO;
            }
        }break;
            
        default:
            break;
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 1010:{
            _name = textField.text ? textField.text : @"";
        }break;
        case 1011:{
            _idcard = textField.text ? textField.text : @"";
        }break;
        case 1012:{
            _bankid = textField.text ? textField.text : @"";
        }break;
        case 1013:{
            _bankNo = textField.text ? textField.text : @"";
        }break;
        case 1014:{
            _phone = textField.text ? textField.text : @"";
        }break;
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.26 animations:^{
//        self.contentSize = CGSizeMake(ScreenWidth, MAX(self.height, 368.0f + keyboardSize.height + 40.0f));
        if ([_nameView.inputTextField isEditing]) {
            self.contentOffset = CGPointMake(0, 0);
        }else if ([_idView.inputTextField isEditing]) {
            self.contentOffset = CGPointMake(0, ((self.contentSize.height-self.height)*1.0f/4.0f));
        }else if ([_bankView.inputTextField isEditing]) {
            self.contentOffset = CGPointMake(0, ((self.contentSize.height-self.height)*2.0f/4.0f));
        }else if ([_bankNoView.inputTextField isEditing]) {
            self.contentOffset = CGPointMake(0, ((self.contentSize.height-self.height)*3.0f/4.0f));
        }else if ([_phoneView.inputTextField isEditing]) {
            self.contentOffset = CGPointMake(0, ((self.contentSize.height-self.height)*4.0f/4.0f));
        }else{
            self.contentOffset = CGPointMake(0, 0);
        }
        //        self.contentOffset = CGPointMake(0, (ScreenHeight>568 ? 150 : 120));
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    ENDEDITING
    return YES;
}


@end
