//
//  ProductionBuyManagerView.m
//  wealth
//
//  Created by wangyingjie on 16/3/29.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "ProductionBuyManagerView.h"




@interface ProductionBuyManagerView ()

@end

@implementation ProductionBuyManagerView

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
    GreateImageView(self.headerView, @"", @"", self);
    _headerView.backgroundColor = [UIColor grayColor];
    _headerView.contentMode = UIViewContentModeScaleAspectFill;
    _headerView.frame = CGRectMake(kLeftCommonMargin - (ScreenWidth320 ? 5 : 0), 27.0f, 55.0f, 55.0f);
    _headerView.layer.masksToBounds = YES;
    _headerView.layer.cornerRadius = _headerView.width/2.0f;
    
    GreateLabelf(self.nameLabel, [UIColor get_2_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentLeft, self);
    GreateLabelf(self.managerLabel, [UIColor get_2_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentLeft, self);
    GreateLabelf(self.userKeyMoney, [UIColor get_2_Color], [UIFont get_B26_CN_NOR_Font], NSTextAlignmentLeft, self);
    GreateLabelf(self.salesKeyMoney, [UIColor get_2_Color], [UIFont get_B26_CN_NOR_Font], NSTextAlignmentLeft, self);
    GreateLabelf(self.userValueMoney, [UIColor get_9_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentLeft, self);
    GreateLabelf(self.salesValueMoney, [UIColor get_9_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentLeft, self);
    
    GreateEmptyLabel(self.midUpLine, [UIColor get_3_Color], self);
    GreateEmptyLabel(self.midbotLine, [UIColor get_3_Color], self);
    
    [_headerView sd_setImageWithURL:[NSURL URLWithString:GET_CLIENT_MANAGER.productionManager.productionBuyModel.sellerPicUrl] placeholderImage:[UIImage imageNamed:@"head_Default"]];
    [_nameLabel setAdaptionWidthWithText:GET_CLIENT_MANAGER.productionManager.productionBuyModel.sellerName];
    _nameLabel.frame = CGRectMake(_headerView.right + 15.0f, _headerView.top-8, _nameLabel.width, 16.0f);
    
    _midUpLine.frame = CGRectMake(_nameLabel.right +5.0f, _nameLabel.top, 0.5f, 16.0f);
    
    [_managerLabel setAdaptionWidthWithText:GET_CLIENT_MANAGER.productionManager.productionBuyModel.sellerPosition];
    _managerLabel.frame = CGRectMake(_midUpLine.right +5.0f, _nameLabel.top, _managerLabel.width, 16.0f);
    
    
    
    
    _headerView.frame = CGRectMake(kLeftCommonMargin, 14.0f, 55.0f, 55.0f);
    
    [_userKeyMoney setAdaptionHeightWithText:@"出借总额(元)"];
//    [_userKeyMoney setAdaptionHeightWithText:@"为客户赚取收益(元)"];
    _userKeyMoney.frame = CGRectMake(_nameLabel.left, _nameLabel.bottom + 15.0f, 150.0f, _userKeyMoney.height);
    
    [_userValueMoney setAdaptionHeightWithText:[Utility numberToMathString:GET_CLIENT_MANAGER.productionManager.productionBuyModel.sellerTotalSales AndUseLast:YES AndUseSign:NO]];
    //    [_userValueMoney setAdaptionHeightWithText:[Utility numberToMathString:88888888.00 AndUseLast:YES AndUseSign:NO]];
    _userValueMoney.frame = CGRectMake(self.width/2.0f, _nameLabel.bottom + 15.0f, 150.0f, _userValueMoney.height);
    
    
    
    
    
    _midbotLine.frame = CGRectMake(_headerView.right + (self.width-_headerView.right)/2.0f, _userValueMoney.top, 0.5f, 40.0f);
    _midbotLine.hidden = ScreenWidth320;
    
    [_salesValueMoney setAdaptionHeightWithText:[Utility numberToMathString:GET_CLIENT_MANAGER.productionManager.productionBuyModel.sellerTotalSales AndUseLast:YES AndUseSign:NO]];
    _salesValueMoney.frame = CGRectMake(_midbotLine.left+5.0f, _nameLabel.bottom + 15.0f, 150.0f, _userValueMoney.height);
    
    [_salesKeyMoney setAdaptionHeightWithText:@"出借总额(元)"];
    _salesKeyMoney.frame = CGRectMake(_midbotLine.left+5.0f, _salesValueMoney.bottom + 5.0f, 150.0f, _userKeyMoney.height);
    
    
    GreateLabelf(self.unMessageLabel, [UIColor get_2_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentLeft, self);
    [_unMessageLabel setAdaptionWidthWithText:@"已有尊享专属理财师？"];
    _unMessageLabel.frame = CGRectMake(kLeftCommonMargin, 15.0f, _unMessageLabel.width, 16.0f);
    
    self.unNoView = [[IconAndLabelView alloc] initViewWithFrame:CGRectMake(0, _unMessageLabel.bottom + 26.0f, 60.0f, 20.0f) backgroundColor:[UIColor clearColor]];
    [_unNoView addTapGestureRecognizerWithTarget:self action:@selector(noHaveManager)];
    [self addSubview:_unNoView];
    
    self.unYesView = [[IconAndLabelView alloc] initViewWithFrame:CGRectMake(_unNoView.right , _unMessageLabel.bottom + 26.0f, 60.0f, 20.0f) backgroundColor:[UIColor clearColor]];
    [_unYesView addTapGestureRecognizerWithTarget:self action:@selector(haveManager)];
    [self addSubview:_unYesView];
    
    
    self.unNumberView = [[ProductionBuyTextfeildView alloc] initViewWithFrame:CGRectMake(_unYesView.right+20.0f, _unMessageLabel.bottom + 26.0f, self.width - kLeftCommonMargin * 2.0f - (_unYesView.right+20.0f), 20.0f) backgroundColor:[UIColor clearColor]];
    [self addSubview:_unNumberView];
    [_unNumberView setFont:[UIFont get_C30_CN_NOR_Font] AndPlaceholderText:@"请输入理财经理编号"];
    _unNumberView.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    _unNumberView.myTextField.frame = CGRectMake(0, _unNumberView.height - 25.0f, _unNumberView.width, 20.0f);
    _unNumberView.placeholderLabel.frame = CGRectMake(0, _unNumberView.height - 25.0f, _unNumberView.width, 20.0f);
    
    
    _headerView.hidden = self.height == 94;
    _nameLabel.hidden = self.height == 94;
    _midUpLine.hidden = self.height == 94;
    _managerLabel.hidden = self.height == 94;
    _userKeyMoney.hidden = self.height == 94;
    _userValueMoney.hidden = self.height == 94;
    _midbotLine.hidden = self.height == 94;
    _salesKeyMoney.hidden = self.height == 94;
    _salesValueMoney.hidden = self.height == 94;
    
    _unMessageLabel.hidden = self.height != 94;
    _unNoView.hidden = self.height != 94;
    _unNumberView.hidden = self.height != 94;
    _unYesView.hidden = self.height != 94;
    
    _salesKeyMoney.hidden = YES;
    _salesValueMoney.hidden = YES;
    _midbotLine.hidden = YES;
    
    if (self.height == 94) {
        self.isHaveManager = YES;
    }
    self.isHaveManager = NO;
}

- (void)noHaveManager{
    self.isHaveManager = NO;
}

- (void)haveManager{
    self.isHaveManager = YES;
}

- (void)setIsHaveManager:(BOOL)isHaveManager{
    if (_isHaveManager == isHaveManager) {
        return;
    }
    _isHaveManager = isHaveManager;
    
    [_unNoView setIconView:_isHaveManager ? [UIImage imageNamed:@"product_pay_icon_empty"]:[UIImage imageNamed:@"product_pay_icon_right"] AndTitle:@"否"];
    [_unYesView setIconView:_isHaveManager ? [UIImage imageNamed:@"product_pay_icon_right"]:[UIImage imageNamed:@"product_pay_icon_empty"] AndTitle:@"是"];
    
    _unNumberView.hidden = !_isHaveManager;
}


//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

@end
