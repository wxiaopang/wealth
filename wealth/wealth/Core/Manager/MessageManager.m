//
//  MessageManager.m
//  wealth
//
//  Created by wangyingjie on 16/5/17.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "MessageManager.h"

@implementation MessageManager




- (void)getMessageListWithNumber:(NSInteger)number range:(NSInteger)page Complete:(MessageManagerCallBack)completion{
    self.code = 0;
    if (page <= 1) {
        self.messageList = nil;
        self.messageList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (number <= 1) {
        number = 10;
    }
    [GET_HTTP_API postWithModule:@"appPushController"
                       interface:@"getMessageList"
                            body:@{@"pageIndex" : @(page),@"pageSize":@(number)}
                        complete:^(id JSONResponse, NSError *error)
     {
         if (error) {
             if (completion) {
                 completion(kNetWorkError);
             }
         }
         else {
             NSInteger code = [JSONResponse[@"code"] integerValue];
             self.code = code;
             if (code == ResponseErrorCode_OK) {
                 NSDictionary *bodyDic = JSONResponse[@"body"];
                 if (bodyDic.count>0 && ![bodyDic isEqual:[NSNull null]]) {
                     NSArray *list = bodyDic[@"list"];
                     self.totalPage = [bodyDic[@"totalPage"] longLongValue];
                     if ([list isKindOfClass:[NSArray class]] && list.count > 0 ) {
                         for (NSDictionary *dic in list) {
                             MessageListModel *listModel = [[MessageListModel alloc] initWithDictionary:dic];
                             [self.messageList addObject:listModel];
                         }
                     }
                 }
                 if (completion) {
                     completion(nil);
                 }
             }
             else {
                 if (completion) {
                     completion(JSONResponse[@"msg"] ? JSONResponse[@"msg"] : kNetWorkError);
                 }
             }
         }
     }];
}



- (void)getMessageDetailWithMessageId:(long long)msgId Complete:(MessageManagerCallBack)completion{
    self.code = 0;
    [GET_HTTP_API postWithModule:@"appPushController"
                       interface:@"getMessageContext"
                            body:@{@"messageId":@(msgId)}
                        complete:^(id JSONResponse, NSError *error)
     {
         if (error) {
             if (completion) {
                 completion(kNetWorkError);
             }
         }
         else {
             NSInteger code = [JSONResponse[@"code"] integerValue];
             self.code = code;
             self.msgDetailModel = [[MessageDetailModel alloc] init];
             if (code == ResponseErrorCode_OK) {
                 NSDictionary *bodyDic = JSONResponse[@"body"];
                 if (bodyDic.count>0 && ![bodyDic isEqual:[NSNull null]]) {
                     self.msgDetailModel = [self.msgDetailModel initWithDictionary:bodyDic];
                 }
                 if (completion) {
                     completion(nil);
                 }
             }
             else {
                 if (completion) {
                     completion(JSONResponse[@"msg"] ? JSONResponse[@"msg"] : kNetWorkError);
                 }
             }
         }
     }];
}

- (void)registThePushDeviceToken{
    NSString *deviceTokenStr = @"";
    if (GET_CLIENT_MANAGER.uid > 0) {
        deviceTokenStr = [NSString stringWithFormat:@"app_deviceToken_%lld",GET_CLIENT_MANAGER.uid];
    }else{
        return;
    }
    [GET_HTTP_API postWithModule:@"appPushController"
                       interface:@"updateDeviceTokenByPid"
                            body:@{@"deviceToken":deviceTokenStr}
                        complete:^(id JSONResponse, NSError *error)
     {
         NSInteger code = [JSONResponse[@"code"] integerValue];
         self.code = code;
         if (code == ResponseErrorCode_OK) {
             [JPUSHService setAlias:deviceTokenStr callbackSelector:nil object:nil];
         }
     }];
}


- (void)initInformation{
    if (self.messageList) {
        self.messageList = nil;
    }
    self.messageList = [[NSMutableArray alloc] initWithCapacity:0];
    self.totalPage = 0;
    self.code = 0;
}

- (void)clearInformation{
    self.messageList = nil;
    self.totalPage = 0;
    self.code = 0;
}

@end
