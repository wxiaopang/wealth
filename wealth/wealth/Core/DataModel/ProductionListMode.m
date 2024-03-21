//
//  ProductionListMode.m
//  wealth
//
//  Created by wangyingjie on 16/3/30.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "ProductionListMode.h"

@implementation ProductionListMode

-(void)dealloc{
    self.productName = nil;
    self.periodType = nil;
}


- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        if (dictionary && dictionary.count > 0) {
            self.listId = [[dictionary objectForKey:@"id"] longLongValue];
            self.annuaRate = [[dictionary objectForKey:@"annuaRate"] doubleValue];
            self.minAmount = [[dictionary objectForKey:@"minAmount"] doubleValue];
            self.period = [[dictionary objectForKey:@"period"] longLongValue];
            self.productName = [dictionary objectForKey:@"productName"];
            self.periodType = [dictionary objectForKey:@"periodType"];
        }
    }
    return self;
}

@end
