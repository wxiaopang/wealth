//
//  PushModel.m
//  wealth
//
//  Created by wangyingjie on 16/5/11.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "PushModel.h"

@implementation PushModel

-(void)dealloc{
    self.pushUrl = nil;
    self.pushTitle = nil;
    self.pushContent = nil;
}


- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        if (dictionary && dictionary.count > 0) {
            self.pushUrl = dictionary[@"url"];
            self.pushTitle = dictionary[@"title"] ? dictionary[@"title"] : @"";
            self.pushContent = dictionary[@"aps"][@"alert"] ? dictionary[@"aps"][@"alert"] : @"";
            self.pushtype = [dictionary[@"type"] integerValue];
            self.pushId = [dictionary[@"messageId"] longLongValue];
        }
    }
    return self;
}

@end
