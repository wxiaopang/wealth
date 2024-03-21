//
//  UMAnalyticsEngine.m
//  wealth
//
//  Created by wangyingjie on 14/12/17.
//  Copyright (c) 2014年 puhui. All rights reserved.
//

#import "UMAnalyticsEngine.h"

@interface UMAnalyticsEngine ()

@end

@implementation UMAnalyticsEngine

- (void)start {
    if ( !_enable ) {
        _enable = YES;

        // 如果不需要捕捉异常，注释掉此行
        [MobClick setCrashReportEnabled:YES];
        
        // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
        [MobClick setLogEnabled:NO];
        
        //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
        [MobClick setAppVersion:XcodeAppVersion];
        
        //reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
        //channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
        [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy)REALTIME channelId:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    }
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    NSLog(@"online config has fininshed and note = %@", note);
}

- (void)setLatitude:(double)latitude longitude:(double)longitude {
    if ( _enable ) {
        [MobClick setLatitude:latitude longitude:longitude];
    }
}

- (void)setLocation:(CLLocation *)location {
    if ( _enable ) {
        [MobClick setLocation:location];
    }
}

- (void)beginLogPageView:(NSString *)pageName {
    if ( _enable ) {
        [MobClick beginLogPageView:pageName];
    }
}

- (void)endLogPageView:(NSString *)pageName {
    if ( _enable ) {
        [MobClick endLogPageView:pageName];
    }
}

- (void)event:(NSString *)eventId {
    if ( _enable ) {
        [MobClick endEvent:eventId];
    }
}

@end
