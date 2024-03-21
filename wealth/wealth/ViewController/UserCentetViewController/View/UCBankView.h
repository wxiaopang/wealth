//
//  UCBankView.h
//  wealth
//
//  Created by wangyingjie on 16/4/19.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCBankView : UIView

@property (nonatomic, copy) IntegerBlock selectBankBlock;
@property (nonatomic, strong) UITableView *mainTableView;


@end
