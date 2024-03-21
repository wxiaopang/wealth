//
//  LabelCell.h
//  wealth
//
//  Created by wangyingjie on 15/9/7.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "CustomDrawTableViewCell.h"

@interface LabelCell : CustomDrawTableViewCell

@property (nonatomic, strong) UITimerLable *leftLabel;
@property (nonatomic, strong) UITimerLable *rightLabel;
@property (nonatomic, assign) CGFloat bottomMargin;
@property (nonatomic, assign) CGFloat leftLabelMargin;

@end
