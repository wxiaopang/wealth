

//
//  HttpClientAPI.m
//  wealth
//
//  Created by wangyingjie on 14/12/16.
//  Copyright (c) 2014年 puhui. All rights reserved.
//

#import "HttpClientAPI.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

#define kRequestNodeComm        @"comm"
#define kRequestNodeToken       @"token"
#define kRequestNodeBody        @"body"

@interface HttpClientAPI () {
    NSString *_baseHttpUrl;
}

@property (nonatomic, assign) BOOL           encryptError;      // 标记RSA加密是否发生错误

@end

@implementation HttpClientAPI

SYNTHESIZE_SINGLETON_FOR_CLASS(HttpClientAPI);

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configManager];
    }
    return self;
}

// 创建网络管理
- (void)configManager {
    _manager                    = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:HTTP_BASE_URL]];
    _manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/plain", nil];
    self.enableHttps            = [HTTP_BASE_URL hasPrefix:@"https:"];

    // 启动状态栏网络请求指示
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    // 监控网络状态变化
    @weakify(self);
    [_manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @strongify(self);
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                [GET_HTTP_API postWithModule:@"publicKeyController"
                                   interface:@"getPublicKeyMethod"
                                        body:nil
                                    complete:^(id JSONResponse, NSError *error)
                 {
                     if (error) {
                         NSLog(@"服务户端出错 %@", error.localizedDescription);
                         return ;
                     }
                     else {
                         NSInteger code = [JSONResponse[@"code"] integerValue];
                         if (code == ResponseErrorCode_OK) {
                             if ([JSONResponse[@"body"] isKindOfClass:[NSDictionary class]] && ((NSDictionary *)JSONResponse[@"body"]).count > 0) {
                                 // 缓存RSA加密公钥
                                 NSString *pukey = JSONResponse[@"body"][@"puKey"];
                                 if (pukey) {
                                     [UserDefaultsWrapper setUserDefaultsObject:pukey forKey:kRSAPublicKey];
                                 }
                             }
                         }
                     }
                 }];
//                [self submitLogmethod];
            }break;

            case AFNetworkReachabilityStatusNotReachable:
            default: {
                [self.manager.operationQueue cancelAllOperations];
            }break;
        }
    }];
    [_manager.reachabilityManager startMonitoring];
}

- (void)submitLogmethod{
    //网络一旦连通，即上传一次日志，保证日志信息不积累过多
    //上传启动日志
    [AnalyticsManager submitLogMethod:[LoginLogInformation class]];
    // 上传注册日志
    [AnalyticsManager submitLogMethod:[RegistLogInformation class]];
    // 上传页面访问日志
    [AnalyticsManager submitLogMethod:[ViewControllerLogInformation class]];
    // 上传退出日志
    [AnalyticsManager submitLogMethod:[LogoutLogInformation class]];
    // 上传推送消息日志
    [AnalyticsManager submitLogMethod:[PushMessageLogInformation class]];
    // 上传用户操作日志
    [AnalyticsManager submitLogMethod:[ActionLogInformation class]];
}



- (void)setEnableHttps:(BOOL)enableHttps {
    _enableHttps = enableHttps;
    if (_enableHttps) {
        _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];

        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        //如果是需要验证自建证书，需要设置为YES
        _manager.securityPolicy.allowInvalidCertificates = YES;

        //validatesDomainName 是否需要验证域名，默认为YES；
        //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
        //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        //如置为NO，建议自己添加对应域名的校验逻辑。
        _manager.securityPolicy.validatesDomainName = NO;

        //validatesCertificateChain 是否验证整个证书链，默认为YES
        //设置为YES，会将服务器返回的Trust Object上的证书链与本地导入的证书进行对比，这就意味着，假如你的证书链是这样的：
        //GeoTrust Global CA
        //    Google Internet Authority G2
        //        *.google.com
        //那么，除了导入*.google.com之外，还需要导入证书链上所有的CA证书（GeoTrust Global CA, Google Internet Authority G2）；
        //如是自建证书的时候，可以设置为YES，增强安全性；假如是信任的CA所签发的证书，则建议关闭该验证，因为整个证书链一一比对是完全没有必要（请查看源代码）；
        //_manager.securityPolicy.validatesCertificateChain = NO;
    }
    else {
        _manager.securityPolicy                          = [AFSecurityPolicy defaultPolicy];
        _manager.securityPolicy.allowInvalidCertificates = NO;
        _manager.securityPolicy.validatesDomainName      = YES;
        //_manager.securityPolicy.validatesCertificateChain = YES;
    }
}

