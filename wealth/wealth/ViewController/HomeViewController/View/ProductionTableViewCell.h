//
//  ProductionTableViewCell.h
//  wealth
//
//  Created by wangyingjie on 16/3/22.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UIBaseTableViewCell.h"



@interface ProductionTableViewCell : UIBaseTableViewCell

@property (nonatomic, strong) ProductionListMode *dataModel;

@property (nonatomic, copy) VoidBlock buyClick;

@end
