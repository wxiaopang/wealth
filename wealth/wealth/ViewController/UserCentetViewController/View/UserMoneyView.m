//
//  UserMoneyView.m
//  wealth
//
//  Created by wangyingjie on 16/3/22.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UserMoneyView.h"



@interface UserMoneyView ()

@end

@implementation UserMoneyView

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
    self.nameView = [[IconAndLabelView alloc] initViewWithFrame:CGRectMake(0, 15.0f, ScreenWidth, 40.0f) backgroundColor:[UIColor clearColor]];
//    [self addSubview:_nameView];
    
//    GreateLabelf(self.moneyLabel, [UIColor get_9_Color], [UIFont get_D32_EN_NOR_Font], NSTextAlignmentRight, self);
//    _moneyLabel.frame = CGRectMake(0, _nameView.top, self.width-kLeftCommonMargin, 32.0f);
    
//    GreateButtonType(self.rechargeButton, CGRectMake(kLeftCommonMargin, _nameView.bottom + 15.0f, (ScreenWidth-4.0f*kLeftCommonMargin)/2.0f, 40.0f), @"充值", YES, self);
    GreateButtonType(self.rechargeButton, CGRectMake(kLeftCommonMargin,  15.0f, (ScreenWidth-4.0f*kLeftCommonMargin)/2.0f, 40.0f), @"充值", YES, self);
    [_rechargeButton addTarget:self action:@selector(rechargeClick) forControlEvents:UIControlEventTouchUpInside];
    GreateButtonType(self.withdrawButton, CGRectMake((_rechargeButton.right + 2.0f*kLeftCommonMargin), _rechargeButton.top, (ScreenWidth-4.0f*kLeftCommonMargin)/2.0f, 40.0f), @"提现", NO, self);
    [_withdrawButton addTarget:self action:@selector(withdrawClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundColor = [UIColor whiteColor];
    
}


- (void)setMoney:(double)money{
    if (_money != money) {
        _money = money;
    }
    _moneyLabel.text = [NSString getStringFromNumber:money point:YES sign:YES];
    [_nameView setIconView:[UIImage imageNamed:@"mine_icon_wallet"] AndTitle:@"可用金额"];
}

- (void)rechargeClick{
    if (self.rechargeBlock) {
        self.rechargeBlock();
    }
}
- (void)withdrawClick{
    if (self.withdrawBlock) {
        self.withdrawBlock();
    }
}



//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

@end
