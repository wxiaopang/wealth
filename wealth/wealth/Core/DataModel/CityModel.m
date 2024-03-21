//
//  CityModel.m
//  wealth
//
//  Created by yangzhaofeng on 15/3/31.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

- (void)dealloc {
    self.regionsCode = nil;
    self.regionsName = nil;
    self.parentCode = nil;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        if (dictionary && dictionary.count > 0) {
            self.regionsCode = [dictionary objectForKey:@"regionsCode"];
            self.regionsName = [dictionary objectForKey:@"regionsName"];
            self.parentCode = [dictionary objectForKey:@"parentCode"];
        }
    }
    return self;
}

@end
