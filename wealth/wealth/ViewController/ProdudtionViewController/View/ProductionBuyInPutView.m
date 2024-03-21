//
//  ProductionBuyInPutView.m
//  wealth
//
//  Created by wangyingjie on 16/3/29.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "ProductionBuyInPutView.h"



@interface ProductionBuyInPutView ()

@end

@implementation ProductionBuyInPutView

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
    
    GreateLabelf(self.titleLabel, [UIColor get_2_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentLeft, self);
    _titleLabel.frame = CGRectMake(kLeftCommonMargin, 15.0f, 200.0f, 16.0f);
    _titleLabel.text = @"出借金额(元):";
    
    self.inputView = [[ProductionBuyTextfeildView alloc] initViewWithFrame:CGRectMake(kLeftCommonMargin, _titleLabel.bottom + 10.0f, self.width - kLeftCommonMargin * 2.0f, 45.0f) backgroundColor:[UIColor clearColor]];
    [self addSubview:_inputView];
    [_inputView setFont:[UIFont get_G60_CN_NOR_Font] AndPlaceholderText:@""];
//    _inputView.myTextField.text = @"10000";
    _inputView.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    _inputView.myTextField.textColor = [UIColor get_9_Color];
    
    GreateLabelf(self.messageLabel, [UIColor get_2_Color], [UIFont get_A24_CN_NOR_Font], NSTextAlignmentCenter, self);
    _messageLabel.frame = CGRectMake(0, _inputView.bottom + 10.0f, self.width, 15.0f);
    _messageLabel.text = [NSString stringWithFormat:@"%@元起，%@的倍数递增",[Utility numberToMathString:GET_CLIENT_MANAGER.productionManager.productionBuyModel.startAmount AndUseLast:NO AndUseSign:NO],[Utility numberToMathString:GET_CLIENT_MANAGER.productionManager.productionBuyModel.minAmount AndUseLast:NO AndUseSign:NO]];
}



//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

@end
