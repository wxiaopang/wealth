//
//  ProductionBuyMessageView.m
//  wealth
//
//  Created by wangyingjie on 16/3/29.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "ProductionBuyMessageView.h"




@interface ProductionBuyMessageView ()

@end

@implementation ProductionBuyMessageView

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
    GreateLabelf(self.treatyLabel, [UIColor get_10_Color], [UIFont get_B26_CN_NOR_Font], NSTextAlignmentCenter, self);
    GreateLabelf(self.messageLabel, [UIColor get_2_Color], [UIFont get_B26_CN_NOR_Font], NSTextAlignmentCenter, self);
    GreateLabelf(self.phoneLabel, [UIColor get_2_Color], [UIFont get_B26_CN_NOR_Font], NSTextAlignmentCenter, self);
    GreateLabelf(self.timeLabel, [UIColor get_2_Color], [UIFont get_B26_CN_NOR_Font], NSTextAlignmentCenter, self);
    
    _treatyLabel.text = @"《出借咨询与服务协议》(范本)";
    _treatyLabel.frame = CGRectMake(0, 20.0f, self.width, 14.0f);
    _treatyLabel.userInteractionEnabled = YES;
    [_treatyLabel addTapGestureRecognizerWithTarget:self action:@selector(seeTheTreaty)];
//    [_treatyLabel addTapGestureRecognizerWithTarget:self delegate:self action:@selector(seeTheTreaty)];
    
    _messageLabel.text = @"市场有风险，出借需谨慎";
    _messageLabel.frame = CGRectMake(0, _treatyLabel.bottom + 5.0f, self.width, 14.0f);
    
    _phoneLabel.text = [NSString stringWithFormat:@"普惠财富客户服务热线:%@",kPhoneNumberDis];
    _phoneLabel.frame = CGRectMake(0, _messageLabel.bottom + 5.0f, self.width, 14.0f);
    
    _timeLabel.text = kMessageWorkTime;
    _timeLabel.frame = CGRectMake(0, _phoneLabel.bottom + 5.0f, self.width, 14.0f);
    
    
    
}

- (void)seeTheTreaty{
    if (self.treatyClick) {
        self.treatyClick();
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
