//
//  SetBaseTableViewCell.h
//  wealth
//
//  Created by wangyingjie on 16/3/23.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UIBaseTableViewCell.h"

@interface SetBaseTableViewCell : UIBaseTableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *nextImageView;

@property (nonatomic, strong) UILabel *logoutLabel;

@property (nonatomic, strong) UILabel *bottomLine;

@property (nonatomic, assign) SetMainCellType cellType;

@end
