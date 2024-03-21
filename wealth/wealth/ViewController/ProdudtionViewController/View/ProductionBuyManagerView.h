//
//  ProductionBuyManagerView.h
//  wealth
//
//  Created by wangyingjie on 16/3/29.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconAndLabelView.h"
#import "ProductionBuyTextfeildView.h"




@interface ProductionBuyManagerView : UIView


@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *managerLabel;
@property (nonatomic, strong) UILabel *midUpLine;
@property (nonatomic, strong) UILabel *userValueMoney;
@property (nonatomic, strong) UILabel *userKeyMoney;
@property (nonatomic, strong) UILabel *salesValueMoney;
@property (nonatomic, strong) UILabel *salesKeyMoney;
@property (nonatomic, strong) UILabel *midbotLine;


@property (nonatomic, strong) UILabel *unMessageLabel;
@property (nonatomic, strong) IconAndLabelView *unNoView;
@property (nonatomic, strong) IconAndLabelView *unYesView;
@property (nonatomic, strong) ProductionBuyTextfeildView *unNumberView;

@property (nonatomic, assign) BOOL isHaveManager;


@end
