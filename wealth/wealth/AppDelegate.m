//
//  AppDelegate.m
//  wealth
//
//  Created by wangyingjie on 16/3/14.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "AppDelegate.h"
#import "UIWindow+Shake.h"
#import "SplashViewController.h"
#import "EncryptEngine.h"
#import "UncaughtExceptionHandler.h"




#ifdef DEBUG
#import "UIView+DTDebug.h"
#endif



@interface AppDelegate ()<UINavigationControllerDelegate> {
    NSTimeInterval _start_time;  // 当前APP运行时间
}

@property (nonatomic, assign) BOOL isReported;
@property (nonatomic, assign) BOOL isShowLoginStatusFailed;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
//@property (nonatomic, strong) NSTimer *backgroundTimer;

@end

@implementation AppDelegate

@synthesize systemDate = _systemDate;

+ (void)initialize {
    
    //default settings
//    [iRate sharedInstance].useAllAvailableLanguages = YES;
//    [iRate sharedInstance].promptForNewVersionIfUserRated = NO;
//    [iRate sharedInstance].onlyPromptIfLatestVersion = YES;
//    [iRate sharedInstance].onlyPromptIfMainWindowIsAvailable = YES;
//    [iRate sharedInstance].promptAtLaunch = YES;
//    [iRate sharedInstance].usesUntilPrompt = 5.0f;
//    [iRate sharedInstance].eventsUntilPrompt = 10.0f;
//    [iRate sharedInstance].daysUntilPrompt = 1.0f;
//    [iRate sharedInstance].usesPerWeekForPrompt = 0.0f;
//    [iRate sharedInstance].remindPeriod = 1.0f;
//    [iRate sharedInstance].verboseLogging = NO;
//    [iRate sharedInstance].previewMode = NO;
}

- (instancetype)init {
    self = [super init];
    if ( self ) {

    }
    return self;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 监听锁屏事件
    [self registerforDeviceLockNotification];
    //电池条颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [MLTransition validatePanPackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypePan];
    
    [UncaughtExceptionHandler installUncaughtExceptionHandler];
    
    [[ClientManager sharedClientManager] initInformation];
    // 获取公钥
    GET_HTTP_API;
    
    if ([[UserDefaultsWrapper userDefaultsObject:@"clearDocument"] integerValue] < 1) {
        [GET_CLIENT_MANAGER clearCacheTheDocument];
        [UserDefaultsWrapper setUserDefaultsObject:@"1" forKey:@"clearDocument"];
    }
    
    //获取并缓存原生的UserAgent(设置过后每次还会变回来)
    if (![[ClientManager sharedClientManager] getOriginalUserAgent]) {
        UIWebView *tempWebView = [[UIWebView alloc] init];
        NSString *originalUserAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        [[ClientManager sharedClientManager] saveOriginalUserAgent:originalUserAgent];
    }
    
    
    
    // 配置友盟数据统计
    [GET_UM_ANALYTICS start];
    [Growing startWithAccountId:GlowingIO_KEY];
    
    // 注册远程通知
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    [GET_CLIENT_MANAGER.pushManager application:application didFinishLaunchingWithOptions:launchOptions];
    [self jPushStartWithOptions:launchOptions];//极光推送
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    @weakify(self);
    [RACObserve(self.window, rootViewController) subscribeNext:^(id x) {
        @strongify(self)
        if ( [x isKindOfClass:[CustomNavigationViewController class]] ) {
            self.visitedPageNumber++;
            
            CustomNavigationViewController *navigationViewController = (CustomNavigationViewController *)x;
            navigationViewController.delegate = self;
        }
    }];
    [self.window makeKeyAndVisible];
    
#ifdef DEBUG
    // 打开 UIView主线程检查
    [UIView toggleViewMainThreadChecking];
#endif
    
    // 摇一摇更换服务器地址，debug时使用
//    [UIWindow swizzleMethod:@selector(motionEnded:withEvent:) withMethod:@selector(shakeWindow:withEvent:)];
    
    [self launchApplication];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
//
    if ( GET_CLIENT_MANAGER.loginManager.status == LoginStatus_Success ) {
        [AnalyticsManager submitAntiFraudDataMethod];
        if ( !self.isShared ) {
            CustomNavigationViewController *navigationViewController = (CustomNavigationViewController *)ROOT_NAVIGATECONTROLLER;
            [GesturePasswordController presentGesturePasswordController:navigationViewController.visibleViewController complete:nil];
        }
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // 页面进入日志
    ViewControllerLogInformation *viewControllerLogInformation = [self lastViewControllerLogInformation];
    if ( viewControllerLogInformation ) {
        viewControllerLogInformation.leaveType = 1;
        viewControllerLogInformation.begTime = GET_SYSTEM_DATE_STRING;
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    if ( !_screen_locked ) { [self logoutLog:1]; }
    
    // 标记一个长时间运行的后台任务将开始
    // 通过调试发现，iOS给了我们额外的10分钟（600s）来执行这个任务。
    @weakify(self);
    self.backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^(void) {
        @strongify(self);
        // 当应用程序留给后台的时间快要到结束时（应用程序留给后台执行的时间是有限的）， 这个Block块将被执行
        // 我们需要在次Block块中执行一些清理工作。
        // 如果清理工作失败了，那么将导致程序挂掉
        
        // 清理工作需要在主线程中用同步的方式来进行
        [self endBackgroundTask];
    }];
    
//    [self submitAllLog];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"applicationWillTerminate");
}

- (void)endBackgroundTask {
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        @strongify(self);
        if (self != nil){
            // 停止定时器
//            [self.backgroundTimer invalidate];
            
            // 每个对 beginBackgroundTaskWithExpirationHandler:方法的调用,必须要相应的调用 endBackgroundTask:方法。这样，来告诉应用程序你已经执行完成了。
            // 也就是说,我们向 iOS 要更多时间来完成一个任务,那么我们必须告诉 iOS 你什么时候能完成那个任务。
            // 也就是要告诉应用程序：“好借好还”嘛。
            // 标记指定的后台任务完成
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
            // 销毁后台任务标识符
            self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }
    });
}

