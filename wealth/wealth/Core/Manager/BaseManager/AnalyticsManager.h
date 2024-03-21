//
//  AnalyticsManager.h
//  wealth
//
//  Created by wangyingjie on 15/9/1.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/objc.h>
#import "ShareEngine.h"

/**
 *    @author wangyingjie, 15-12-24 14:12:41
 *
 *    社会化分享数据
 */
@interface AppShareStatistics : BaseModel

@property (nonatomic, assign) ShareType shareChannel;   // 分享渠道
@property (nonatomic, copy) NSString *shareTitle;       // 分享标题
@property (nonatomic, copy) NSString *shareContent;     // 分享内容
@property (nonatomic, copy) NSString *shareAccount;     // 分享账号
@property (nonatomic, copy) NSString *shareName;        // 分享姓名
@property (nonatomic, copy) NSString *shareUrl;         // 分享链接
@property (nonatomic, assign) BoolType shareResult;     // 分享是否成功

@end

// 日志
@interface LogInformation : BaseModel <NSCoding>

- (instancetype)initWithUsrId:(long long)userId;

@property (nonatomic, copy) NSString *userId;       // 用户Id
@property (nonatomic, copy) NSString *type;         // 设备型号
@property (nonatomic, assign) NSInteger channelId;  // 渠道号
@property (nonatomic, assign) NSInteger netType;      // 联网方式
@property (nonatomic, copy) NSString *ip;           // IP地址
@property (nonatomic, copy) NSString *operators;    // 运营商
@property (nonatomic, copy) NSString *system;       // 操作系统
@property (nonatomic, copy) NSString *time;         // 日志时间
@property (nonatomic, copy) NSString *deviceCode;   // 设备唯一标示
@property (nonatomic, copy) NSString *version;      // 程序版本号
@property (nonatomic, assign) NSInteger logType;    // 日志类型

@end

// 启动日志
@interface LoginLogInformation : LogInformation

@property (nonatomic, copy) NSString *userId;       // 用户Id
@property (nonatomic, copy) NSString *type;         // 设备型号
@property (nonatomic, assign) NSInteger channelId;  // 渠道号
@property (nonatomic, assign) NSInteger netType;    // 联网方式
@property (nonatomic, copy) NSString *ip;           // IP地址
@property (nonatomic, copy) NSString *operators;    // 运营商
@property (nonatomic, copy) NSString *system;       // 操作系统
@property (nonatomic, copy) NSString *time;         // 日志时间
@property (nonatomic, copy) NSString *deviceCode;   // 设备唯一标示
@property (nonatomic, copy) NSString *version;      // 程序版本号

@property (nonatomic, copy) NSString *region;       // 位置信息
@property (nonatomic, assign) NSInteger startType;    // 启动方式
@property (nonatomic, copy) NSString *messageId;    // 推送消息Id

@end

// 退出日志
@interface LogoutLogInformation : LogInformation

@property (nonatomic, copy) NSString *userId;       // 用户Id
@property (nonatomic, copy) NSString *type;         // 设备型号
@property (nonatomic, assign) NSInteger channelId;  // 渠道号
@property (nonatomic, assign) NSInteger netType;      // 联网方式
@property (nonatomic, copy) NSString *ip;           // IP地址
@property (nonatomic, copy) NSString *operators;    // 运营商
@property (nonatomic, copy) NSString *system;       // 操作系统
@property (nonatomic, copy) NSString *time;         // 日志时间
@property (nonatomic, copy) NSString *deviceCode;   // 设备唯一标示
@property (nonatomic, copy) NSString *version;      // 程序版本号

@property (nonatomic, assign) NSInteger logoutType;           // 退出方式
@property (nonatomic, assign) NSTimeInterval onlineTimes;   // APP运行总时长
@property (nonatomic, assign) NSInteger pageNum;            // 跳转页面总数
@property (nonatomic, assign) NSInteger lastPageId;         // 最后一个页面Id

@end

// 注册日志
@interface RegistLogInformation : LogInformation

@property (nonatomic, copy) NSString *userId;       // 用户Id
@property (nonatomic, copy) NSString *type;         // 设备型号
@property (nonatomic, assign) NSInteger channelId;  // 渠道号
@property (nonatomic, assign) NSInteger netType;      // 联网方式
@property (nonatomic, copy) NSString *ip;           // IP地址
@property (nonatomic, copy) NSString *operators;    // 运营商
@property (nonatomic, copy) NSString *system;       // 操作系统
@property (nonatomic, copy) NSString *time;         // 日志时间
@property (nonatomic, copy) NSString *deviceCode;   // 设备唯一标示
@property (nonatomic, copy) NSString *version;      // 程序版本号

@property (nonatomic, copy) NSString *mobile;       // 注册的手机号
@property (nonatomic, copy) NSString *region;       // 位置信息
@property (nonatomic, assign) NSInteger success;         // 是否注册成功
@property (nonatomic, copy) NSString *reason;       // 失败原因

@end

// 页面访问日志
@interface ViewControllerLogInformation : LogInformation

@property (nonatomic, copy) NSString *userId;       // 用户Id
@property (nonatomic, copy) NSString *type;         // 设备型号
@property (nonatomic, assign) NSInteger channelId;  // 渠道号
@property (nonatomic, assign) NSInteger netType;      // 联网方式
@property (nonatomic, copy) NSString *ip;           // IP地址
@property (nonatomic, copy) NSString *operators;    // 运营商
@property (nonatomic, copy) NSString *system;       // 操作系统
@property (nonatomic, copy) NSString *time;         // 日志时间
@property (nonatomic, copy) NSString *deviceCode;   // 设备唯一标示
@property (nonatomic, copy) NSString *version;      // 程序版本号

