//
//  LoginManager.m
//  wealth
//
//  Created by wangyingjie on 15/3/3.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "LoginManager.h"

@interface LoginManager ()


@property (nonatomic, assign) BOOL submitContacts;

@property (nonatomic, assign) BOOL hasCheckVersion;

@end

@implementation LoginManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.accountInformation = [[AccountInformationModel alloc] init];
        @weakify(self);
        [[RACObserve(self, status) distinctUntilChanged] subscribeNext:^(id x) {
            @strongify(self);
            LoginStatus s = [x integerValue];
            switch (s) {
                case LoginStatus_failed: {
                    NSLog(@"LoginStatus failed");
                }break;

                case LoginStatus_timeout: {
                    NSLog(@"LoginStatus timeout");
                    [self autoRelogin:nil];
                }break;

                case LoginStatus_conflit: {
                    NSLog(@"LoginStatus conflit");
                    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                }break;

                case LoginStatus_logout: {
                    NSLog(@"LoginStatus logout");
                    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                }break;

                case LoginStatus_Success: {
                    NSLog(@"LoginStatus Success");
                    [self checkVersion];

                    [GET_CLIENT_MANAGER initInformation];

                    // 上传push token
                    [GET_CLIENT_MANAGER submitCustomerPushAliasMethod];

                    // 获取客户信息
                    [GET_CLIENT_MANAGER.customerManager getCustomerInfoMethod:^(NSString *errMsg) {
                        
                    }];
                }break;
                default:

                    break;
            }
        }];
    }
    return self;
}

- (void)initInformation {
    long long userid = kClientManagerUid;
    if (userid > 0) {
        self.accountInformation = [AccountInformationModel findItemsByColumn:@"userid" value:@(userid)].firstObject;
    }
}

- (void)clearInformation {
    _status = LoginStatus_unknown;
    [_accountInformation save];
    _accountInformation = nil;
}

- (void)checkVersion {
    if (!_hasCheckVersion) {
        _hasCheckVersion = YES;

        [GET_CLIENT_MANAGER getVersionMethod:^(VersionInformation *versionInformation) {

            VersionInformation *model = [[VersionInformation alloc] init];
            model = versionInformation;
            NSComparisonResult result = [APP_SERVER_VERSION compare:versionInformation.appVersion];
            if (result > NSOrderedAscending) {
// 当前版本比server版本
            }
            else {
                NSLog(@"%ld",model.updateStatus);
                switch (model.updateStatus) {

                    case VersionStatus_normal: { // 有新版本，不要求强制更新
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本"
                                                                            message:model.updateDoc
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"忽略"
                                                                  otherButtonTitles:@"前往更新", nil];
                        [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            if (buttonIndex == 1) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.updateURI]];
                                exit(0);
                            }
                            else {
                                [UserDefaultsWrapper setUserDefaultsObject:model.appVersion forKey:kCheckVersion];
                            }
                        }];
                    }
                        break;

                    case VersionStatus_force: { // 有新版本，需强制更新
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本"
                                                                            message:model.updateDoc
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"前往更新"
                                                                  otherButtonTitles:nil];
                        [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.updateURI]];
                            exit(0);
                        }];
                    }
                        break;

                    case VersionStatus_faild:  // 版本检测失败
                    case VersionStatus_unknown: // 有新版本，但不可更新
                    case VersionStatus_none:   // 已经是最新版本
                    default:
                        break;
                }
            }
        }];
    }
}