- (SDWebImageOptions)options {
    return self.enableHttps ? SDWebImageAllowInvalidSSLCertificates : 0;
}

- (NSString *)baseHttpUrl {
    if ( _baseHttpUrl ) {
        return _baseHttpUrl;
    } else {
        return HTML5_BASE_URL;
    }
}

- (void)setBaseHttpUrl:(NSString *)baseHttpUrl {
    NSLog(@"%@", baseHttpUrl);
    _baseHttpUrl = [baseHttpUrl copy];
    self.enableHttps = [_baseHttpUrl hasPrefix:@"https:"];
}

- (void)get:(NSString *)url
    headers:(NSDictionary *)headers
     params:(NSDictionary *)params
   complete:(HttpClientCallBack)complete {
    NSAssert((url && url.length > 0), @"url is nil");
    NSAssert((params && params.count > 0), @"params is nil");

    // 网络不通挂起状态,请求直接失败
    if (_manager.reachabilityManager.reachable) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self.manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];

        @weakify(self);
        [_manager GET:url
           parameters:params
             progress:^(NSProgress * _Nonnull downloadProgress) {
                 NSLog(@"uploadProgress = %@", downloadProgress);
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 @strongify(self);
                 self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
                 if (complete) {
                     complete(responseObject, nil);
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
                 if (complete) {
                     complete(nil, error);
                 }
             }];
    } else {
        if (complete) {
            complete(nil, [NSError errorWithDomain:kNetWorkError code:5000 userInfo:nil]);
        }
    }
}

