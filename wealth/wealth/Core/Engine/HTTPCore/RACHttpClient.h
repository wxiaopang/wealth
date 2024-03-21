//
//  RACHttpClient.h
//  wealth
//
//  Created by wangyingjie on 15/12/2.
//  Copyright © 2015年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *getPublicKeyInterface = @"publicKeyController/getPublicKeyMethod";

@interface RACHttpClient : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(RACHttpClient);

@property (nonatomic, readonly) AFHTTPSessionManager *manager;

@property (nonatomic, assign) BOOL enableHttps;

@property (nonatomic, copy) NSString *baseHttpUrl;

- (void)setDefaultHttpAddress;

- (RACSignal *)rac_baseRequest:(NSString *)path parameters:(id)parameters;

- (RACSignal *)rac_baseRequest:(NSString *)path parameters:(id)parameters encoderRSA:(BOOL)encoder;

@end
