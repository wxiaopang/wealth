//
//  AnalyticsManager.m
//  wealth
//
//  Created by wangyingjie on 15/9/1.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "AnalyticsManager.h"
#import "UIDevice+Identifier.h"

@implementation AppShareStatistics

@end

// 日志
@implementation LogInformation

- (instancetype)initWithUsrId:(long long)userId {
    self = [super init];
    if ( self ) {
        _userId = userId > 0 ? [NSString stringWithFormat:@"%@", @(userId)] : @"-1";
        _ip = [UIDevice deviceIPAdress];
        _time = GET_SYSTEM_DATE_STRING;
    }
    return self;
}

- (NSInteger)channelId {
    return 101;
}

- (NSString *)type {
    return [UIDevice currentDevice].machineModelName;
}

- (NSInteger)netType {
    return GET_HTTP_API.manager.reachabilityManager.currentNetworkReachabilityStatus;
}


- (NSString *)operators {
    return [UIDevice carrierName];
}

- (NSString *)system {
    return [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
}

- (NSString *)deviceCode {
    return [UIDevice deviceIdentifierID];
}

- (NSString *)version {
    return APP_SERVER_VERSION;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if ( self ) {
        NSArray *propertyNames = [self getPropertyNamesArray];
        [propertyNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id value = [aDecoder decodeObjectForKey:obj];
            if ( value ) {
                [self setValue:value forKey:obj];
            } else {
                [self setValue:kNullStr forKey:obj];
            }
        }];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSArray *propertyNames = [self getPropertyNamesArray];
    [propertyNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = [self valueForKeyPath:obj];
        if ( value ) {
            [aCoder encodeObject:value forKey:obj];
        } else {
            [aCoder encodeObject:kNullStr forKey:obj];
        }
    }];
}

@end

// 启动日志
@implementation LoginLogInformation

@dynamic userId;       // 用户id
@dynamic type;         // 设备型号
@dynamic channelId;  // 渠道号
@dynamic netType;      // 联网方式
@dynamic ip;           // IP地址
@dynamic operators;    // 运营商
@dynamic system;       // 操作系统
@dynamic time;          // 日志时间
@dynamic deviceCode;    // 设备唯一标示
@dynamic version;       // 程序版本号

- (NSInteger)logType {
    return 1;
}

@end

// 注册日志
@implementation RegistLogInformation : LogInformation

@dynamic userId;       // 用户id
@dynamic type;         // 设备型号
@dynamic channelId;  // 渠道号
@dynamic netType;      // 联网方式
@dynamic ip;           // IP地址
@dynamic operators;    // 运营商
@dynamic system;       // 操作系统
@dynamic time;          // 日志时间
@dynamic deviceCode;    // 设备唯一标示
@dynamic version;       // 程序版本号

- (NSInteger)logType {
    return 2;
}

@end

// 退出日志
@implementation LogoutLogInformation

@dynamic userId;       // 用户id
@dynamic type;         // 设备型号
@dynamic channelId;  // 渠道号
@dynamic netType;      // 联网方式
@dynamic ip;           // IP地址
@dynamic operators;    // 运营商
@dynamic system;       // 操作系统
@dynamic time;          // 日志时间
@dynamic deviceCode;    // 设备唯一标示
@dynamic version;       // 程序版本号

- (NSInteger)logType {
    return 4;
}

- (NSTimeInterval)onlineTimes {
    return [UIDevice runningTimeInterval];
}

@end

// 页面访问日志
@implementation ViewControllerLogInformation

@dynamic userId;       // 用户id
@dynamic type;         // 设备型号
@dynamic channelId;  // 渠道号
@dynamic netType;      // 联网方式
@dynamic ip;           // IP地址
@dynamic operators;    // 运营商
@dynamic system;       // 操作系统
@dynamic time;          // 日志时间
@dynamic deviceCode;    // 设备唯一标示
@dynamic version;       // 程序版本号

- (NSInteger)logType {
    return 3;
}

@end

// 推送消息日志
@implementation PushMessageLogInformation

@dynamic userId;       // 用户id
@dynamic type;         // 设备型号
@dynamic channelId;  // 渠道号
@dynamic netType;      // 联网方式
@dynamic ip;           // IP地址
@dynamic operators;    // 运营商
@dynamic system;       // 操作系统
@dynamic time;          // 日志时间
@dynamic deviceCode;    // 设备唯一标示
@dynamic version;       // 程序版本号

- (NSInteger)logType {
    return 5;
}

- (NSString *)pushReachTime {
    return self.time;
}

@end

@implementation ActionLogInformation

