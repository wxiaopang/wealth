//
//  CustomerManager.m
//  wealth
//
//  Created by wangyingjie on 15/9/8.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "CustomerManager.h"

@interface CustomerManager ()

//@property (nonatomic, strong) CustomerInformation *customerInformation;

@end

@implementation CustomerManager

- (void)initInformation {
//    long long userid = kClientManagerUid;
//    if ( userid > 0 ) {
//        _customerInformation = [CustomerInformation findItemsByColumn:@"userid" value:@(userid)].firstObject;
//    }
//    if ( _customerInformation == nil ) {
//        _customerInformation = [[CustomerInformation alloc] init];
//    }
}

- (void)clearInformation {
//    [_customerInformation save];
//    _customerInformation = nil;
}

- (void)resetInformation {
    [self clearInformation];
//    _customerInformation = [[CustomerInformation alloc] init];
}

//- (void)setInformation:(CustomerInformation *)customerInformation {
//    [self clearInformation];
//    _customerInformation = customerInformation;
//}

- (void)getCustomerInfoMethod:(CustomerManagerCallBack)completion {
//    @weakify(self);
//    [GET_HTTP_API postWithModule:@"customerController"
//                       interface:@"getCustomerInfoMethod"
//                            body:nil
//                        complete:^(id JSONResponse, NSError *error)
//     {
//         @strongify(self);
//         if ( error ) {
//             if ( completion ) {
//                 completion(kNetWorkError);
//             }
//         } else {
//             NSInteger code = [JSONResponse[@"code"] integerValue];
//             if ( code == ResponseErrorCode_OK ) {
//                 // 缓存客户信息
//                 CustomerInformation *customerInformation = [[CustomerInformation alloc] initWithDictionary:JSONResponse[@"body"]];
//                 customerInformation.userid = GET_CLIENT_MANAGER.loginManager.accountInformation.userid;
//                 [self setInformation:customerInformation];
//
//                 // 获取头像信息
//                 [self getCustomerMyMessageMethod:^(id JSONResponse1, NSError *error) {
//                     if ( error ) {
//                         NSLog(@"error = %@", error);
//                     } else {
//                         id body = JSONResponse1[@"body"];
//                         if ( body && [body isKindOfClass:[NSDictionary class]] ) {
//                             NSInteger code = [JSONResponse1[@"code"] integerValue];
//                             if ( code == ResponseErrorCode_OK ) {
//                                 customerInformation.pictureId = [body[@"id"] longLongValue];
//                                 customerInformation.filePath = [NSString stringWithFormat:@"%@%@", GET_HTTP_BASEURL, body[@"filePath"]];
//                                 customerInformation.iconPath = [NSString stringWithFormat:@"%@%@", GET_HTTP_BASEURL, body[@"iconPath"]];
//                                 customerInformation.fileName = body[@"fileName"];
//                             } else {
//                                 NSLog(@"msg = %@", JSONResponse[@"msg"]);
//                             }
//                         }
//                     }
//                     [customerInformation save];
//                     if ( completion ) {
//                         completion(nil);
//                     }
//
//                     // 通知头像下载完毕
//                     [[NSNotificationCenter defaultCenter] postNotificationName:kCustomHeaderReady object:nil];
//                 }];
//             } else {
//                 if ( completion ) {
//                     completion(JSONResponse[@"msg"] ? JSONResponse[@"msg"] : kNetWorkError);
//                 }
//             }
//         }
//     }];
}

- (void)getCustomerMyMessageMethod:(HttpClientCallBack)completion {
    [GET_HTTP_API postWithModule:@"appCustomerMyMessageController"
                       interface:@"getCustomerMyMessageMethod"
                            body:nil
                        complete:completion];
}

@end