- (void)customerLoginOutMethod:(LoginManagerCallBack)completion {
    @weakify(self);
    [GET_HTTP_API postWithModule:@"customerController"
                       interface:@"customerLoginOutMethod"
                            body:@{ @"longitude":[@(GET_CLIENT_MANAGER.locationInformation.longitude)stringValue],
                                    @"latitude":[@(GET_CLIENT_MANAGER.locationInformation.latitude)stringValue],
                                    @"address":GET_CLIENT_MANAGER.locationInformation.address.firstObject ? GET_CLIENT_MANAGER.locationInformation.address.firstObject : kNullStr }
                        complete:^(id JSONResponse, NSError *error)
     {
         @strongify(self);
         if (error) {
             if (completion) {
                 completion(kNetWorkError);
             }
         }
         else {
             NSInteger code = [JSONResponse[@"code"] integerValue];
             if (code == ResponseErrorCode_OK) {
                 // 成功退出登录，清空之前的http请求
                 [GET_HTTP_API.manager.operationQueue cancelAllOperations];
                 self.status = LoginStatus_logout;
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

- (void)userLogout{
    if (kClientManagerUid <= 0) {
        return;
    }
    [GET_HTTP_API postWithModule:@"appUser"
                       interface:@"exit"
                            body:@{}
                        complete:^(id JSONResponse, NSError *error){}];
    self.status = LoginStatus_logout;
    kClientManagerUid = 0;
    [GET_CLIENT_MANAGER.dataBaseManager clearInformation];
    [self clearInformation];
}

- (void)customerLoginMethod:(NSString *)usrename password:(NSString *)password complete:(HttpClientCallBack)completion {
    [GET_HTTP_API postWithModule:@"appUser"
                       interface:@"userLoginOfApp"
                            body:@{ @"mobile":[EncryptEngine encryptRSA:[usrename stringByReplacingOccurrencesOfString:@" " withString:kNullStr] publicKey:@""],
                                    @"pwd":[EncryptEngine encryptRSA:password publicKey:@""]}
                        complete:^(id JSONResponse, NSError *error)
     {
         if (error) {
             self.status = LoginStatus_failed;
         }
         else {
             NSInteger code = [JSONResponse[@"code"] integerValue];
             if (code == ResponseErrorCode_OK) {
                 if ([JSONResponse[@"body"] isKindOfClass:[NSDictionary class]] && ((NSDictionary *)JSONResponse[@"body"]).count > 0) {
                     long long userid = [JSONResponse[@"body"][@"uid"] longLongValue];
                     kClientManagerUid = userid;

                     // 缓存登录用户信息
                     AccountInformationModel *accountInformation = [AccountInformationModel findItemsByColumn:@"userid" value:@(userid)].firstObject;
                     if (accountInformation == nil) {
                         accountInformation = [[AccountInformationModel alloc] init];
                     }
                     accountInformation.userid = userid;
                     accountInformation.password = password;
                     accountInformation.mobileNo = [usrename stringByReplacingOccurrencesOfString:@" " withString:kNullStr];
                     if (self.accountInformation && accountInformation.userid == self.accountInformation.userid) {
                         accountInformation.savedInDatabase = YES;
                         accountInformation.gesturePassword = self.accountInformation.gesturePassword;
                     }
                     accountInformation.haveSales = [JSONResponse[@"body"][@"haveSales"] boolValue];
                     accountInformation.sellerName = JSONResponse[@"body"][@"sellerName"];
                     accountInformation.customerName = JSONResponse[@"body"][@"customerName"];
                     accountInformation.picUrl = JSONResponse[@"body"][@"picUrl"];
                     accountInformation.sellerPosition = JSONResponse[@"body"][@"sellerPosition"];
                     accountInformation.seller = [JSONResponse[@"body"][@"seller"] longLongValue];

                     [accountInformation save];
                     self.accountInformation = accountInformation;

                     [GET_CLIENT_MANAGER.customerManager resetInformation];

                     self.status = LoginStatus_Success;
                 }
             }
             else {

             }
         }

         if (completion) {
             completion(JSONResponse, error);
         }
     }];
}

- (void)autoRelogin:(void (^)(BOOL successed, NSString *error))complete {
    [GET_CLIENT_MANAGER initInformation];

//    NSString *mobile   = self.accountInformation.mobileNo;
//    NSString *password = self.accountInformation.password;
//    if (mobile && password) {
//        @weakify(self);
//        [self customerLoginMethod:mobile password:password complete:^(id JSONResponse, NSError *error) {
//            @strongify(self);
//            BOOL successed = NO;
//            NSString *errorMsg = nil;
//            if (error) {
//                self.status = LoginStatus_failed;
//                errorMsg = kNetWorkError;
//            }
//            else {
//                NSInteger code = [JSONResponse[@"code"] integerValue];
//                if (code == ResponseErrorCode_OK) {
//                    if ([JSONResponse[@"body"] isKindOfClass:[NSDictionary class]] && ((NSDictionary *)JSONResponse[@"body"]).count > 0) {
//                        long long userid = [JSONResponse[@"body"][@"customerId"] longLongValue];
//                        kClientManagerUid = userid;
//
//                        // 缓存登录用户信息
//                        AccountInformation *accountInformation = [AccountInformation findItemsByColumn:@"userid" value:@(userid)].firstObject;
//                        if (accountInformation == nil) {
//                            accountInformation = [[AccountInformation alloc] init];
//                        }
//                        accountInformation.userid = userid;
//                        accountInformation.password = password;
//                        accountInformation.mobileNo = mobile;
//                        if (self.accountInformation && accountInformation.userid == self.accountInformation.userid) {
//                            accountInformation.savedInDatabase = YES;
//                            accountInformation.gesturePassword = self.accountInformation.gesturePassword;
//                        }
//                        accountInformation.appLendRequestId = [JSONResponse[@"body"][@"appLendRequestId"] longLongValue];
//                        accountInformation.lendRequestState = [JSONResponse[@"body"][@"state"] integerValue];
//                        accountInformation.auditState = [JSONResponse[@"body"][@"auditState"] integerValue];
//                        [accountInformation save];
//                        self.accountInformation = accountInformation;
//
//                        [GET_CLIENT_MANAGER.customerManager resetInformation];
////                        GET_CLIENT_MANAGER.customerManager.customerInformation.customerName = JSONResponse[@"body"][@"customerName"];
////                        GET_CLIENT_MANAGER.customerManager.customerInformation.idNo = JSONResponse[@"body"][@"idNo"];
////                        GET_CLIENT_MANAGER.customerManager.customerInformation.salesId = [JSONResponse[@"body"][@"salesId"] longLongValue];
//
//                        successed = YES;
//                        self.status = LoginStatus_Success;
//                    }
//                }
//                else {
//                    errorMsg = JSONResponse[@"msg"];
//                }
//            }
//
//            if (complete) {
//                complete(successed, errorMsg);
//            }
//        }];
//    }
//    else {
//        kClientManagerUid = 0;
//        if (complete) {
//            complete(NO, @"登录已失效,请重新登录");
//        }
//    }
}


- (void)checkRegisterVerifyMethod:(NSString *)mobile
                       verifyCode:(NSString *)verifyCode
                         passWord:(NSString *)passWord
                         complete:(LoginManagerCallBack)completion {
    [GET_HTTP_API postWithModule:@"appUser"
                       interface:@"registerUserOfApp"
                            body:@{ @"mobile":[EncryptEngine encryptRSA:[mobile stringByReplacingOccurrencesOfString:@" " withString:kNullStr] publicKey:@""],
                                    @"validateCode":verifyCode,
                                    @"pwd":[EncryptEngine encryptRSA:passWord publicKey:@""] }
                        complete:^(id JSONResponse, NSError *error)
     {
         if (error) {
             if (completion) {
                 completion(kNetWorkError);
             }
         }
         else {
             NSInteger code = [JSONResponse[@"code"] integerValue];
             if (code == ResponseErrorCode_OK) {
                 long long userid = [JSONResponse[@"body"][@"uid"] longLongValue];
                 kClientManagerUid = userid;
                 // 缓存登录用户信息
                 AccountInformationModel *accountInformation = [[AccountInformationModel alloc] init];
                 accountInformation.userid = userid;
                 accountInformation.password = passWord;
                 accountInformation.mobileNo = [mobile stringByReplacingOccurrencesOfString:@" " withString:kNullStr];
                 if (self.accountInformation && accountInformation.userid == self.accountInformation.userid) {
                     accountInformation.savedInDatabase = YES;
                     accountInformation.gesturePassword = self.accountInformation.gesturePassword;
                 }
                 accountInformation.haveSales = [JSONResponse[@"body"][@"haveSales"] boolValue];
                 accountInformation.sellerName = JSONResponse[@"body"][@"sellerName"];
                 accountInformation.customerName = JSONResponse[@"body"][@"customerName"];
                 accountInformation.picUrl = JSONResponse[@"body"][@"picUrl"];
                 accountInformation.sellerPosition = JSONResponse[@"body"][@"sellerPosition"];
                 accountInformation.seller = [JSONResponse[@"body"][@"seller"] longLongValue];
                 
                 [accountInformation save];
                 self.accountInformation = accountInformation;
                 
                 [GET_CLIENT_MANAGER.customerManager resetInformation];
                 
                 self.status = LoginStatus_Success;

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

- (void)loginModifyPasswordByPhoneMethod:(NSString *)mobile
                              verifyCode:(NSString *)verifyCode
                                password:(NSString *)password
                                complete:(LoginManagerCallBack)completion {
    @weakify(self);
    [GET_HTTP_API postWithModule:@"appUser"
                       interface:@"changePasswordForApp"
                            body:@{
                                   @"mobile":[EncryptEngine encryptRSA:[mobile stringByReplacingOccurrencesOfString:@" " withString:kNullStr] publicKey:@""],
                                   @"code":verifyCode,
                                   @"passwd":[EncryptEngine encryptRSA:password publicKey:@""]
                                   }
                        complete:^(id JSONResponse, NSError *error)
     {
         @strongify(self);
         if (error) {
             if (completion) {
                 completion(kNetWorkError);
             }
         }
         else {
             NSInteger code = [JSONResponse[@"code"] integerValue];
             if (code == ResponseErrorCode_OK) {
                 // 修改成功以后缓存密码
                 self.accountInformation.password = password;

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

- (void)loginModifyPasswordByPhoneMethod:(NSString *)mobile
                              verifyCode:(NSString *)verifyCode
                                complete:(LoginManagerCallBack)completion {
    [GET_HTTP_API postWithModule:@"appUser"
                       interface:@"validCodeForApp"
                            body:@{
                                   @"mobile":[EncryptEngine encryptRSA:[mobile stringByReplacingOccurrencesOfString:@" " withString:kNullStr] publicKey:@""],
                                   @"code":verifyCode,
                                   }
                        complete:^(id JSONResponse, NSError *error)
     {
         if (error) {
             if (completion) {
                 completion(kNetWorkError);
             }
         }
         else {
             NSInteger code = [JSONResponse[@"code"] integerValue];
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

- (void)getVerifyCodeMethod:(NSString *)mobile
                       type:(VerifyCodeType)type
                   complete:(LoginManagerCallBack)completion {
    NSString *mothodName = nil;
    switch (type) {
        case VerifyCodeType_Regist: {
            mothodName = @"sendCodeForRegister";
        }
            break;

        case VerifyCodeType_Modify_PassWord: {
            mothodName = @"sendChangePwdCodeForApp";
        }
            break;

        case VerifyCodeType_Modify_Phone: {
            mothodName = @"getPhoneVerifyCodeMethod";
        }
            break;

        default:
            break;
    }

    [GET_HTTP_API postWithModule:@"appUser"
                       interface:mothodName
                            body:@{ @"mobile":[EncryptEngine encryptRSA:[mobile stringByReplacingOccurrencesOfString:@" " withString:kNullStr] publicKey:@""] }
                        complete:^(id JSONResponse, NSError *error)
     {
         if (error) {
             if (completion) {
                 completion(kNetWorkError);
             }
         }
         else {
             NSInteger code = [JSONResponse[@"code"] integerValue];
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


- (void)checkThePassWord:(NSString *)pwd complete:(LoginManagerCallBack)completion{
    [GET_HTTP_API postWithModule:@"appUser"
                       interface:@"verifyPassWord"
                            body:@{ @"passWord":[EncryptEngine encryptRSA:[pwd stringByReplacingOccurrencesOfString:@" " withString:kNullStr] publicKey:@""] }
                        complete:^(id JSONResponse, NSError *error)
     {
         if (error) {
             if (completion) {
                 completion(kNetWorkError);
             }
         }
         else {
             NSInteger code = [JSONResponse[@"code"] integerValue];
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
