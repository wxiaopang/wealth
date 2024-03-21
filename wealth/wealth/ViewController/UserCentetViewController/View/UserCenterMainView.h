//
//  UserCenterMainView.h
//  wealth
//
//  Created by wangyingjie on 16/3/22.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserMoneyView.h"
#import "IconAndLabelAndIconView.h"


@interface UserCenterMainView : UIScrollView

@property (nonatomic, strong) UserMoneyView *moneyView;
@property (nonatomic, strong) UIImageView *pointView;

@property (nonatomic, copy) VoidBlock myListBlock;
@property (nonatomic, copy) VoidBlock bankListBlock;
@property (nonatomic, copy) VoidBlock MessageBlock;

- (void)refurbishTheData;


@end
