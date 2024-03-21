//
//  PushManager.m
//  wealth
//
//  Created by wangyingjie on 14/12/17.
//  Copyright (c) 2014年 puhui. All rights reserved.
//

#import "PushManager.h"
#import "MainViewController.h"
#import <GCDObjC/GCDObjC.h>

#define kReceiveMessageSoundFile    @"ReceiveMessage.m4r"

@interface PushManager ()

@property (nonatomic, strong) NSMutableArray *pushList;

@end

@implementation PushManager

//SYNTHESIZE_SINGLETON_FOR_CLASS(PushManager);

- (instancetype)init {
    self = [super init];
    if ( self ) {
        _pushList = [[NSMutableArray alloc] initWithCapacity:0];
        _enableLocalPush = YES;
        
        //注册远程通知
        UIApplication *application = [UIApplication sharedApplication];
        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationType type = (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
            UIUserNotificationSettings *userNotificationSettings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
            [application registerUserNotificationSettings:userNotificationSettings];
        } else {
            [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeNewsstandContentAvailability
                                                             | UIRemoteNotificationTypeAlert
                                                             | UIRemoteNotificationTypeBadge
                                                             | UIRemoteNotificationTypeSound)];
        }
    }
    return self;
}

//TODO:ios7不适用
- (void)setEnableRemotePush:(BOOL)enableRemotePush {
    if ( enableRemotePush ) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}

- (BOOL)enableRemotePush {
    return [UIApplication sharedApplication].isRegisteredForRemoteNotifications;
}

- (void)setDeviceToken:(NSString *)deviceToken {
    _deviceToken = deviceToken;
    if ( _deviceToken ) {
        [UserDefaultsWrapper setUserDefaults:@{ DeviceTokenStringKEY:_deviceToken }];
    }
}

- (void)setHandleNotificationBlock:(PushManagerCallBack)handleNotificationBlock {
    _handleNotificationBlock = handleNotificationBlock;
    if ( _handleNotificationBlock && _pushList.count > 0 ) {
        [_pushList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            [self saveNotification:obj];
        }];
        _handleNotificationBlock(_pushList.lastObject);
        [_pushList removeAllObjectsSynchronize];
    }
}

- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if ( launchOptions ) {
        id notification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        if ( notification ) {
            [self parseLocalNotification:notification];
        }

        notification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        if ( notification ) {
            [self parseRemoteNotification:notification];
        }
    }
}

- (void)parseLocalNotification:(NSDictionary *)userInfo {
//    if ( userInfo[@"scheduledUpdateLocation"] ) { // 打点功能
//        [LocationEngine sharedLocationEngine].scheduledUpdateLocation = YES;
//        [[LocationEngine sharedLocationEngine] getLocationInformation:NO information:^(LocationInformation *info) {
//            // 上传友盟位置信息
////            [GET_UM_ANALYTICS setLocation:info.location];
//
//            // 上传位置信息
//            [GET_HTTP_API postWithModule:@"customerDataController"
//                               interface:@"submitCustomerGpsMethod"
//                                    body:@{
//                                           @"longitude":[@(info.longitude) stringValue],
//                                           @"latitude":[@(info.latitude) stringValue],
//                                           @"address":info.address.firstObject?info.address.firstObject:kNullStr,
//                                           }
//                                complete:nil];
//        } error:^(NSString *error) {
//            id alertAuthorLocation = [UserDefaultsWrapper userDefaultsObject:kAlertAuthorLocation];
//            if ( alertAuthorLocation == nil ) {
//                [UserDefaultsWrapper setUserDefaultsObject:@(YES) forKey:kAlertAuthorLocation];
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                    message:@"亲爱的用户，本程序需要使用您的位置信息，如您禁止使用，将无法申请借款。"
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"知道了"
//                                                          otherButtonTitles:nil];
//                [alertView showWithCompletion:nil];
//            }
//        }];
//    } else {
//        NSInteger count = [MainViewController messageCount] + 1;
//        [MainViewController setMessageCount:count];
    
    PushModel *pushModel = [[PushModel alloc] initWithDictionary:userInfo];
    GET_CLIENT_MANAGER.pushManager.pushmodel = pushModel;

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:GET_CLIENT_MANAGER.pushManager.pushmodel.pushTitle
                                                            message:GET_CLIENT_MANAGER.pushManager.pushmodel.pushContent
                                                           delegate:nil
                                                  cancelButtonTitle:@"忽略"
                                                  otherButtonTitles:@"现在查看", nil];
        @weakify(self);
        [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            @strongify(self);
            if ( buttonIndex == 1 ) {
                if ( self.handleNotificationBlock ) {
                    self.handleNotificationBlock(userInfo);
                }
            }
        }];
//    }
}

- (void)parseRemoteNotification:(NSDictionary *)userInfo {
    PushModel *pushModel = [[PushModel alloc] initWithDictionary:userInfo];
    GET_CLIENT_MANAGER.pushManager.pushmodel = pushModel;
    id status = userInfo[@"status"];
    if ( status && [status integerValue] == ResponseErrorCode_902 ) {
        // 异地登录
        GET_CLIENT_MANAGER.loginManager.status = LoginStatus_conflit;
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusConflit
                                                            object:nil
                                                          userInfo:@{ @"message":userInfo[@"aps"][@"alert"] }];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    } else {
        [UIApplication sharedApplication].applicationIconBadgeNumber = [userInfo[@"aps"][@"badge"] integerValue];
        
//        NSDictionary *messageDic = @{ @"mid":userInfo[@"mid"],
//                                      @"context":userInfo[@"aps"][@"alert"] };
        if ( GET_CLIENT_MANAGER.loginManager.status == LoginStatus_Success ) {
            // 缓存消息
            [self saveNotification:userInfo];
            [self parseLocalNotification:userInfo];
        } else {
            [_pushList addObjectSynchronize:userInfo];
        }
    }
}

- (void)saveNotification:(NSDictionary *)userInfo {
//    MessageInformation *messageInformation = [[MessageInformation alloc] init];
//    messageInformation.mid = [userInfo[@"mid"] longLongValue];
//    messageInformation.context = userInfo[@"context"];
//    [messageInformation save];
}



/**
 *    初始化信息
 */
- (void)initInformation{
    if (self.pushmodel) {
        self.pushmodel = nil;
    }
    self.pushmodel = [[PushModel alloc] init];
}

/**
 *    清空信息
 */
- (void)clearInformation{
    if (self.pushmodel) {
        self.pushmodel = nil;
    }
}



@end
