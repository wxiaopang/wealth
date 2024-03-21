//
//  BaseLableValueModel.m
//  wealth
//
//  Created by wangyingjie on 15/1/14.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import "BaseLableValueModel.h"

@interface BaseLableValueModel () <NSCoding>

@end

@implementation BaseLableValueModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.recordId) forKey:@"recordId"];
    [aCoder encodeObject:self.label forKey:@"label"];
    [aCoder encodeObject:self.value forKey:@"value"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if ( self ) {
        self.recordId = [[aDecoder decodeObjectForKey:@"recordId"] intValue];
        self.label = [aDecoder decodeObjectForKey:@"label"];
        self.value = [aDecoder decodeObjectForKey:@"value"];
    }
    return self;
}

- (instancetype)initWithRecordId:(ABRecordID)recordId lable:(NSString *)lable value:(NSString *)value {
    self = [super init];
    if ( self ) {
        self.recordId = recordId;
        self.label = lable;
        self.value = value;
    }
    return self;
}

- (BOOL)isEqualLableValueModel:(BaseLableValueModel *)model {
    BOOL result = (_recordId == model.recordId
                   && [_label isEqualToString:model.label]
                   && [_value isEqualToString:model.value]);
    return result;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[ %@ ] recordId=%@, label=%@, value=%@",
            NSStringFromClass([self class]), @(_recordId), _label, _value];
}

@end
