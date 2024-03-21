//
//  ProductionBuyMainView.m
//  wealth
//
//  Created by wangyingjie on 16/3/29.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "ProductionBuyMainView.h"




@interface ProductionBuyMainView ()<TextFieldDelegate,UITextFieldDelegate>





@end

@implementation ProductionBuyMainView

- (void)dealloc {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [self setUpViews];
        
    }
    return self;
}


#pragma mark- SetupViews
- (void)setUpViews {
    if (self.mainBGView) {
//        _inputView.inputView.myTextField.text = [NSString stringWithFormat:@"%0.f",GET_CLIENT_MANAGER.productionManager.productionBuyModel.startAmount];
//        self.inputMoney = GET_CLIENT_MANAGER.productionManager.productionBuyModel.startAmount;
        
        return;
    }
    
    self.mainBGView = [[UIScrollView alloc] initViewWithFrame:CGRectMake(0, 0, self.width, self.height-49.0f) backgroundColor:[UIColor clearColor]];
    [self addSubview:_mainBGView];
    
    self.titleView = [[ProductionBuyTitleView alloc] initWithFrame:CGRectMake(0, 0, self.width, 111.0f)];
    _titleView.hidden = YES;
    [_mainBGView addSubview:_titleView];
    
    self.inputView = [[ProductionBuyInPutView alloc] initViewWithFrame:CGRectMake(0, 5.0f, self.width, 125.0f) backgroundColor:[UIColor whiteColor]];
    _inputView.inputView.myTextField.delegate = self;
    _inputView.inputView.myTextField.tag = 1010;
    _inputView.inputView.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    _inputView.inputView.myTextField.clearButtonMode = UITextFieldViewModeNever;
    [_mainBGView addSubview:_inputView];
    
    
//    self.moneyView =[[ProductionBuyMoneyView alloc] initViewWithFrame:CGRectMake(0, _inputView.bottom, self.width, 80.0f) backgroundColor:[UIColor clearColor]];
//    [_mainBGView addSubview:_moneyView];
    
    self.moneyView =[[ProductionBuyMoneyView alloc] initViewWithFrame:CGRectMake(0, _inputView.bottom, self.width, 60.0f) backgroundColor:[UIColor clearColor]];
    _moneyView.leftdownView.frame = CGRectMake(ScreenWidth/2.0f, _moneyView.leftUpView.top+2, _moneyView.leftdownView.width, _moneyView.leftdownView.height);
    _moneyView.leftdownView.textAlignment = NSTextAlignmentLeft;
    [_mainBGView addSubview:_moneyView];
    
//    self.managerView = [[ProductionBuyManagerView alloc] initViewWithFrame:CGRectMake(0, _moneyView.bottom, self.width, GET_CLIENT_MANAGER.productionManager.productionBuyModel.haveSales ? 111.0f:94.0f) backgroundColor:[UIColor whiteColor]];
    self.managerView = [[ProductionBuyManagerView alloc] initViewWithFrame:CGRectMake(0, _moneyView.bottom, self.width, GET_CLIENT_MANAGER.productionManager.productionBuyModel.haveSales ? 90.0f:94.0f) backgroundColor:[UIColor whiteColor]];
    _managerView.unNumberView.myTextField.delegate = self;
    _managerView.unNumberView.myTextField.tag = 1020;
    _managerView.unNumberView.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    _managerView.unNumberView.myTextField.clearButtonMode = UITextFieldViewModeNever;
    [_mainBGView addSubview:_managerView];
    
    self.messageView = [[ProductionBuyMessageView alloc] initViewWithFrame:CGRectMake(0, _managerView.bottom, self.width, 110.0f) backgroundColor:[UIColor clearColor]];
    [_mainBGView addSubview:_messageView];
    @weakify(self);
    _messageView.treatyClick = ^{
        @strongify(self);
        if (self.treatyBlock) {
            self.treatyBlock();
        }
    };
    
    _mainBGView.contentSize = CGSizeMake(self.width, _messageView.bottom+5.0f);
    
    GreateButtonType(self.nextButton, CGRectMake(0, self.height - 49.0f, self.width, 49.0f), @"确认出借", YES, self);
    [_nextButton addTapGestureRecognizerWithTarget:self action:@selector(nextClick)];
    
    _inputView.inputView.myTextField.text = [NSString stringWithFormat:@"%0.f",GET_CLIENT_MANAGER.productionManager.productionBuyModel.startAmount];
    self.inputMoney = GET_CLIENT_MANAGER.productionManager.productionBuyModel.startAmount;
    
}

- (void)setIsOK:(BOOL)isOK{
    _isOK = isOK;
    if (isOK) {
//        self.dataModel = [[ProductionBuyDetailModel alloc] init];
//        _dataModel = GET_CLIENT_MANAGER.productionManager.productionBuyModel;
        [self setUpViews];
    }
}


- (void)nextClick{
    ENDEDITING
    if (self.nextButBlock) {
        self.nextButBlock(_inputMoney,_saleId);
    }
}


- (void)setInputMoney:(double)inputMoney{
    _inputMoney = inputMoney;
    [_moneyView setGivenMoney:_inputMoney];
}

//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![Utility verifyNumber:string]) {
        return NO;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString length] > 11) { //如果输入框内容大于10则弹出警告
        textField.text = [toBeString substringToIndex:11];
        if (textField.tag == 1010) {
            self.inputMoney = [textField.text doubleValue];
        }else if (textField.tag == 1020) {
            self.saleId = textField.text;
            _managerView.unNumberView.placeholderLabel.hidden = toBeString.length > 0;
        }
        toBeString = textField.text;
        return NO;
    }
    if (textField.tag == 1010) {
        self.inputMoney = [toBeString doubleValue];
    }else if (textField.tag == 1020) {
        self.saleId = toBeString;
        _managerView.unNumberView.placeholderLabel.hidden = toBeString.length > 0;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length < 1) {
        textField.text = @"0";
    }
    if (textField.tag == 1010) {
        self.inputMoney = [textField.text doubleValue];
//        if (self.inputMoney < GET_CLIENT_MANAGER.productionManager.productionBuyModel.startAmount) {
//            _inputView.inputView.myTextField.text = [NSString stringWithFormat:@"%0.f",GET_CLIENT_MANAGER.productionManager.productionBuyModel.startAmount];
//            self.inputMoney = GET_CLIENT_MANAGER.productionManager.productionBuyModel.startAmount;
//        }
    }else if (textField.tag == 1020) {
        self.saleId = textField.text;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ENDEDITING
}


@end