@property (nonatomic, assign) NSInteger pageId;           // 页面Id
@property (nonatomic, copy) NSString *adId;             // 广告Id
@property (nonatomic, assign) NSInteger leaveType;        // 离开页面方式
@property (nonatomic, copy) NSString *begTime;      // 进入页面时间
@property (nonatomic, copy) NSString *endTime;      // 离开页面时间

@end

// 推送消息日志
@interface PushMessageLogInformation : LogInformation

@property (nonatomic, copy) NSString *userId;       // 用户Id
@property (nonatomic, copy) NSString *type;         // 设备型号
@property (nonatomic, assign) NSInteger channelId;  // 渠道号
@property (nonatomic, assign) NSInteger netType;      // 联网方式
@property (nonatomic, copy) NSString *ip;           // IP地址
@property (nonatomic, copy) NSString *operators;    // 运营商
@property (nonatomic, copy) NSString *system;       // 操作系统
@property (nonatomic, copy) NSString *time;         // 日志时间
@property (nonatomic, copy) NSString *deviceCode;   // 设备唯一标示
@property (nonatomic, copy) NSString *version;      // 程序版本号

@property (nonatomic, copy) NSString *pushTime;     // 推送时间
@property (nonatomic, copy) NSString *messageId;                // 消息Id
@property (nonatomic, copy) NSString *ok;                       // 推送失败原因
@property (nonatomic, copy) NSString *pushReachTime;     // 推送到达时间

@end

// 操作日志
@interface ActionLogInformation : LogInformation

@property (nonatomic, copy) NSString *userId;       // 用户Id
@property (nonatomic, copy) NSString *type;         // 设备型号
@property (nonatomic, assign) NSInteger channelId;  // 渠道号
@property (nonatomic, assign) NSInteger netType;      // 联网方式
@property (nonatomic, copy) NSString *ip;           // IP地址
@property (nonatomic, copy) NSString *operators;    // 运营商
@property (nonatomic, copy) NSString *system;       // 操作系统
@property (nonatomic, copy) NSString *time;         // 日志时间
@property (nonatomic, copy) NSString *deviceCode;   // 设备唯一标示
@property (nonatomic, copy) NSString *version;      // 程序版本号

@property (nonatomic, copy) NSString *begTime;      // 开始时间
@property (nonatomic, copy) NSString *endTime;      // 结束时间
@property (nonatomic, assign) NSInteger actionType; // 操作类型:1.点击按钮 2.点击输入
@property (nonatomic, assign) NSInteger actionId;   // 操作id
@property (nonatomic, assign) NSInteger inputFirstnot; // 1-首次填写，2-修改
@property (nonatomic, assign) NSInteger inputType;  // 1-筛选下拉框，2-手动输入
@property (nonatomic, assign) NSTimeInterval inputTime; // 填写时长
/*
 （1）	action_type=1时记录代表服务器返回对点击行为的处理结果，如点击后页面应该发生跳转实际跳转失败，则此处记录：失败
 （2）	action_type=2时记录输入的具体值，如“姓名”用户输入“李三”则次数记录：李三
 */
@property (nonatomic, copy) NSString *behaviorArg;

@end


@interface AnalyticsManager : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(AnalyticsManager);

+ (void)suspend;
+ (void)resume;

/**
 *    统计社会化分享数据统计
 *
 *    @param shareData 统计的分享数据
 */
+ (void)submitShareDataMethod:(AppShareStatistics *)shareData;

/**
 *    反欺诈数据上传
 */
+ (void)submitAntiFraudDataMethod;

/**
 *    @author wangyingjie, 15-12-24 16:12:22
 *
 *    启动日志记录
 *
 *    @param application   应用对象
 *    @param launchOptions 启动参数
 */
+ (void)logAppSetup:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/**
 *    @author wangyingjie, 15-12-25 16:12:09
 *
 *    注册信息日志记录
 *
 *    @param registLogInformation 注册信息
 */
+ (void)logAppRegist:(RegistLogInformation *)registLogInformation;

/**
 *    @author wangyingjie, 15-12-25 16:12:06
 *
 *    退出登录日志记录
 *
 *    @param logoutLogInformation 退出登录信息
 */
+ (void)logAppLogout:(LogoutLogInformation *)logoutLogInformation;

/**
 *    @author wangyingjie, 16-12-27 16:12:04
 *
 *    页面退出日志记录
 *
 *    @param viewControllerLogInformation 页面信息
 */
+ (void)logAppViewController:(ViewControllerLogInformation *)viewControllerLogInformation;

/**
 *    @author wangyingjie, 15-12-25 16:12:41
 *
 *    推送消息日志记录
 *
 *    @param pushMessageLogInformation 推送日志信息
 */
+ (void)logAppPushMessage:(PushMessageLogInformation *)pushMessageLogInformation;

/**
 *    @author wangyingjie, 16-12-30 15:12:41
 *
 *    用户操作日志记录
 *
 *    @param actionLogInformation 操作日志信息
 */
+ (void)logAppAction:(ActionLogInformation *)actionLogInformation;

/**
 *    @author wangyingjie, 15-12-24 14:12:17
 *
 *    @param class 日志类型
 *    1.启动(APP启动时记录) 
 *    2.注册(注册完成（成功或失败时记录)
 *    3.页面访问(离开每个页面时记录)
 *    4.退出(APP应用程序退出时记录)
 *    5.推送消息到达(内容服务器返回数据处理完毕时记录)
 */
+ (void)submitLogMethod:(Class)class;

@end
