//
//  PushManager.h
//  wealth
//
//  Created by wangyingjie on 14/12/17.
//  Copyright (c) 2014年 puhui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PushManagerCallBack)(NSDictionary *userInfo);

@interface PushManager : NSObject

//SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(PushManager);

/**
 *    是否激活远端push（仅支持ios 8.0以上）
 */
@property (nonatomic, assign) BOOL enableRemotePush;

/**
 *    是否激活本地push
 */
@property (nonatomic, assign) BOOL enableLocalPush;

/**
 *    apple APNS中心获取到的deviceToken，用于远端push
 */
@property (nonatomic, strong) NSString *deviceToken;

/**
 *    push通知处理回调
 */
@property (nonatomic, copy) PushManagerCallBack handleNotificationBlock;

@property (nonatomic, strong) PushModel *pushmodel;

/**
 *    App 启动时初始化推送通知管理者
 *
 *    @param application
 *    @param launchOptions
 */
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/**
 *    解析本地通知信息
 *
 *    @param notification 通知信息
 */
- (void)parseLocalNotification:(NSDictionary *)notification;

/**
 *    解析远端通知信息
 *
 *    @param userInfo 通知信息
 */
- (void)parseRemoteNotification:(NSDictionary *)userInfo;

/**
 *    初始化信息
 */
- (void)initInformation;

/**
 *    清空信息
 */
- (void)clearInformation;




@end