- (void)postWithModule:(NSString *)module
             interface:(NSString *)interface
                  body:(NSDictionary *)body
            encoderRSA:(BOOL)encoder
              complete:(HttpClientCallBack)complete {
    NSAssert((module && module.length > 0), @"module is nil");
    NSAssert((interface && interface.length > 0), @"interface is nil");

    // 网络不通挂起状态,请求直接失败
    if (_manager.reachabilityManager.reachable) {
        // http请求序列化为JSON串
        NSString     *url     = [self getHttpPath:module interface:interface];
        NSDictionary *newBody = [self createHttpBody:body encoderRSA:encoder];

        @weakify(self);
        [_manager POST:url
            parameters:newBody
              progress:^(NSProgress * _Nonnull uploadProgress) {
                  NSLog(@"uploadProgress = %@", uploadProgress);
              }
               success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
                   NSLog(@"/n ********** (%@)发送信令 ********* \n服务器接口: %@ \ncomm: %@ \ntoken: %@ \n参数: %@ \n服务器响应: %@ \n ************* 信令结束 ********** ",
                         newBody[kRequestNodeComm][@"pid"], task.currentRequest.URL,[newBody objectForKey:@"comm"],[newBody objectForKey:@"token"], body, responseObject);

                   if ( [task.response isKindOfClass:[NSHTTPURLResponse class]] ) {
                       NSHTTPURLResponse *response =(NSHTTPURLResponse *)task.response;
                       NSString *timeString = [response allHeaderFields][@"Date"];
                       NSDate *date = [DateEngine convertFromString:timeString];
                       NSLog(@"服务器时间 = %@", date);
                       SET_SYSTEM_DATE(date);

                       // 获取到系统时间开启日志上传
                       [AnalyticsManager resume];
                   }

                   @strongify(self);
                   if (responseObject == nil
                       || ![responseObject isKindOfClass:[NSDictionary class]]
                       || [responseObject count] == 0) {
                       if (complete) {
                           complete(nil, [NSError errorWithDomain:kNetWorkError code:5000 userInfo:nil]);
                       }
                   }
                   else {
                       // 每次信令返回都存储当前token
                       NSString *token = responseObject[@"token"];
                       if (![responseObject[@"token"] isEqual:[NSNull null]] && token && token.length > 0) {
                           [UserDefaultsWrapper setUserDefaultsObject:token forKey:kPublicToken];
                       }
                       
                       // token失效,自动重新登录
                       NSInteger status = 0;
                       if (![responseObject[@"status"] isEqual:[NSNull null]]) {
                           status = [responseObject[@"status"] integerValue];
                       }
                       NSString *msg = responseObject[@"msg"];
                       if (status == ResponseErrorCode_900 || status == ResponseErrorCode_901) {
                           // 登录超时
                           GET_CLIENT_MANAGER.loginManager.status = LoginStatus_timeout;
                           return;
                       }
                       else if ( status == ResponseErrorCode_902 ) {
                           // 异地登录
                           if (kClientManagerUid > 0) {
//                               GET_CLIENT_MANAGER.loginManager.status = LoginStatus_conflit;
                               [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusConflit
                                                                                   object:nil
                                                                                 userInfo:@{ @"message":kConflitMsg }];
                           }
                           return;
                       }
                       else if ( status == ResponseErrorCode_903 && GET_CLIENT_MANAGER.loginManager.status == LoginStatus_Success ) {
                           // 登录失效,退出登录成功UI不显示弹窗提示
                           if (kClientManagerUid > 0) {
//                               GET_CLIENT_MANAGER.loginManager.status = LoginStatus_failed;
                               [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusFailed object:nil userInfo:nil];
                           }
                           return;
                       }
                       else if (status == ResponseErrorCode_802 && [msg isEqualToString:@"没有该设备记录，禁止访问"]) {
                           self.encryptError = YES;
                           // 用静态公钥去加密,并重发当前信令
                           [self postWithModule:module interface:interface body:body complete:complete];

                           // 重新获取公钥
                           [GET_CLIENT_MANAGER getRSAPublicKey:nil];
                           return;
                       }



                       // server解密失败,需要重新获取公钥
                       if (status == ResponseErrorCode_802) {
                           self.encryptError = YES;
                           // 用静态公钥去加密,并重发当前信令
                           [self postWithModule:module interface:interface body:body complete:complete];

                           // 重新获取公钥
                           [GET_CLIENT_MANAGER getRSAPublicKey:nil];
                           return;
                       }
                       else {
                           self.encryptError = NO;
                       }

                       if (complete) {
                           complete(responseObject, nil);
                       }
                   }
               }
               failure:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
                   NSLog(@"/n ********** (%@)发送信令 ********* \n服务器接口: %@ \ncomm: %@ \ntoken: %@ \n参数: %@ \n网络错误: %@ \n ************* 信令结束 ********** ",
                         newBody[kRequestNodeComm][@"pid"], task.currentRequest.URL,[newBody objectForKey:@"comm"],[newBody objectForKey:@"token"], body, error.localizedDescription);
                   if (complete) {
                       complete(nil, error);
                   }
               }];
    }
    else {
        if (complete) {
            complete(nil, [NSError errorWithDomain:kNetWorkError code:5000 userInfo:nil]);
        }
    }
}

- (void)postWithModule:(NSString *)module
             interface:(NSString *)interface
                  body:(NSDictionary *)body
              complete:(HttpClientCallBack)complete
{
    [self postWithModule:module interface:interface body:body encoderRSA:(!self.enableHttps) complete:complete];
}

