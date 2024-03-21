//
//  ProductionBuyMoneyView.h
//  wealth
//
//  Created by wangyingjie on 16/3/29.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconAndLabelView.h"



@interface ProductionBuyMoneyView : UIView

@property (nonatomic, strong) IconAndLabelView *leftUpView;
@property (nonatomic, strong) IconAndLabelView *rightUpView;

@property (nonatomic, strong) UILabel *leftdownView;
@property (nonatomic, strong) UILabel *rightdownView;

@property (nonatomic, strong) UILabel *midLine;

- (void)setGivenMoney:(double )money;


@end