- (void)timerMethod:(NSTimer *)paramSender {
    _start_time++;
    
    // debug backgroundTimeRemaining 属性包含了程序留给的我们的时间
    //    NSTimeInterval backgroundTimeRemaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
    //    if (backgroundTimeRemaining == DBL_MAX) {
    //        NSLog(@"Background Time Remaining = Undetermined");
    //    } else {
    //        NSLog(@"Background Time Remaining = %.02f Seconds", backgroundTimeRemaining);
    //    }
}

static void displayStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    CFStringRef nameCFString = (CFStringRef)name;
    NSString *lockState = (__bridge NSString*)nameCFString;
    AppDelegate *appDelegate = (__bridge AppDelegate *)(observer);
    if([lockState isEqualToString:@"com.apple.springboard.lockcomplete"]) {
        [appDelegate logoutLog:3];
    } else {
        NSLog(@"com.apple.springboard.lockstate");
    }
}

- (void)registerforDeviceLockNotification {
    //Screen lock notifications
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), //center
                                    (__bridge const void *)(self), // observer
                                    displayStatusChanged, // callback
                                    CFSTR("com.apple.springboard.lockcomplete"), // event name
                                    NULL, // object
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), //center
                                    (__bridge const void *)(self), // observer
                                    displayStatusChanged, // callback
                                    CFSTR("com.apple.springboard.lockstate"), // event name
                                    NULL, // object
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
}

- (NSInteger)lastPageId {
    NSInteger pageid = 0;
    if ( [self.window.rootViewController isKindOfClass:[CustomNavigationViewController class]] ) {
        CustomNavigationViewController *navigationViewController = (CustomNavigationViewController *)self.window.rootViewController;
        pageid = navigationViewController.visibleViewController.view.tag;
    }
    return pageid;
}

- (ViewControllerLogInformation *)lastViewControllerLogInformation {
    ViewControllerLogInformation *viewControllerLogInformation = nil;
    if ( [self.window.rootViewController isKindOfClass:[CustomNavigationViewController class]] ) {
//        CustomNavigationViewController *navigationViewController = (CustomNavigationViewController *)self.window.rootViewController;
//        UIViewController *vc = navigationViewController.visibleViewController;
//        if ( [vc isKindOfClass:[LoanViewController class]] ) {
//            LoanViewController *v = (LoanViewController *)vc;
//            viewControllerLogInformation = v.currentView.viewControllerLogInformation;
//        } else if ( vc.viewControllerLogInformation && vc.viewControllerLogInformation.pageId > 0 ) {
//            viewControllerLogInformation = vc.viewControllerLogInformation;
//        }
    }
    return viewControllerLogInformation;
}

