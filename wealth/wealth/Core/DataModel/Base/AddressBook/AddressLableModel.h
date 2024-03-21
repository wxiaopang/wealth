//
//  AddressLableModel.h
//  wealth
//
//  Created by wangyingjie on 15/1/14.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import "BaseLableValueModel.h"

@interface AddressLableModel : BaseLableValueModel

@property (nonatomic, assign) ABRecordID recordId;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *value;

@end
