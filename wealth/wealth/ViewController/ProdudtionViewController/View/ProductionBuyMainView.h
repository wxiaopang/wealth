//
//  ProductionBuyMainView.h
//  wealth
//
//  Created by wangyingjie on 16/3/29.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductionBuyManagerView.h"
#import "ProductionBuyMessageView.h"
#import "ProductionBuyMoneyView.h"
#import "ProductionBuyTextfeildView.h"
#import "ProductionBuyTitleView.h"
#import "ProductionBuyInPutView.h"



@interface ProductionBuyMainView : UIView

@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIScrollView *mainBGView;
@property (nonatomic, strong) ProductionBuyTitleView *titleView;
@property (nonatomic, strong) ProductionBuyInPutView *inputView;
@property (nonatomic, strong) ProductionBuyMoneyView *moneyView;
@property (nonatomic, strong) ProductionBuyManagerView *managerView;
@property (nonatomic, strong) ProductionBuyMessageView *messageView;

@property (nonatomic, strong) ProductionBuyDetailModel *dataModel;

@property (nonatomic, copy) DoubleStringBlock nextButBlock;
@property (nonatomic, copy) VoidBlock treatyBlock;

@property (nonatomic, assign) double inputMoney;
@property (nonatomic, copy) NSString *saleId;



@property (nonatomic, assign) BOOL isOK;



@end
