//
//  PhoneLableModel.h
//  wealth
//
//  Created by wangyingjie on 15/1/13.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import "BaseLableValueModel.h"

@interface PhoneLableModel : BaseLableValueModel

@property (nonatomic, assign) ABRecordID recordId;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *value;

@end
