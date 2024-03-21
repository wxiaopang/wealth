//
//  UserMoneyView.h
//  wealth
//
//  Created by wangyingjie on 16/3/22.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconAndLabelView.h"



@interface UserMoneyView : UIView

@property (nonatomic, strong) IconAndLabelView *nameView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIButton *rechargeButton;
@property (nonatomic, strong) UIButton *withdrawButton;


@property (nonatomic, assign) double money;


@property (nonatomic, copy) VoidBlock rechargeBlock;
@property (nonatomic, copy) VoidBlock withdrawBlock;



@end