@dynamic userId;       // 用户id
@dynamic type;         // 设备型号
@dynamic channelId;  // 渠道号
@dynamic netType;      // 联网方式
@dynamic ip;           // IP地址
@dynamic operators;    // 运营商
@dynamic system;       // 操作系统
@dynamic time;          // 日志时间
@dynamic deviceCode;    // 设备唯一标示
@dynamic version;       // 程序版本号

- (NSInteger)logType {
    return 6;
}

@end

#define kAnalyticsManagerInstance [AnalyticsManager sharedAnalyticsManager]

@interface AnalyticsManager ()

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, assign) BOOL isSuspend;

@end

@implementation AnalyticsManager

SYNTHESIZE_SINGLETON_FOR_CLASS(AnalyticsManager);

- (instancetype)init {
    self = [super init];
    if ( self ) {
        _queue = dispatch_queue_create("com.puhuifinance.AnalyticsManager", DISPATCH_QUEUE_SERIAL);
        _isSuspend = YES;
        dispatch_suspend(_queue);

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textDidBeginEditing:)
                                                     name:UITextFieldTextDidBeginEditingNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textDidEndEditing:)
                                                     name:UITextFieldTextDidEndEditingNotification
                                                   object:nil];
    }
    return self;
}

- (void)textDidBeginEditing:(NSNotification *)notification {
    if ( [notification.object isKindOfClass:[UITextField class]] ) {
        UITextField *textField = (UITextField *)notification.object;
        if ( textField.textFieldId > 0 ) {
            ActionLogInformation *actionLogInformation = [[ActionLogInformation alloc] initWithUsrId:kClientManagerUid];
            actionLogInformation.actionType = 2;
            actionLogInformation.actionId = textField.textFieldId;
            actionLogInformation.inputFirstnot = (textField.text.length > 0 ? 2 : 1);
            actionLogInformation.inputType = 2;
            actionLogInformation.begTime = GET_SYSTEM_DATE_STRING;
            textField.actionLogInformation = actionLogInformation;
        }
    }
}

- (void)textDidEndEditing:(NSNotification *)notification {
    if ( [notification.object isEqual:self] ) {
        UITextField *textField = (UITextField *)notification.object;
        if ( textField.textFieldId > 0 && textField.actionLogInformation ) {
            textField.actionLogInformation.endTime = GET_SYSTEM_DATE_STRING;
            textField.actionLogInformation.inputTime = [DateEngine timeDiff:textField.actionLogInformation.begTime end:textField.actionLogInformation.endTime];
            textField.actionLogInformation.behaviorArg = (textField.text.length > 0 ? textField.text : @"");
            [AnalyticsManager logAppAction:textField.actionLogInformation];
        }
    }
}

+ (void)suspend {
    if ( !kAnalyticsManagerInstance.isSuspend ) {
        kAnalyticsManagerInstance.isSuspend = YES;
        dispatch_suspend(kAnalyticsManagerInstance.queue);
    }
}

+ (void)resume {
    if ( kAnalyticsManagerInstance.isSuspend ) {
        kAnalyticsManagerInstance.isSuspend = NO;
        dispatch_resume(kAnalyticsManagerInstance.queue);
    }
}

+ (void)submitShareDataMethod:(AppShareStatistics *)shareData {
    NSMutableDictionary *body = [[NSMutableDictionary alloc] initWithCapacity:0];
    ConvertPropertyToDictionary(shareData, body);
    [GET_HTTP_API postWithModule:@"appCustomerAnalysisDataController"
                       interface:@"submitShareDataMethod"
                            body:body
                        complete:nil];
}

+ (void)submitAntiFraudDataMethod {
    [GET_HTTP_API postWithModule:@"appCustomerAnalysisDataController"
                       interface:@"submitAntiFraudDataMethod"
                            body:@{ @"clientType":@(2),
                                    @"isMaximumAuthority":@([UIDevice currentDevice].isJailbroken ? BoolType_true : BoolType_false),
                                    @"isSimulator":@([UIDevice currentDevice].isSimulator ? BoolType_true : BoolType_false),
                                    @"mobileModel":[UIDevice currentDevice].machineModelName }
                        complete:nil];
}

