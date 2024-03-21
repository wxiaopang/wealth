//
//  MessageDetailModel.m
//  wealth
//
//  Created by wangyingjie on 16/5/17.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "MessageDetailModel.h"

@implementation MessageDetailModel

-(void)dealloc{
    self.msgTime = nil;
    self.msgPaper = nil;
    self.msgTitle = nil;
    self.msgDetail = nil;
}


- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        if (dictionary && dictionary.count > 0) {
            self.msgType = [dictionary[@"messageType"] integerValue];
            self.msgTitle = [dictionary stringForKey:@"title"];
            self.msgPaper = [dictionary stringForKey:@"paper"];
            self.msgTime = [dictionary stringForKey:@"push_time"];
            self.msgDetail = [dictionary stringForKey:@"message"];
        }
    }
    return self;
}

@end
