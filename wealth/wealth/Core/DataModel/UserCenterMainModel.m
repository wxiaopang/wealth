//
//  UserCenterMainModel.m
//  wealth
//
//  Created by wangyingjie on 16/4/8.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UserCenterMainModel.h"

@implementation UserCenterMainModel

-(void)dealloc{
    self.uri = nil;
}


- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        if (dictionary && dictionary.count > 0) {
            NSString *url = [dictionary objectForKey:@"uri"];
            self.uri = [Utility getHtmlUrlWithController:url];
            self.massageTotalCount = [dictionary[@"massageTotalCount"] longLongValue];
        }
    }
    return self;
}

@end
