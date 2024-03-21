//
//  HomeHeaderView.m
//  wealth
//
//  Created by wangyingjie on 16/3/22.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "HomeHeaderView.h"

@interface HomeHeaderView ()


@end

@implementation HomeHeaderView

- (void)dealloc {
    
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}


#pragma mark- SetupViews
- (void)setUpViews {
    GreateImageView(self.bgImageView, @"product_background", @"", self);
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.frame = CGRectMake(0, 0, self.width, self.height);
    
    self.headerWriteView = [[UIView alloc] initViewWithFrame:CGRectZero backgroundColor:[UIColor whiteColor]];
    _headerWriteView.frame = CGRectMake(kProportion*50.0f, (self.height - 71.0f)/2.0f+kProportion*10.0f, 75.0f, 75.0f);
    _headerWriteView.layer.masksToBounds = YES;
    _headerWriteView.layer.cornerRadius = _headerWriteView.width/2.0f;
    [self addSubview:_headerWriteView];
    
    GreateLabelf(self.messageLabe, [UIColor get_8_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentCenter, self);
    [_messageLabe setAdaptionHeightWithText:@"普惠财富  赚动梦想"];
    _messageLabe.frame = CGRectMake(0, kProportion*45.0f, self.width, 16.0f);
    GreateButtonType(self.loginBut, CGRectMake((self.width - 150.0f*kProportion)/2.0f, _messageLabe.bottom + 15.3f, 150.0f*kProportion, 40.0f*kProportion+0.3f), @"马上登录", NO, self);
    
    
    GreateImageView(self.headerView, @"head_Default", @"", self);
    _headerView.clipsToBounds = YES;
    _headerView.contentMode = UIViewContentModeScaleAspectFill;
    _headerView.layer.masksToBounds = YES;
    _headerView.layer.cornerRadius = 71.0/2.0f;
    GreateLabelf(self.nameLabel, [UIColor get_8_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentCenter, self);
    GreateLabelf(self.titleLabel, [UIColor get_8_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentCenter, self);
    GreateButtonType(self.callBut, CGRectZero, @"马上联系他", NO, self);
    self.lineView = [[UIView alloc] initViewWithFrame:CGRectZero backgroundColor:[UIColor get_8_Color]];
    [self addSubview:_lineView];
    
    [_loginBut addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [_callBut addTarget:self action:@selector(callClick) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)setIsLogin:(BOOL)isLogin{
    if (_isLogin != isLogin) {
        _isLogin = isLogin;
    }
    
    _messageLabe.hidden = _isLogin;
    _loginBut.hidden = _isLogin;
    _headerView.hidden = !_isLogin;
    _nameLabel.hidden = !_isLogin;
    _titleLabel.hidden = !_isLogin;
    _callBut.hidden = !_isLogin;
    _lineView.hidden = !_isLogin;
    _headerWriteView.hidden = !_isLogin;
    
    if (_isLogin) {

        
        AccountInformationModel *model = GET_CLIENT_MANAGER.loginManager.accountInformation;
        
        _headerView.frame = CGRectMake(kProportion*50.0f, (self.height - 71.0f)/2.0f+kProportion*10.0f, 71.0f, 71.0f);
        _headerWriteView.center = _headerView.center;
        [_headerView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"head_Default"]];
        [_nameLabel setAdaptionWidthWithText:model.sellerName];
        _nameLabel.frame = CGRectMake(_headerView.right + 20.3f, _headerView.top + 5.0f, _nameLabel.width, 16.0f);
        _lineView.frame = CGRectMake(_nameLabel.right + 10.0f, _nameLabel.top + 1.0f, 0.5f, 14.0f);
        [_titleLabel setAdaptionWidthWithText:model.sellerPosition];
        _titleLabel.frame = CGRectMake(_lineView.right+10.0f, _nameLabel.top, _titleLabel.width, 16.0f);
        _callBut.frame = CGRectMake(_nameLabel.left, _nameLabel.bottom + 10.3f, 140.0f, 34.0f);
        
    }else{
        
    }
    _bgImageView.frame = CGRectMake(0, 0, self.width, self.height);
}

- (void)loginClick{
    if (self.loginBlock) {
        self.loginBlock();
    }
}

- (void)callClick{
    if (self.callBlock) {
        self.callBlock();
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
