//
//  MessageListModel.m
//  wealth
//
//  Created by wangyingjie on 16/5/17.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "MessageListModel.h"

@implementation MessageListModel


-(void)dealloc{
    self.msgTime = nil;
    self.msgPaper = nil;
    self.msgTitle = nil;
}


- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        if (dictionary && dictionary.count > 0) {
            self.msgId = [dictionary[@"id"] longLongValue];
            self.msgTitle = [dictionary stringForKey:@"title"];
            self.msgPaper = [dictionary stringForKey:@"paper"];
            self.msgTime = [dictionary stringForKey:@"push_time"];
        }
    }
    return self;
}


@end
