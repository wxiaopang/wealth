//
//  UserCenterMainView.m
//  wealth
//
//  Created by wangyingjie on 16/3/22.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UserCenterMainView.h"



@interface UserCenterMainView ()

@property (nonatomic, strong) UIImageView *headerBGView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIImageView *messageView;

@property (nonatomic, strong) UILabel *nameLabel;


@property (nonatomic, strong) IconAndLabelAndIconView *myList;
@property (nonatomic, strong) IconAndLabelAndIconView *bankList;


@end

@implementation UserCenterMainView

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
    
    self.headerBGView = [[UIImageView alloc] initImageViewWithFrame:CGRectMake(0, 0, ScreenWidth, kProportion*175.0f) image:[UIImage imageNamed:@"mine_background"] backgroundColor:[UIColor clearColor]];
    [self addSubview:_headerBGView];
    
    self.headerView = [[UIImageView alloc] initImageViewWithFrame:CGRectMake((ScreenWidth - kProportion*125.0f)/2.0f, kProportion*50.0f, kProportion*125.0f, kProportion*63.0f) image:[UIImage imageNamed:@"mine_head_logo"] backgroundColor:[UIColor clearColor]];
    [_headerBGView addSubview:_headerView];
    
    self.messageView = [[UIImageView alloc] initImageViewWithFrame:CGRectMake((ScreenWidth - (40.0+48.0)/2.0), kProportion*30.0f, 24.0f, 23.0f) image:[UIImage imageNamed:@"mine_icon_message_empty"] backgroundColor:[UIColor clearColor]];
    [_headerBGView addSubview:_messageView];
    
    
    self.pointView = [[UIImageView alloc] initImageViewWithFrame:CGRectMake((ScreenWidth - (40.0+48.0)/2.0), kProportion*30.0f, 24.0f, 23.0f) image:[UIImage imageNamed:@"mine_icon_message"] backgroundColor:[UIColor clearColor]];
    [_headerBGView addSubview:_pointView];
    _pointView.userInteractionEnabled = NO;
    _pointView.hidden = YES;
    
    
    GreateLabel(self.nameLabel, [UIColor get_8_Color], 20, NSTextAlignmentCenter, _headerBGView);
    _nameLabel.frame = CGRectMake(0, _headerView.bottom + 10.0f, ScreenWidth, 25.0f);
    
    self.moneyView = [[UserMoneyView alloc] initViewWithFrame:CGRectMake(0, _headerBGView.bottom, ScreenWidth, 130.0f) backgroundColor:[UIColor whiteColor]];
    self.moneyView = [[UserMoneyView alloc] initViewWithFrame:CGRectMake(0, _headerBGView.bottom, ScreenWidth, 70.0f) backgroundColor:[UIColor whiteColor]];
    self.moneyView.hidden = YES;
    [self addSubview:_moneyView];
    
    self.myList = [[IconAndLabelAndIconView alloc] initViewWithFrame:CGRectMake(0, _headerBGView.bottom+5.0f, ScreenWidth, 49.0f) backgroundColor:[UIColor whiteColor]];
    [self addSubview:_myList];
    [_myList addTapGestureRecognizerWithTarget:self action:@selector(gotoMyList)];
    
    self.bankList = [[IconAndLabelAndIconView alloc] initViewWithFrame:CGRectMake(0, _myList.bottom + 0.5f, ScreenWidth, 49.0f) backgroundColor:[UIColor whiteColor]];
    [self addSubview:_bankList];
    [_bankList addTapGestureRecognizerWithTarget:self action:@selector(gotoBankList)];
    
    AccountInformationModel *model = GET_CLIENT_MANAGER.loginManager.accountInformation;
    [_nameLabel setAdaptionHeightWithText:[NSString stringWithFormat:@"您好：%@",model.customerName]];
    _moneyView.money = 88888888;
    [_myList setLeftIcon:[UIImage imageNamed:@"mine_icon_lend"] AndTitle:@"我的出借" AndRight:[UIImage imageNamed:@"icon_select"]];
    [_bankList setLeftIcon:[UIImage imageNamed:@"mine_icon_bankcard"] AndTitle:@"我的鉴权" AndRight:[UIImage imageNamed:@"icon_select"]];
    
    UIView *touch = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    touch.center = _pointView.center;
    touch.backgroundColor = [UIColor clearColor];
    [_headerBGView addSubview:touch];
    [touch addTapGestureRecognizerWithTarget:self action:@selector(messageClicked)];
    
}

- (void)gotoMyList{
    if (self.myListBlock) {
        self.myListBlock();
    }
}

- (void)gotoBankList{
    if (self.bankListBlock) {
        self.bankListBlock();
    }
}

- (void)messageClicked{
    if (self.MessageBlock) {
        self.MessageBlock();
    }
}

- (void)refurbishTheData{
    AccountInformationModel *model = GET_CLIENT_MANAGER.loginManager.accountInformation;
    [_nameLabel setAdaptionHeightWithText:[NSString stringWithFormat:@"您好：%@",model.customerName]];
    _moneyView.money = 88888888;
    [_myList setLeftIcon:[UIImage imageNamed:@"mine_icon_lend"] AndTitle:@"我的出借" AndRight:[UIImage imageNamed:@"icon_select"]];
    [_bankList setLeftIcon:[UIImage imageNamed:@"mine_icon_bankcard"] AndTitle:@"我的鉴权" AndRight:[UIImage imageNamed:@"icon_select"]];
}



//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

@end
