//
//  ProductionBuyMessageView.h
//  wealth
//
//  Created by wangyingjie on 16/3/29.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductionBuyMessageView : UIView

@property (nonatomic, strong) UILabel *treatyLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, copy) VoidBlock treatyClick;

@end
