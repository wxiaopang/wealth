//
//  HttpClientAPI.h
//  wealth
//
//  Created by wangyingjie on 14/12/16.
//  Copyright (c) 2014年 puhui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, ResponseErrorCode) {
    ResponseErrorCode_OK  = 1,          // 服务器处理成功
    ResponseErrorCode_700 = 700,        // 非Android或iPhone类型
    ResponseErrorCode_800 = 800,        // 接收请求参数异常
    ResponseErrorCode_801 = 801,        // 服务器处理出现异常
    ResponseErrorCode_802 = 802,        // 解密失败
    ResponseErrorCode_900 = 900,        // 登录超时(token参数为空)
    ResponseErrorCode_901 = 901,        // 登录超时(token不为空但是过了有效期)
    ResponseErrorCode_902 = 902,        // 其他地方登录
    ResponseErrorCode_903 = 903,        // 用户未登录
    ResponseErrorCode_904 = 904,        // 已登录
};


typedef void (^HttpClientCallBack)(id JSONResponse, NSError *error);

@interface HttpClientAPI : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(HttpClientAPI);

@property (nonatomic, readonly) AFHTTPSessionManager *manager;

@property (nonatomic, assign) BOOL enableHttps;

@property (nonatomic, copy) NSString *baseHttpUrl;

@property (nonatomic, readonly) SDWebImageOptions options;


- (NSString *)getHTML5UrlFromString:(NSString *)path;

// GET
- (void)get:(NSString *)url
    headers:(NSDictionary *)headers
     params:(NSDictionary *)params
   complete:(HttpClientCallBack)complete;

// 信令请求接口(默认使用RSA加密)
- (void)postWithModule:(NSString *)module
             interface:(NSString *)interface
                  body:(NSDictionary *)body
              complete:(HttpClientCallBack)complete;

// 信令请求接口
- (void)postWithModule:(NSString *)module
             interface:(NSString *)interface
                  body:(NSDictionary *)body
            encoderRSA:(BOOL)encoder
              complete:(HttpClientCallBack)complete;

// 文件上传接口 (以常规信令方式)
- (void)uploadImage:(NSDictionary *)body    // 上传图片的参数
              count:(NSInteger)count        // 文件块数
             fileid:(NSInteger)fileid       // 文件块编号
          imageData:(NSData *)data          // 图片二进制流数据
           complete:(HttpClientCallBack)complete;


// 反馈图片接口
- (void)uploadSuggestImage:(NSDictionary *)body    // 上传图片的参数
                     count:(NSInteger)count        // 文件块数
                    fileid:(NSInteger)fileid       // 文件块编号
                 imageData:(NSData *)data          // 图片二进制流数据
                  complete:(HttpClientCallBack)complete;

// 头像图片接口
- (void)uploadHeadPortrait:(NSDictionary *)body    // 上传图片的参数
                     count:(NSInteger)count        // 文件块数
                    fileid:(NSInteger)fileid       // 文件块编号
                 imageData:(NSData *)data          // 图片二进制流数据
                  complete:(HttpClientCallBack)complete;

@end
