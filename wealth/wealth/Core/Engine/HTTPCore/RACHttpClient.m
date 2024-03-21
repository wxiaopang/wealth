//
//  RACHttpClient.m
//  wealth
//
//  Created by wangyingjie on 15/12/2.
//  Copyright © 2015年 普惠金融. All rights reserved.
//

#import "RACHttpClient.h"
#import "AFHTTPSessionManager+RACSupport.h"

#define kDefaultHttpUrl         @"baseHttpUrl"
#define kRequestNodeComm        @"comm"
#define kRequestNodeToken       @"token"
#define kRequestNodeBody        @"body"
#define kCodeKey                @"code"
#define kMessageKey             @"msg"
#define kStatusKey              @"status"
#define kTyreErrorDomain        @"com.puhuifinance.httperror"
#define ERROR_FORMAT(x, y, z) [NSError errorWithDomain:(x) code:(y) userInfo:(z)]

@interface RACHttpClient () {
    NSString *_baseHttpUrl;
}

@property (nonatomic, assign) BOOL           encryptError;      // 标记RSA加密是否发生错误

@end

@implementation RACHttpClient

SYNTHESIZE_SINGLETON_FOR_CLASS(RACHttpClient);

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configManager];
        [self setDefaultHttpAddress];
    }
    return self;
}

- (void)setDefaultHttpAddress {
    NSString *baseHttpUrl = [UserDefaultsWrapper userDefaultsObject:kDefaultHttpUrl];
    if ( baseHttpUrl ) {
        self.baseHttpUrl = baseHttpUrl;
    } else {
        self.baseHttpUrl = HTML5_BASE_URL;
    }
}

// 创建网络管理
- (void)configManager {
    _manager                    = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:HTTP_BASE_URL]];
    _manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/plain", nil];
    self.enableHttps            = [HTTP_BASE_URL hasPrefix:@"https:"];

    // 监控网络状态变化
    @weakify(self);
    [_manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @strongify(self);
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi: {
//                RACSignal *signal = [self rac_baseRequest:@"publicKeyController/getPublicKeyMethod" parameters:nil];
//                [signal flattenMap:^RACStream *(RACTuple *responseAndResponseObject) {
//                    RACTupleUnpack(NSHTTPURLResponse *HTTPURLResponse, id responseObject) = responseAndResponseObject;
//                    NSLog(@"responseAndResponseObject = %@", responseAndResponseObject);
//                }];

                NSString     *t_path  = [self getHttpPath:@"publicKeyController/getPublicKeyMethod"];
                NSDictionary *newBody = [self createHttpBody:nil encoderRSA:YES];
                RACSignal *signal = [self.manager rac_POST:t_path parameters:newBody];
                [[signal flattenMap:^RACStream *(RACTuple *responseAndResponseObject) {
                    RACTupleUnpack(NSHTTPURLResponse *HTTPURLResponse, id responseObject) = responseAndResponseObject;
                    NSLog(@"HTTPURLResponse = %@\nresponseObject = %@", HTTPURLResponse, responseObject);
                    return nil;
                }] subscribeNext:^(id x) {
                    NSLog(@"x = %@", x);
                }];

                [signal subscribeError:^(NSError *error) {
                    NSLog(@"error = %@", error);
                }];
            }break;

            case AFNetworkReachabilityStatusNotReachable:
            default: {
                [self.manager.operationQueue cancelAllOperations];
            }break;
        }
    }];
    [_manager.reachabilityManager startMonitoring];
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

- (NSString *)baseHttpUrl {
    if ( _baseHttpUrl ) {
        return _baseHttpUrl;
    } else {
        return HTML5_BASE_URL;
    }
}

- (void)setBaseHttpUrl:(NSString *)baseHttpUrl {
    _baseHttpUrl = [baseHttpUrl copy];
    [UserDefaultsWrapper setUserDefaultsObject:_baseHttpUrl forKey:kDefaultHttpUrl];
    self.enableHttps = [_baseHttpUrl hasPrefix:@"https:"];
}