- (void)uploadImage:(NSDictionary *)body
              count:(NSInteger)count
             fileid:(NSInteger)fileid
          imageData:(NSData *)data
           complete:(HttpClientCallBack)complete
{
    if (_manager.reachabilityManager.reachable) {
        NSString *url = nil;
        // http请求序列化为JSON串
        NSMutableDictionary *tmpBody = [[NSMutableDictionary alloc] initWithDictionary:body];
        if (data) {
            url                    = [self getHttpPath:@"customerDetailsController" interface:@"submitPictureMethod"];
            tmpBody[@"fileStream"] = [EncryptEngine encodeBase64Data:data];
            tmpBody[@"fileId"]     = @(fileid);
            tmpBody[@"length"]     = @(data.length);
            tmpBody[@"subsection"] = @(count > 1);
        }
        else {
            url = [self getHttpPath:@"customerDetailsController" interface:@"unionPictureMethod"];
            [tmpBody removeObjectForKey:@"uploadType"];
        }
        NSDictionary *newBody = [self createHttpBody:tmpBody encoderRSA:YES];
        [_manager POST:url
            parameters:newBody
              progress:^(NSProgress * _Nonnull uploadProgress) {
                  NSLog(@"uploadProgress = %@", uploadProgress);
              }
               success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
                   NSLog(@"/n ********** (%@)发送信令 ********* \n服务器接口: %@ \ncomm: %@ \ntoken: %@ \n参数: %@ \n服务器响应: %@ \n ************* 信令结束 ********** ",
                         newBody[kRequestNodeComm][@"pid"], task.currentRequest.URL,[newBody objectForKey:@"comm"],[newBody objectForKey:@"token"], body, responseObject);

                   if (responseObject == nil
                       || ![responseObject isKindOfClass:[NSDictionary class]]
                       || [responseObject count] == 0) {
                       if (complete) {
                           complete(nil, [NSError errorWithDomain:kNetWorkError code:5000 userInfo:nil]);
                       }
                   }
                   else {
                       // token失效,自动重新登录
                       NSInteger status = [responseObject[@"status"] integerValue];
                       if (status == ResponseErrorCode_900 || status == ResponseErrorCode_901) {
                           // 登录超时
                           GET_CLIENT_MANAGER.loginManager.status = LoginStatus_timeout;
                           return;
                       }
                       else if ( status == ResponseErrorCode_902 ) {
                           // 异地登录
                           if (kClientManagerUid > 0) {
                               GET_CLIENT_MANAGER.loginManager.status = LoginStatus_conflit;
                               [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusConflit
                                                                                   object:nil
                                                                                 userInfo:@{ @"message":kConflitMsg }];
                           }
                           return;
                       }
                       else if ( status == ResponseErrorCode_903 && GET_CLIENT_MANAGER.loginManager.status == LoginStatus_Success ) {
                           // 登录失效,退出登录成功UI不显示弹窗提示
                           if (kClientManagerUid > 0) {
                               GET_CLIENT_MANAGER.loginManager.status = LoginStatus_failed;
                               [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusFailed object:nil userInfo:nil];
                           }
                           return;
                       }
                       // 每次信令返回都存储当前token
                       NSString *token = responseObject[@"token"];
                       if (token && token.length > 0) {
                           [UserDefaultsWrapper setUserDefaultsObject:token forKey:kPublicToken];
                       }

                       if (complete) {
                           complete(responseObject, nil);
                       }
                   }
               }
               failure:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
                   NSLog(@"/n ********** (%@)发送信令 ********* \n服务器接口: %@ \ncomm: %@ \ntoken: %@ \n参数: %@ \n网络错误: %@ \n ************* 信令结束 ********** ",
                         newBody[kRequestNodeComm][@"pid"], task.currentRequest.URL,[newBody objectForKey:@"comm"],[newBody objectForKey:@"token"], body, error.localizedDescription);
                   if (complete) {
                       complete(nil, error);
                   }
               }];
    }
    else {
        if (complete) {
            complete(nil, [NSError errorWithDomain:kNetWorkError code:5000 userInfo:nil]);
        }
    }
}

