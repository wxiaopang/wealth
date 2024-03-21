//
//  UCBankListCell.h
//  wealth
//
//  Created by wangyingjie on 16/4/19.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UIBaseTableViewCell.h"

@interface UCBankListCell : UIBaseTableViewCell

@property (nonatomic, strong) BankMessageModel *messageModel;

@property (nonatomic, strong) UILabel *upLine;
@property (nonatomic, strong) UILabel *bottomLine;

@end
