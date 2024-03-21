//
//  ProductionManager.m
//  wealth
//
//  Created by wangyingjie on 16/3/30.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "ProductionManager.h"

@implementation ProductionManager

- (void)initInformation {
//    long long userid = kClientManagerUid;
//    if (userid > 0) {
//        _accountInformation = [AccountInformationModel findItemsByColumn:@"userid" value:@(userid)].firstObject;
//    }
    if (self.productionList) {
        [self.productionList removeAllObjects];
    }else{
        self.productionList = [[NSMutableArray alloc] initWithCapacity:0];
    }

    self.code = 0;
}

- (void)clearInformation {
//    _status = LoginStatus_unknown;
//    [_accountInformation save];
//    _accountInformation = nil;
    
    
    [self.productionList removeAllObjects];

    self.productionList = nil;
}



- (void)getProductionListComplete:(ProductionManagerCallBack)completion{
    _code = 0;
    [GET_HTTP_API postWithModule:@"wealthProduct"
                       interface:@"queryProduct"
                            body:@{ }
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
                 if (_productionList) {
                     [_productionList removeAllObjects];
                 }else{
                     self.productionList = [[NSMutableArray alloc] initWithCapacity:0];
                 }
                 NSArray *productList = JSONResponse[@"body"][@"list"];
                 if (productList.count > 0) {
                     for (NSDictionary *dic in productList) {
                         ProductionListMode *model = [[ProductionListMode alloc] init];
                         model = [model initWithDictionary:dic];
                         if (GET_CLIENT_MANAGER.uid > 0) {
//                             [model save];
                         }
                         [_productionList addObject:model];
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
- (void)callTheManagerComplete:(ProductionManagerCallBack)completion{
    _code = 0;
    [GET_HTTP_API postWithModule:@"wealthProduct"
                       interface:@"sendMessageToSeller"
                            body:@{@"sellerId":@(GET_CLIENT_MANAGER.loginManager.accountInformation.seller)}
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

- (void)getProductionBuyDetailWithProductionId:(long long)pId Complete:(ProductionManagerCallBack)completion{
    _code = 0;
    [GET_HTTP_API postWithModule:@"wealthProduct"
                       interface:@"queryProductById"
                            body:@{@"productId":@(pId)}
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
                 if (_productionBuyModel) {
                     _productionBuyModel = nil;
                 }
                 _productionBuyModel = [[ProductionBuyDetailModel alloc] init];
                 NSDictionary *bodyDic = JSONResponse[@"body"];
                 if (bodyDic.count>0 && ![bodyDic isEqual:[NSNull null]]) {
                     _productionBuyModel = [_productionBuyModel initWithDictionary:bodyDic];
                     _productionBuyModel.productionId = pId;
//                     [_productionBuyModel save];
                     
                     GET_CLIENT_MANAGER.loginManager.accountInformation.haveSales = [[bodyDic objectForKey:@"haveSales"] boolValue];
                     GET_CLIENT_MANAGER.loginManager.accountInformation.picUrl = [bodyDic objectForKey:@"sellerPicUrl"];
                     GET_CLIENT_MANAGER.loginManager.accountInformation.sellerName = [bodyDic objectForKey:@"sellerName"];
                     GET_CLIENT_MANAGER.loginManager.accountInformation.sellerPosition = JSONResponse[@"body"][@"sellerPosition"];
                     if (GET_CLIENT_MANAGER.uid > 0) {
                         [GET_CLIENT_MANAGER.loginManager.accountInformation save];
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

- (void)submitProductionBuyMessageWithProductionId:(long long)pId AndAmount:(double)amount AndEmployeeNo:(NSString *)employeeNo Complete:(ProductionManagerCallBack)completion{
    _code = 0;
    [GET_HTTP_API postWithModule:@"wealthAppRequest"
                       interface:@"addWealthAppRequest"
                            body:@{@"product":@(pId),@"amount":@(amount),@"employeeNo":employeeNo?employeeNo:@""}
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

- (void)getSalesMessage{
    _code = 0;
    [GET_HTTP_API postWithModule:@"appUser"
                       interface:@"getCustomerInfo"
                            body:@{}
                        complete:^(id JSONResponse, NSError *error){
         NSInteger code = [JSONResponse[@"code"] integerValue];
         _code = code;
         if (code == ResponseErrorCode_OK) {
             NSDictionary *body = JSONResponse[@"body"];
             if (![body isEqual:[NSNull null]] && body.count > 0) {
                 GET_CLIENT_MANAGER.loginManager.accountInformation.sellerName = body[@"sellerName"];
                 GET_CLIENT_MANAGER.loginManager.accountInformation.picUrl = body[@"sellerImg"];
                 GET_CLIENT_MANAGER.loginManager.accountInformation.sellerPosition = body[@"sellerPosition"];
                 GET_CLIENT_MANAGER.loginManager.accountInformation.seller = [body[@"sellerId"] longLongValue];
                 GET_CLIENT_MANAGER.loginManager.accountInformation.haveSales = [body[@"haveSales"] boolValue];
                 [GET_CLIENT_MANAGER.loginManager.accountInformation save];
             }
         }
     }];
}



@end