- (void)uploadSuggestImage:(NSDictionary *)body    // 上传图片的参数
                     count:(NSInteger)count        // 文件块数
                    fileid:(NSInteger)fileid       // 文件块编号
                 imageData:(NSData *)data          // 图片二进制流数据
                  complete:(HttpClientCallBack)complete {
    if (_manager.reachabilityManager.reachable) {
        NSString *url = nil;
        // http请求序列化为JSON串
        NSMutableDictionary *tmpBody = [[NSMutableDictionary alloc] initWithDictionary:body];
        if (data) {
            url                    = [self getHttpPath:@"customerSuggestionController" interface:@"uploadSuggestFilesMethod"];
            tmpBody[@"fileStream"] = [EncryptEngine encodeBase64Data:data];
            tmpBody[@"fileNo"]     = @(fileid);
            //        tmpBody[@"length"] = @(data.length);
        }
        else {
            url = [self getHttpPath:@"customerSuggestionController" interface:@"doUnionPictureMethod"];
        }

        NSDictionary *newBody = [self createHttpBody:tmpBody encoderRSA:NO];
        [_manager POST:url
            parameters:newBody
              progress:^(NSProgress * _Nonnull uploadProgress) {
                  NSLog(@"uploadProgress = %@", uploadProgress);
              }
               success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
                   NSLog(@"/n ********** (%@)发送信令 ********* \n服务器接口: %@ \ncomm: %@ \ntoken: %@ \n参数: %@ \n服务器响应: %@ \n ************* 信令结束 ********** ",
                         newBody[kRequestNodeComm][@"pid"], task.currentRequest.URL,[newBody objectForKey:@"comm"],[newBody objectForKey:@"token"], body, responseObject);

                   if (responseObject == nil
                       || ![responseObject isKindOfClass:[NSDictionary class]]
                       || [responseObject count] == 0) {
                       if (complete) {
                           complete(nil, [NSError errorWithDomain:kNetWorkError code:5000 userInfo:nil]);
                       }
                   }
                   else {
                       // token失效,自动重新登录
                       NSInteger status = [responseObject[@"status"] integerValue];
                       if (status == ResponseErrorCode_900 || status == ResponseErrorCode_901) {
                           // 登录超时
                           GET_CLIENT_MANAGER.loginManager.status = LoginStatus_timeout;
                           return;
                       }
                       else if ( status == ResponseErrorCode_902 ) {
                           // 异地登录
                           if (kClientManagerUid > 0) {
                               GET_CLIENT_MANAGER.loginManager.status = LoginStatus_conflit;
                               [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusConflit
                                                                                   object:nil
                                                                                 userInfo:@{ @"message":kConflitMsg }];
                           }
                           return;
                       }
                       else if ( status == ResponseErrorCode_903 && GET_CLIENT_MANAGER.loginManager.status == LoginStatus_Success ) {
                           // 登录失效,退出登录成功UI不显示弹窗提示
                           if (kClientManagerUid > 0) {
                               GET_CLIENT_MANAGER.loginManager.status = LoginStatus_failed;
                               [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusFailed object:nil userInfo:nil];
                           }
                           return;
                       }
                       // 每次信令返回都存储当前token
                       NSString *token = responseObject[@"token"];
                       if (token && token.length > 0) {
                           [UserDefaultsWrapper setUserDefaultsObject:token forKey:kPublicToken];
                       }

                       if (complete) {
                           complete(responseObject, nil);
                       }
                   }
               }
               failure:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
                   NSLog(@"/n ********** (%@)发送信令 ********* \n服务器接口: %@ \ncomm: %@ \ntoken: %@ \n参数: %@ \n网络错误: %@ \n ************* 信令结束 ********** ",
                         newBody[kRequestNodeComm][@"pid"], task.currentRequest.URL,[newBody objectForKey:@"comm"],[newBody objectForKey:@"token"], body, error.localizedDescription);
                   if (complete) {
                       complete(nil, error);
                   }
               }];
    }
    else {
        if (complete) {
            complete(nil, [NSError errorWithDomain:kNetWorkError code:5000 userInfo:nil]);
        }
    }
}

