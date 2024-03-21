//
//  Verisions.h
//  wealth
//
//  Created by wangyingjie on 16/3/16.
//  Copyright © 2016年 puhui. All rights reserved.
//

#ifndef Wealth_Verisions_h
#define Wealth_Verisions_h


#define debugNumber 0

//测试环境下账号体系
#if debugNumber

////app信令请求地址
#define HTML5_BASE_URL              @"http://172.16.7.57:8999"
////app内嵌H5地址
#define HTML5_URL                   @"http://172.16.7.57:8999"
//// 友盟ios（测试）
#define UMENG_APPKEY                @"57159c1367e58eb477000217"
//// 极光推送
#define JPushAPP_KKEY               @"63aa0014b7c023ac1fae2a95"//

//// GlowingIO
#define GlowingIO_KEY               @"bd195f7e4c89364c"//wangyingjie



//正式环境下账号体系
#else
////app信令请求地址
#define HTML5_BASE_URL              @"http://app.puhuiwealth.com"
////app内嵌H5地址
#define HTML5_URL                   @"http://app.puhuiwealth.com"
//// 友盟ios（发布）
#define UMENG_APPKEY                @"57159c4567e58e77d8001442"
//// 极光推送
#define JPushAPP_KKEY               @"63aa0014b7c023ac1fae2a95"//wangyignjie
//// GlowingIO
#define GlowingIO_KEY               @"9e8b54c78cd8b3ca"//liufeng


#endif


#define APP_SERVER_VERSION          @"1.1.0"

#define APP_us                      @"1"






//#define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)



#define kPhoneNumber                @"4008118006"
#define kPhoneNumberDis             @"400-811-8006"
#define kConflitMsg                 @"您的账号已在其他设备上登录。如有疑问请拨打400-811-8006"
#define kMessageWorkTime            @"服务时间:9:00~18:00 周一到周五"

#define kPushAnimationTime       0.25
#define kPopAnimationTime        0.25

#define kTime                       (59)


#define HTTP_BASE_URL               [NSString stringWithFormat:@"%@", HTML5_BASE_URL]

#define kBannerUrl                  [NSString stringWithFormat:@"%@/html/Banner", HTML5_BASE_URL]
#define kAppStoreUrl                [NSString stringWithFormat:@"%@/html/index.html", HTML5_BASE_URL]
#define APP_VERSION                 [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
#define APP_DISPLAYNAME             [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define APP_BUNDEL_ID               [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]
#define APP_BUNDEL_NAME             [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]











#endif /* Verisions_h */
