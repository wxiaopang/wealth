//
//  BaseLableValueModel.h
//  wealth
//
//  Created by wangyingjie on 15/1/14.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import "BaseModel.h"

@interface BaseLableValueModel : NSObject //BaseModel

@property (nonatomic, assign) ABRecordID recordId;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *value;

- (instancetype)initWithRecordId:(ABRecordID)recordId lable:(NSString *)lable value:(NSString *)value;

- (BOOL)isEqualLableValueModel:(BaseLableValueModel *)model;

@end
