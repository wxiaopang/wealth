//
//  UserCenterManager.m
//  wealth
//
//  Created by wangyingjie on 16/4/8.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UserCenterManager.h"

@implementation UserCenterManager


- (void)initInformation {
    if (self.bankList) {
        [self.bankList removeAllObjects];
    }else{
        self.bankList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (self.bankMessageList) {
        [self.bankMessageList removeAllObjects];
    }else{
        self.bankMessageList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    self.code = 0;
}

- (void)clearInformation {
    [self.bankMessageList removeAllObjects];
    [self.bankList removeAllObjects];
    self.code = 0;
}


- (void)getUserCenterMainMessageComplete:(UserCenterManagerCallBack)completion{
    _code = 0;
    [GET_HTTP_API postWithModule:@"myWealthRequest"
                       interface:@"getMyRequestURI"
                            body:@{}
                        complete:^(id JSONResponse, NSError *error)
     {
         if (error) {
             if (completion) {
                 completion(kNetWorkError);
             }
         }
         else {
             NSInteger code = [JSONResponse[@"code"] integerValue];
             _code = code;
             if (code == ResponseErrorCode_OK) {
                 _ucMainModel = [[UserCenterMainModel alloc] init];
                 NSDictionary *bodyDic = JSONResponse[@"body"];
                 if (bodyDic.count>0 && ![bodyDic isEqual:[NSNull null]]) {
                     _ucMainModel = [_ucMainModel initWithDictionary:bodyDic];
//                     [_ucMainModel save];
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


- (void)getMyBankMessageListComplete:(UserCenterManagerCallBack)completion{
    _code = 0;
    if (self.bankMessageList) {
        [self.bankMessageList removeAllObjects];
    }else{
        self.bankMessageList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [GET_HTTP_API postWithModule:@"bankCard"
                       interface:@"getAuthenticationList"
                            body:@{}
                        complete:^(id JSONResponse, NSError *error)
     {
         if (error) {
             if (completion) {
                 completion(kNetWorkError);
             }
         }
         else {
             NSInteger code = [JSONResponse[@"code"] integerValue];
             _code = code;
             if (code == ResponseErrorCode_OK) {
                 NSDictionary *body = JSONResponse[@"body"];
                 if (![body isEqual:[NSNull null]]) {
                     NSArray *list = body[@"list"];
                     if (list.count > 0) {
                         for (NSDictionary *dic in list) {
                             BankMessageModel *model = [[BankMessageModel alloc] init];
                             model.cardNumber = dic[@"cardNumber"];
                             model.value = dic[@"value"];
                             model.url = dic[@"url"];
                             model.isBankList = NO;
                             [_bankMessageList addObject:model];
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

- (void)getBankListComplete:(UserCenterManagerCallBack)completion{
    _code = 0;
    if (self.bankList) {
        [self.bankList removeAllObjects];
    }else{
        self.bankList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [GET_HTTP_API postWithModule:@"bankCard"
                       interface:@"getBankList"
                            body:@{}
                        complete:^(id JSONResponse, NSError *error)
     {
         if (error) {
             if (completion) {
                 completion(kNetWorkError);
             }
         }
         else {
             NSInteger code = [JSONResponse[@"code"] integerValue];
             _code = code;
             if (code == ResponseErrorCode_OK) {
                 NSDictionary *body = JSONResponse[@"body"];
                 if (![body isEqual:[NSNull null]]) {
                     NSArray *list = body[@"list"];
                     if (list.count > 0) {
                         for (NSDictionary *dic in list) {
                             BankMessageModel *model = [[BankMessageModel alloc] init];
                             model.code = dic[@"code"];
                             model.value = dic[@"value"];
                             model.url = dic[@"url"];
                             model.isBankList = YES;
                             [_bankList addObject:model];
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

- (void)submitTheBankMessageWithDic:(NSDictionary *)msgDic Complete:(UserCenterManagerCallBack)completion{
    _code = 0;
    [GET_HTTP_API postWithModule:@"bankCard"
                       interface:@"authentication"
                            body:msgDic
                        complete:^(id JSONResponse, NSError *error)
     {
         if (error) {
             if (completion) {
                 completion(kNetWorkError);
             }
         }
         else {
             NSInteger code = [JSONResponse[@"code"] integerValue];
             _code = code;
             if (code == ResponseErrorCode_OK) {
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





@end