+ (void)logAppSetup:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    LoginLogInformation *loginLogInformation = [[LoginLogInformation alloc] initWithUsrId:kClientManagerUid];
    loginLogInformation.startType = 1;
    if ( launchOptions ) {
        id notification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        if ( notification ) {
            
        }

        notification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        if ( notification ) {
            NSString *mid = notification[@"mid"] ? notification[@"mid"] : kNullStr;
            loginLogInformation.startType = 2;
            loginLogInformation.messageId = mid;

            PushMessageLogInformation *pushMessageLogInformation = [[PushMessageLogInformation alloc] initWithUsrId:kClientManagerUid];
            pushMessageLogInformation.messageId = mid; // 消息id
            pushMessageLogInformation.pushTime = [DateEngine getYYYYMMDDHHMMSSString:[notification[@"t"] doubleValue]];
            dispatch_async(kAnalyticsManagerInstance.queue, ^{
                NSString *fileName = [NSString stringWithFormat:@"%@/%@", NSStringFromClass([PushMessageLogInformation class]), [DateEngine getTodayString]];
                [UserDefaultsWrapper archiver:pushMessageLogInformation forFile:fileName];
            });
        }
    }

    dispatch_async(kAnalyticsManagerInstance.queue, ^{
        NSString *fileName = [NSString stringWithFormat:@"%@/%@", NSStringFromClass([LoginLogInformation class]), [DateEngine getTodayString]];
        [UserDefaultsWrapper archiver:loginLogInformation forFile:fileName];
    });
}

+ (void)logAppRegist:(RegistLogInformation *)registLogInformation {
    if ( registLogInformation ) {
        dispatch_async(kAnalyticsManagerInstance.queue, ^{
            NSString *fileName = [NSString stringWithFormat:@"%@/%@", NSStringFromClass([RegistLogInformation class]), [DateEngine getTodayString]];
            [UserDefaultsWrapper archiver:registLogInformation forFile:fileName];
        });
    }
}

+ (void)logAppLogout:(LogoutLogInformation *)logoutLogInformation {
    if ( logoutLogInformation ) {
        dispatch_async(kAnalyticsManagerInstance.queue, ^{
            NSString *fileName = [NSString stringWithFormat:@"%@/%@", NSStringFromClass([LogoutLogInformation class]), [DateEngine getTodayString]];
            [UserDefaultsWrapper archiver:logoutLogInformation forFile:fileName];
        });
    }
}

+ (void)logAppViewController:(ViewControllerLogInformation *)viewControllerLogInformation {
    if ( viewControllerLogInformation ) {
        dispatch_async(kAnalyticsManagerInstance.queue, ^{
            NSString *fileName = [NSString stringWithFormat:@"%@/%@", NSStringFromClass([ViewControllerLogInformation class]), [DateEngine getTodayString]];
            [UserDefaultsWrapper archiver:viewControllerLogInformation forFile:fileName];
        });
    }
}

+ (void)logAppPushMessage:(PushMessageLogInformation *)pushMessageLogInformation {
    if ( pushMessageLogInformation ) {
        dispatch_async(kAnalyticsManagerInstance.queue, ^{
            NSString *fileName = [NSString stringWithFormat:@"%@/%@", NSStringFromClass([PushMessageLogInformation class]), [DateEngine getTodayString]];
            [UserDefaultsWrapper archiver:pushMessageLogInformation forFile:fileName];
        });
    }
}

+ (void)logAppAction:(ActionLogInformation *)actionLogInformation {
    if ( actionLogInformation ) {
        dispatch_async(kAnalyticsManagerInstance.queue, ^{
            NSString *fileName = [NSString stringWithFormat:@"%@/%@", NSStringFromClass([ActionLogInformation class]), [DateEngine getTodayString]];
            [UserDefaultsWrapper archiver:actionLogInformation forFile:fileName];
        });
    }
}

+ (void)submitLogMethod:(Class)class {
    dispatch_queue_t t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(t, ^{
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:0];
        NSString *path = [[PathEngine getDocumentPath] stringByAppendingPathComponent:NSStringFromClass(class)];
        NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
        [contentOfFolder enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *fullPath = [path stringByAppendingPathComponent:obj];
            BOOL isDir = NO;
            if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir) {
                id log = [UserDefaultsWrapper unarchiver:[NSString stringWithFormat:@"%@/%@", NSStringFromClass(class), obj]];
                NSLog(@"log %@ time = %@", [NSString stringWithFormat:@"%@/%@", NSStringFromClass(class), obj], [log time]);
                if ( log ) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
                    ConvertPropertyToDictionary(log, dic);
                    [items addObject:dic];
                }
            }
        }];

        NSLog(@"%@ items: %@", NSStringFromClass(class), items);

        if ( items.count > 0 ) {
            [GET_HTTP_API postWithModule:@"customerLogController"
                               interface:@"logTypeMethod"
                                    body:@{ @"logType":@([[[class alloc] init] logType]),
                                            @"items":items }
                                complete:^(id JSONResponse, NSError *error) {
                                    dispatch_async(kAnalyticsManagerInstance.queue, ^{
                                        if ( error ) {

                                        } else {
                                            NSInteger code = [JSONResponse[@"code"] integerValue];
                                            if (code == ResponseErrorCode_OK) {
                                                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                                            }
                                            else {

                                            }
                                        }
                                    });
                                }];
        }
    });
}

@end
