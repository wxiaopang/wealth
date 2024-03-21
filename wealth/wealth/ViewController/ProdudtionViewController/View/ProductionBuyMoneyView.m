//
//  ProductionBuyMoneyView.m
//  wealth
//
//  Created by wangyingjie on 16/3/29.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "ProductionBuyMoneyView.h"



@interface ProductionBuyMoneyView ()

@end

@implementation ProductionBuyMoneyView

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
    
    self.leftUpView = [[IconAndLabelView alloc] initViewWithFrame:CGRectMake((ScreenWidth/2.0 - 131.0f)/2.0f, 20.0f, 131.0f, 20.0f) backgroundColor:[UIColor clearColor]];
    [self addSubview:_leftUpView];
    [_leftUpView setIconView:[UIImage imageNamed:@"product_pay_icon_money"] AndTitle:@"预期收益(元)"];
    
    self.rightUpView = [[IconAndLabelView alloc] initViewWithFrame:CGRectMake((ScreenWidth/2.0 - 131.0f)/2.0f+ScreenWidth/2.0, 20.0f, 131.0f, 20.0f) backgroundColor:[UIColor clearColor]];
    [self addSubview:_rightUpView];
    [_rightUpView setIconView:[UIImage imageNamed:@"product_pay_icon_wallet"]  AndTitle:@"账户余额(元)"];
    
    GreateLabelf(self.leftdownView, [UIColor get_9_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentCenter, self);
    GreateLabelf(self.rightdownView, [UIColor get_9_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentCenter, self);
    
    _leftdownView.frame = CGRectMake(0+kLeftCommonMargin/2.0f, _leftUpView.bottom + 5.0f, ScreenWidth/2.0f, 16.0f);
    _rightdownView.frame = CGRectMake(ScreenWidth/2.0f+kLeftCommonMargin/2.0f, _leftUpView.bottom + 5.0f, ScreenWidth/2.0f, 16.0f);
    
    
    _rightdownView.text = [Utility numberToMathString:GET_CLIENT_MANAGER.productionManager.productionBuyModel.theAccountBalance AndUseLast:YES AndUseSign:NO];
    
    GreateEmptyLabel(self.midLine, [UIColor get_3_Color], self);
    _midLine.frame = CGRectMake(ScreenWidth/2.0f, 20.0f, 0.5f, self.height-40.0f);
    
    _rightUpView.hidden = YES;
    _rightdownView.hidden = YES;
    _midLine.hidden = YES;
}


- (void)setGivenMoney:(double )money{
    double givenmoney = GET_CLIENT_MANAGER.productionManager.productionBuyModel.expectedEarnings*money/10000.0f;
    if (givenmoney <= 0.01) {
        givenmoney =0.01f;
    }
    if (money <= 0) {
        givenmoney = 0.0f;
    }
    _leftdownView.text = [Utility numberToMathString:givenmoney AndUseLast:YES AndUseSign:NO];
}

//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

@end