- (NSString *)getHTML5UrlFromString:(NSString *)path {
    return [NSString stringWithFormat:@"%@/html/loan/H5pages/%@", self.baseHttpUrl, path];
}

#pragma mark -- private method

- (NSString *)getHttpPath:(NSString *)path {
    return [NSString stringWithFormat:@"%@%@", self.baseHttpUrl, path];
}

- (NSDictionary *)getCommNode {
    return @{ @"pid":[[UIDevice currentDevice] deviceIdentifierID], @"type":@(IS_IPHONE ? 2 : 4), @"version":APP_SERVER_VERSION };
}

- (NSString *)getTokenNode {
    return [UserDefaultsWrapper userDefaultsObject:kPublicToken];
}

- (NSDictionary *)createHttpBody:(id)body encoderRSA:(BOOL)encoder {
    NSMutableDictionary *newBody = [[NSMutableDictionary alloc] initWithCapacity:1];
    // comm节点
    newBody[kRequestNodeComm] = [self getCommNode];

    // token节点
    NSString *token = [self getTokenNode];
    if (token && token.length > 0) {
        newBody[kRequestNodeToken] = token;
    }

    // body节点,只对body节点进行加密
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

#pragma mark - base interface

- (RACSignal *)rac_baseRequest:(NSString *)path parameters:(id)parameters {
    return [self rac_baseRequest:path parameters:parameters encoderRSA:!self.enableHttps];
}

- (RACSignal *)rac_baseRequest:(NSString *)path parameters:(id)parameters encoderRSA:(BOOL)encoder {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if ( self.manager.reachabilityManager.reachable ) {
            NSString     *t_path  = [self getHttpPath:path];
            NSDictionary *newBody = [self createHttpBody:parameters encoderRSA:encoder];
            [[self.manager rac_POST:t_path parameters:newBody] reduceEach:^(NSURLResponse *response, id responseObject) {
                NSAssert([responseObject isKindOfClass:NSDictionary.class], @"responseObject not NSDictionary");
                NSAssert([responseObject count] > 0, @"responseObject count is empty");

                NSLog(@"/n ********** (%@)发送信令 ********* \n服务器接口: %@ \n参数: %@ \n服务器返回: %@ \n ************* 信令结束 ********** ",
                      newBody[kRequestNodeComm][@"pid"], t_path, newBody, responseObject);
                return [self parsedResponseObject:responseObject];
            }];
        } else {
            [subscriber sendError:ERROR_FORMAT(kNetWorkError, -1, nil)];
        }
        return nil;
    }];
}

- (RACSignal *)parsedResponseObject:(id)responseObject {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSInteger code = [responseObject[kCodeKey] integerValue];
        NSInteger status = [responseObject[kStatusKey] integerValue];
        NSString *msg = responseObject[kMessageKey];
        if (status == ResponseErrorCode_900 || status == ResponseErrorCode_901) {
            // 登录超时
            GET_CLIENT_MANAGER.loginManager.status = LoginStatus_timeout;
        }
        else if (status == ResponseErrorCode_902) {
            // 异地登录
            GET_CLIENT_MANAGER.loginManager.status = LoginStatus_conflit;
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusConflit
                                                                object:nil
                                                              userInfo:@{ @"message":(msg ? msg : @"您的账号已经在其他地方登录") }];
        }
        else if (status == ResponseErrorCode_903 && GET_CLIENT_MANAGER.loginManager.status == LoginStatus_Success ) {
            // 登录失效
            GET_CLIENT_MANAGER.loginManager.status = LoginStatus_failed;
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusFailed object:nil userInfo:nil];
        }
        else if (status == ResponseErrorCode_802 && [msg isEqualToString:@"没有该设备记录，禁止访问"]) {
            [subscriber sendError:ERROR_FORMAT(kNetWorkError, -1, nil)];
        } else {
            // 每次信令返回都存储当前token
            NSString *token = responseObject[@"token"];
            if (token && token.length > 0) {
                [UserDefaultsWrapper setUserDefaultsObject:token forKey:kPublicToken];
            }

            [subscriber sendNext:RACTuplePack(responseObject)];
            [subscriber sendCompleted];
        }

        return nil;
    }];
}

@end
