//
//  UCAddBankView.m
//  wealth
//
//  Created by wangyingjie on 16/4/19.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UCAddBankView.h"

@interface UCAddBankView ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *botMsgLabel;



@end

@implementation UCAddBankView

- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


#pragma mark- SetupViews
- (void)setUpViews {
    GreateImageView(self.bgImageView, @"mine_authorize_bg_empty_add", @"mine_authorize_bg_empty_add", self);
    GreateImageView(self.addImageView, @"mine_authorize_empty_add", @"mine_authorize_empty_add", self);
    GreateLabelf(self.messageLabel, [UIColor get_3_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentCenter, self);
    GreateLabelf(self.botMsgLabel, [UIColor get_2_Color], [UIFont get_B26_CN_NOR_Font], NSTextAlignmentLeft, self);
    
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.frame = CGRectMake(kLeftCommonMargin, 20.0f, self.width - 2*kLeftCommonMargin, 150.0f);
    _addImageView.frame = CGRectMake((self.width-30.0f)/2.0f, (40+88)/2.0f, 30.0f, 30.0f);
    _messageLabel.frame = CGRectMake(0, _addImageView.bottom + 20.0f, self.width, 16.0f);
    _botMsgLabel.numberOfLines = 0;
    _botMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _botMsgLabel.text = @"为保证出借成功，您需要先通过银联鉴权。出借申请审核通过后，我们将从您授权划扣的银行卡中自动扣款，无需手动确认。";
    _botMsgLabel.frame = CGRectMake(kLeftCommonMargin, self.height - 14*4-20.0f, ScreenWidth-2*kLeftCommonMargin, 14*4);
    _messageLabel.text = @"立即鉴权";
    
    _addImageView.userInteractionEnabled = NO;
    _messageLabel.userInteractionEnabled = NO;
    [_bgImageView addTapGestureRecognizerWithTarget:self action:@selector(addBankClick)];
}

- (void)addBankClick{
    if (self.addBankClickBlock) {
        self.addBankClickBlock();
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