- (void)logoutLog:(NSInteger)type {
    // 应用退出日志
//    LogoutLogInformation *logoutLogInformation = [[LogoutLogInformation alloc] initWithUsrId:kClientManagerUid];
//    logoutLogInformation.logoutType = type;                                     // 退出方式
//    logoutLogInformation.pageNum = self.visitedPageNumber;                      // 跳转页面总数
//    logoutLogInformation.lastPageId = self.lastPageId;                          // 最后一个页面id
//    [AnalyticsManager logAppLogout:logoutLogInformation];
//    
//    // 页面退出日志
//    ViewControllerLogInformation *viewControllerLogInformation = [self lastViewControllerLogInformation];
//    if ( viewControllerLogInformation ) {
//        viewControllerLogInformation.leaveType = 3;
//        viewControllerLogInformation.endTime = GET_SYSTEM_DATE_STRING;
//        [AnalyticsManager logAppViewController:viewControllerLogInformation];
//    }
}

- (UMAnalyticsEngine *)umAnalyticsEngine {
    if ( _umAnalyticsEngine == nil ) {
        _umAnalyticsEngine = [[UMAnalyticsEngine alloc] init];
    }
    return _umAnalyticsEngine;
}

- (void)setSystemDate:(NSDate *)systemDate {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self->_systemDate = systemDate;
    });
}

- (NSDate *)systemDate {
    if (_systemDate == nil) {
        _systemDate = [NSDate date];
    }
    return _systemDate;
}

- (NSTimeInterval)getSystemTime {
    return floor([self.systemDate timeIntervalSince1970] + _start_time);
}

- (NSTimeInterval)start_time {
    return _start_time;
}

- (NSString *)getSystemTimeString {
    NSString *tmp = [[NSDate dateWithTimeIntervalSince1970:[self getSystemTime]] description];
    return [tmp stringByReplacingOccurrencesOfString:@" +0000" withString:@""];
}

#pragma mark handleOpenURL

// Will be deprecated at some point, please replace with application:openURL:sourceApplication:annotation:
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[ShareEngine sharedShareEngine] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([Growing handleUrl:url]) // 请务必确保该函数被调用
    {
//        return [[ShareEngine sharedShareEngine] handleOpenURL:url];
//    }else{
//        return [[ShareEngine sharedShareEngine] handleOpenURL:url];
    }
//    return [[ShareEngine sharedShareEngine] handleOpenURL:url];
    return YES;
}

- (void)launchApplication {
    if ( !_isReported ) {
        self.window.rootViewController = [[SplashViewController alloc] init];
        [self.window makeKeyAndVisible];
    }
}


- (void)submitAllLog {
//    //上传启动日志
//    [AnalyticsManager submitLogMethod:[LoginLogInformation class]];
//    
//    //上传注册日志
//    [AnalyticsManager submitLogMethod:[RegistLogInformation class]];
//    
//    // 上传页面访问日志
//    [AnalyticsManager submitLogMethod:[ViewControllerLogInformation class]];
//    
//    // 上传退出日志
//    [AnalyticsManager submitLogMethod:[LogoutLogInformation class]];
//    
//    // 上传推送消息日志
//    [AnalyticsManager submitLogMethod:[PushMessageLogInformation class]];
//    
//    // 上传用户操作日志
//    [AnalyticsManager submitLogMethod:[ActionLogInformation class]];
}

#pragma mark -- push method
#ifdef __IPHONE_8_0

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void(^)())completionHandler {
    NSLog(@"\n[application:handleActionWithIdentifier:forRemoteNotification:completionHandler] identifier = %@;\nuserInfo = %@\n", identifier, userInfo);
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]) {
        
    } else if ([identifier isEqualToString:@"answerAction"]) {
        
    }
}

#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];//极光推送
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError = %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"didReceiveRemoteNotification = %@", userInfo);
    [GET_CLIENT_MANAGER.pushManager parseLocalNotification:userInfo];
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"didReceiveRemoteNotification = %@", userInfo);
    [GET_CLIENT_MANAGER.pushManager parseRemoteNotification:userInfo];
    [JPUSHService handleRemoteNotification:userInfo];//极光推送
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"didReceiveLocalNotification = %@", notification.userInfo);
    [GET_CLIENT_MANAGER.pushManager parseLocalNotification:notification.userInfo];
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];//极光推送
}

- (void)jPushStartWithOptions:(NSDictionary *)launchOptions {
    if (IOS_VERSION >= 8.0) {
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    }
    else {
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    [JPUSHService setupWithOption:launchOptions appKey:JPushAPP_KKEY channel:@"AppStore" apsForProduction:NO];
}



#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}


@end