- (void)uploadHeadPortrait:(NSDictionary *)body    // 上传图片的参数
                     count:(NSInteger)count        // 文件块数
                    fileid:(NSInteger)fileid       // 文件块编号
                 imageData:(NSData *)data          // 图片二进制流数据
                  complete:(HttpClientCallBack)complete {
    if (_manager.reachabilityManager.reachable) {
        NSString *url = nil;
        // http请求序列化为JSON串
        NSMutableDictionary *tmpBody = [[NSMutableDictionary alloc] initWithDictionary:body];
        if (data) {
            url                    = [self getHttpPath:@"appCustomerMyMessageController" interface:@"submitHeadPortraitMethod"];
            tmpBody[@"fileStream"] = [EncryptEngine encodeBase64Data:data];
            tmpBody[@"fileNo"]     = @(fileid);
            //        tmpBody[@"length"] = @(data.length);
        }
        else {
            url = [self getHttpPath:@"appCustomerMyMessageController" interface:@"unionHeadPortraitMethod"];
        }

        NSDictionary *newBody = [self createHttpBody:tmpBody encoderRSA:NO];
        [_manager POST:url
            parameters:newBody
              progress:^(NSProgress * _Nonnull uploadProgress) {
                  NSLog(@"uploadProgress = %@", uploadProgress);
              }
               success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
                   NSLog(@"/n ********** (%@)发送信令 ********* \n服务器接口: %@ \ncomm: %@ \ntoken: %@ \n参数: %@ \n服务器响应: %@ \n ************* 信令结束 ********** ",
                         newBody[kRequestNodeComm][@"pid"], task.currentRequest.URL,[newBody objectForKey:@"comm"],[newBody objectForKey:@"token"], body, responseObject);

                   if (responseObject == nil
                       || ![responseObject isKindOfClass:[NSDictionary class]]
                       || [responseObject count] == 0) {
                       if (complete) {
                           complete(nil, [NSError errorWithDomain:kNetWorkError code:5000 userInfo:nil]);
                       }
                   }
                   else {
                       // token失效,自动重新登录
                       NSInteger status = [responseObject[@"status"] integerValue];
                       NSString *msg = responseObject[@"msg"];
                       if (status == ResponseErrorCode_900 || status == ResponseErrorCode_901) {
                           // 登录超时
                           GET_CLIENT_MANAGER.loginManager.status = LoginStatus_timeout;
                           return;
                       }
                       else if ( status == ResponseErrorCode_902 ) {
                           // 异地登录
                           if (kClientManagerUid > 0) {
                               GET_CLIENT_MANAGER.loginManager.status = LoginStatus_conflit;
                               [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusConflit
                                                                                   object:nil
                                                                                 userInfo:@{ @"message":kConflitMsg }];
                           }
                           return;
                       }
                       else if ( status == ResponseErrorCode_903 && GET_CLIENT_MANAGER.loginManager.status == LoginStatus_Success ) {
                           // 登录失效,退出登录成功UI不显示弹窗提示
                           if (kClientManagerUid > 0) {
                               GET_CLIENT_MANAGER.loginManager.status = LoginStatus_failed;
                               [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusFailed object:nil userInfo:nil];
                           }
                           return;
                       }
                       // 每次信令返回都存储当前token
                       NSString *token = responseObject[@"token"];
                       if (token && token.length > 0) {
                           [UserDefaultsWrapper setUserDefaultsObject:token forKey:kPublicToken];
                       }

                       if (complete) {
                           complete(responseObject, nil);
                       }
                   }
               }
               failure:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
                   NSLog(@"/n ********** (%@)发送信令 ********* \n服务器接口: %@ \ncomm: %@ \ntoken: %@ \n参数: %@ \n网络错误: %@ \n ************* 信令结束 ********** ",
                         newBody[kRequestNodeComm][@"pid"], task.currentRequest.URL,[newBody objectForKey:@"comm"],[newBody objectForKey:@"token"], body, error.localizedDescription);
                   if (complete) {
                       complete(nil, error);
                   }
               }];
    }
    else {
        if (complete) {
            complete(nil, [NSError errorWithDomain:kNetWorkError code:5000 userInfo:nil]);
        }
    }
}

- (NSString *)getHTML5UrlFromString:(NSString *)path {
    return [NSString stringWithFormat:@"%@/html/loan/H5pages/%@", self.baseHttpUrl, path];
}

#pragma mark -- private method

- (NSString *)getHttpPath:(NSString *)module interface:(NSString *)interface {
    return [NSString stringWithFormat:@"%@/%@/%@", self.baseHttpUrl, module, interface];
}

- (NSDictionary *)getCommNode {
    return @{ @"pid":[[UIDevice currentDevice] deviceIdentifierID], @"type":@(IS_IPHONE ? 2 : 4), @"version":APP_SERVER_VERSION, @"us":APP_us };
}

- (NSString *)getTokenNode {
    return [UserDefaultsWrapper userDefaultsObject:kPublicToken];
}

- (NSDictionary *)createHttpBody:(NSDictionary *)body encoderRSA:(BOOL)encoder {
    NSMutableDictionary *newBody = [[NSMutableDictionary alloc] initWithCapacity:1];
    // comm节点
    newBody[kRequestNodeComm] = [self getCommNode];

    // token节点
    NSString *token = [self getTokenNode];
    if (token && token.length > 0) {
        newBody[kRequestNodeToken] = token;
    }


    // body节点,只对body节点进行加密
//    body = [NSDictionary dictionaryWithObjectsAndKeys:@"www",@"wangyingjie", nil];
    if (body) {
//        if (encoder) {
//            NSString *text      = [[Utility toJSONString:body] stringByReplacingOccurrencesOfString:@"\n" withString:kNullStr];
//            NSString *publicKey = [UserDefaultsWrapper userDefaultsObject:kRSAPublicKey];
//            if (publicKey == nil || publicKey.length == 0 || self.encryptError) {
//                publicKey = kPublicKey;
//            }
//            newBody[kRequestNodeBody] = [EncryptEngine encryptRSA:text publicKey:publicKey];
//        }
//        else {
            newBody[kRequestNodeBody] = body;
//        }
    }
    return newBody;
}

@end
