//
//  GlobalMacro.h
//  wealth
//
//  Created by wangyingjie on 14/12/17.
//  Copyright (c) 2014年 puhui. All rights reserved.
//

#pragma once


#define IS_IPAD                     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IOS_VERSION                 [[[UIDevice currentDevice] systemVersion] floatValue]
#define ScreenHeight                ([[UIScreen mainScreen] bounds].size.height)
#define ScreenWidth                 ([[UIScreen mainScreen] bounds].size.width)
#define TabelViewHeight             (ScreenHeight - kNavigationBarHeight)

#define iPhone4                     [UIDevice currentDevice].iphone4
#define iPhone4s                    [UIDevice currentDevice].iphone4s
#define iPhone5                     [UIDevice currentDevice].iphone5
#define iPhone6                     [UIDevice currentDevice].iphone6
#define iPhone6Plus                 [UIDevice currentDevice].iphone6Plus
#define IPHONE4                     ((round([[UIScreen mainScreen] bounds].size.height) == 480)? YES:NO)
#define IPHONE5                     ((round([[UIScreen mainScreen] bounds].size.height) == 568)? YES:NO)
#define IPHONE6                     ((round([[UIScreen mainScreen] bounds].size.height) == 667)? YES:NO)
#define IPHONE6P                    ((round([[UIScreen mainScreen] bounds].size.height) == 736)? YES:NO)
#define ScreenWidth320              ((round([[UIScreen mainScreen] bounds].size.width) == 320)? YES:NO)
#define ScreenWidth375              ((round([[UIScreen mainScreen] bounds].size.width) == 375)? YES:NO)
#define ScreenWidth414              ((round([[UIScreen mainScreen] bounds].size.width) == 414)? YES:NO)

#define kNavigationBarHeight        ((IOS_VERSION >= 7.0f) ? 64.0f : 44.0f)
#define kStatusBarHeight            ((IOS_VERSION >= 7.0f) ? 0.0f : 20.0f)
#define kTabBarHeight               49.0f //(iPhone4 || iPhone5) ? 49.0f : ( iPhone6 ? 69.0f : 69.0f)
#define kMainTableViewTopOffset     28.0f
#define kLeftCommonMargin           (ScreenWidth320 ? 15.0f : 18.0f)
#define kSeparateLineHeight         0.5f   //分割线粗

#define SINGLE_LINE_WIDTH           (1.0f / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1.0f / [UIScreen mainScreen].scale) / 2)

#define kProportion                 (ScreenWidth/(750.f/2.0f))

/* 宏两数字取大小 */
#define kGetMax(x, y, z)            ((z) > (MAX((x), (y))) ? (z) : (MAX((x), (y))))
#define kGetMin(x, y, z)            ((z) < (MIN((x), (y))) ? (z) : (MIN((x), (y))))

#define kNullStr                    @""
#define BIT_AND_MASK(x, y)              (((x) & (y)) ? YES : NO)
#define BIT_OR_MASK(x, y)               (((x) | (y)) ? YES : NO)
#define ENDEDITING                      [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
#define KEY_WINDOW                      [[UIApplication sharedApplication] keyWindow]
#define TOP_VIEWCONTROLLER              [[UIApplication sharedApplication] keyWindow].rootViewController
#define TOP_VIEW                        [[UIApplication sharedApplication] keyWindow].rootViewController.view
#define GET_APP_DELEGATE                (AppDelegate *)([UIApplication sharedApplication].delegate)
#define SET_SYSTEM_DATE(x)              [(AppDelegate *)([UIApplication sharedApplication].delegate) setSystemDate:(x)]
#define GET_SYSTEM_DATE                 [(AppDelegate *)([UIApplication sharedApplication].delegate) getSystemTime]
#define GET_SYSTEM_DATE_STRING          [(AppDelegate *)([UIApplication sharedApplication].delegate) getSystemTimeString]
#define GET_RUNNING_TIME                [(AppDelegate *)([UIApplication sharedApplication].delegate) start_time]
#define GET_NETWORK_REACHABILITYSTATUS  [GET_HTTP_API.manager.reachabilityManager currentNetworkReachabilityStatus]
#define ROOT_NAVIGATECONTROLLER         [GET_APP_DELEGATE window].rootViewController
#define ROOT_NAVIGATECONTROLLER_PUSH(vc)    [(UINavigationController *)ROOT_NAVIGATECONTROLLER pushViewController: (vc)animated: YES]
#define ROOT_NAVIGATECONTROLLER_POPTO(vc)   [(UINavigationController *)ROOT_NAVIGATECONTROLLER popToViewController: (vc)animated: YES]
#define ROOT_NAVIGATECONTROLLER_POPTOROOT   [(UINavigationController *)ROOT_NAVIGATECONTROLLER popToRootViewControllerAnimated:YES]
#define ROOT_NAVIGATECONTROLLER_PRES(vc)    [(UINavigationController *)ROOT_NAVIGATECONTROLLER presentViewController: (vc)animated: YES completion:^{}]

#define ENDEDITING                      [[[UIApplication sharedApplication] keyWindow] endEditing:YES];


#define kOtherSeparatString         @"<--->"
#define kLoginStatusFailed          @"LoginStatusFailed"
#define kLoginStatusConflit         @"LoginStatusConflit"
#define kPhotoPicture               @"PhotoPicture"
#define kDocumentPath               [PathEngine getDocumentPath]
#define GET_CLIENT_MANAGER          [ClientManager sharedClientManager]
#define GET_HTTP_API                [HttpClientAPI sharedHttpClientAPI]
#define GET_HTTP_BASEURL            GET_HTTP_API.baseHttpUrl
#define GET_SDWEBIMAGE_OPTIONS      GET_HTTP_API.options
#define GET_UM_ANALYTICS            [GET_APP_DELEGATE umAnalyticsEngine]
#define kPhotoPicturePath           [NSString stringWithFormat:@"%@/%@/%@", [PathEngine getDocumentPath], @(kClientManagerUid), kPhotoPicture]

#define kSuccessed                  @"成功"

#define ConvertPropertyToDictionary(obj, dictionary)   do { \
NSAssert([(dictionary) isKindOfClass:[NSMutableDictionary class]], @"class is not NSMutableDictionary."); \
NSArray *propertyNames = [(obj) getPropertyNamesArray]; \
                                    [propertyNames enumerateObjectsUsingBlock:^(NSString *property, NSUInteger idx, BOOL *stop) { \
                                        if (![property isEqualToString:@"isMergered"]) { \
                                            id object = [(obj) valueForKey:property]; \
                                            if (object) {  \
                                                [(dictionary) setObject:object forKey:property]; \
                                            } else { \
                                                [(dictionary) setObject:kNullStr forKey:property]; \
                                            } \
                                        } \
                                    }]; \
                                } while (0)

#define LOG_BUTTON_ACTION(x, y) do { \
                                    ActionLogInformation *actionLogInformation = [[ActionLogInformation alloc] initWithUsrId:kClientManagerUid]; \
                                    actionLogInformation.actionType = 1; \
                                    actionLogInformation.actionId = (x); \
                                    actionLogInformation.behaviorArg = (y) ? (y) : kSuccessed; \
                                    actionLogInformation.begTime = GET_SYSTEM_DATE_STRING; \
                                    actionLogInformation.endTime = actionLogInformation.begTime; \
                                    [AnalyticsManager logAppAction:actionLogInformation]; \
                                } while (0)

#define LOG_TEXTFIELD_ACTION_BEGIN do { \
                                        ActionLogInformation *actionLogInformation = [[ActionLogInformation alloc] initWithUsrId:kClientManagerUid]; \
                                        actionLogInformation.actionType = 2; \
                                        actionLogInformation.actionId = self.textFieldId; \
                                        actionLogInformation.inputFirstnot = (self.text.length > 0 ? 2 : 1); \
                                        actionLogInformation.inputType = 2; \
                                        actionLogInformation.begTime = GET_SYSTEM_DATE_STRING; \
                                        self.actionLogInformation = actionLogInformation; \
                                    } while (0)

#define LOG_TEXTFIELD_ACTION_END do { \
                                    self.actionLogInformation.endTime = GET_SYSTEM_DATE_STRING; \
                                    self.actionLogInformation.inputTime = [DateEngine timeDiff:self.actionLogInformation.begTime end:self.actionLogInformation.endTime]; \
                                    self.actionLogInformation.behaviorArg = (self.text.length > 0 ? self.text : @""); \
                                    [AnalyticsManager logAppAction:self.actionLogInformation]; \
                                 } while (0)

#define LOG_TEXTFIELD_ACTION_OVER(x, y, z, t) do { \
                                                ActionLogInformation *actionLogInformation = [[ActionLogInformation alloc] initWithUsrId:kClientManagerUid]; \
                                                actionLogInformation.actionType = 2; \
                                                actionLogInformation.actionId = x; \
                                                actionLogInformation.inputFirstnot = (y); \
                                                actionLogInformation.inputType = 1; \
                                                actionLogInformation.behaviorArg = [(z) length] > 0 ? (z) : @""; \
                                                actionLogInformation.endTime = GET_SYSTEM_DATE_STRING; \
                                                actionLogInformation.begTime = (t); \
                                                actionLogInformation.inputTime = [DateEngine timeDiff:actionLogInformation.begTime end:actionLogInformation.endTime]; \
                                                [AnalyticsManager logAppAction:actionLogInformation]; \
                                            } while (0)

#define NotificationCenterAddObserver(x, y, z)  [[NSNotificationCenter defaultCenter] addObserver: self selector: x name: y object: z]
#define NotificationCenterRemoveObserver        [[NSNotificationCenter defaultCenter] removeObserver:self]

#define CREATECOLOR(r, g, b, a)        [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

/**
 *  Radians to Degrees
 */
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

/**
 *  Degrees to radians
 */
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define SAFE_RELEASE(x) do { \
if (x != nil) { \
free(x); \
x = nil; \
} \
} while (0)

#define SAFE_DELETE(x) do { \
if (x != nil) { \
delete x; \
x = nil; \
} \
} while (0)

#define SK_TRY_BODY_FINALLY(__target, __finally) \
@try {\
{__target}\
}\
@catch (NSException *exception) {\
    NSLog(@"exception = %@", exception);\
}\
@finally {\
{__finally}\
}

#define SK_TRY_BODY(__target) \
@try {\
{__target}\
}\
@catch (NSException *exception) {\
    NSLog(@"exception = %@", exception);\
}\
@finally {\
\
}

#define kNetWorkError           @"网络不给力，请在更好的网络环境下使用"
#define kCustomHeaderReady      @"CustomHeaderReady"

#define kOriginalUserAgent              @"OriginalUserAgent"


/***  UI部分宏定义  ***/
/* V4.0字体区分中英文和版本号,粗体由于使用较少没写类方法 */
#define FONT_CN_NORMAL(fontSize)  (IOS_VERSION >= 9.0 ? [UIFont fontWithName:@".SFUIText-Light" size:(fontSize/2)] : [UIFont fontWithName:@".HelveticaNeueInterface-Light" size:(fontSize/2)]) //中文常规字体
#define FONT_EN_NORMAL(fontSize)  (IOS_VERSION >= 9.0 ? [UIFont fontWithName:@".SFUIDisplay-Thin" size:(fontSize/2)] : [UIFont fontWithName:@".HelveticaNeueInterface-Light" size:(fontSize/2)]) //英文常规字体
#define FONT_CN_BOLD(fontSize)  (IOS_VERSION >= 9.0 ? [UIFont fontWithName:@".SFUIText-Regular" size:(fontSize/2)] : [UIFont systemFontOfSize:(fontSize/2)]) //中文粗体
#define FONT_EN_BOLD(fontSize)  (IOS_VERSION >= 9.0 ? [UIFont fontWithName:@".SFUIDisplay-Regular" size:(fontSize/2)] : [UIFont systemFontOfSize:(fontSize/2)]) //英文粗体



//信息录入相关新添加
typedef void (^VoidBlock)();
typedef void (^IntegerBlock)(NSUInteger index);
typedef void (^FloatBlock)(CGFloat floatNumber);
typedef void (^DoubleStringBlock)(double floatNumber, NSString *string);
typedef void (^IntegerStringBlock)(NSUInteger index, NSString *string);
typedef void (^StringBlock)(NSString *string);
typedef void (^ButtonBlock)(UIButton *button);

#define kNSStringFromInteger(section)    [NSString stringWithFormat: @"%@", @(section)]

//获取相册图片资源信息相关
#define DEFAULT_ASSETSLIBRARY             [GET_CLIENT_MANAGER.assetsLibraryManager defaultAssetsLibrary]


typedef NS_ENUM(NSInteger, ActionType) {
    ActionType_0, /**< 其他  */
    ActionType_1, /**< 引导页3-立即体验 */
    ActionType_2, /**< 登录页-登录 */
    ActionType_3, /**< 注册第一步-获取验证码 */
    ActionType_4, /**< 注册第二步-立即注册 */
    ActionType_5, /**< 申请借款页-提交申请 */
    ActionType_6, /**< 首页-广告焦点图 */
    ActionType_7, /**< 产品详情页-申请 */
    ActionType_8, /**< 验证资料-下一步 */
    ActionType_9, /**< 征信报告登录页-登录 */
    ActionType_10, /**< 申请征信报告-填写信息页-立即登录 */
    ActionType_11, /**< 申请征信报告-补充信息页-提交 */
    ActionType_12, /**< 手机运营商登录页-登录 */
    ActionType_13, /**< 手机运营商登录页-提交 */
    ActionType_14, /**< 工资流水/经营流水/常用流水登录页-登录 */
    ActionType_15, /**< 工资流水/经营流水/常用流水登录页-提交 */
    ActionType_16, /**< 淘宝登录页-登录 */
    ActionType_17, /**< 淘宝登录页-提交 */
    ActionType_18, /**< 填写资料-下一步 */
    ActionType_19, /**< 填写基本信息-基础信息页-保存 */
    ActionType_20, /**< 填写基本信息—居住信息页-保存 */
    ActionType_21, /**< 填写基本信息-资产信息页-保存 */
    ActionType_22, /**< 填写基本信息页-提交 */
    ActionType_23, /**< 填写职业信息页-提交 */
    ActionType_24, /**< 填写联系人信息页-提交 */
    ActionType_25, /**< 确认资料页-立刻验证 */
    ActionType_26, /**< 确认资料页-确认借款资料 */
    ActionType_27, /**< 拍照资料-提交拍照资料 */
    ActionType_28, /**< 我的-消息 */
    ActionType_29, /**< 我的-更换产品 */
    ActionType_30, /**< 我的-使用帮助 */
    ActionType_31, /**< 我的-意见反馈 */
    ActionType_32, /**< 我的-分享APP */
    ActionType_33, /**< 我的-设置 */
    ActionType_34, /**< 首页 */
    ActionType_35, /**< 借款 */
    ActionType_36, /**< 账单 */
    ActionType_37, /**< 我的 */

    ActionType_39 = 39, /**< 填写身份信息页-提交 */
    ActionType_40 = 40, /**< 征信报告身份验证码-提交 */
    
    //3.1版本
    ActionType_41 = 41,       /**< 社保和公积金页－下一步 */
    ActionType_42 = 42,      /**< 验证社保页-提交 */
    ActionType_43 = 43,      /**< 验证公积金页-提交 */
};


/**
 *    自定义bool类型
 */
typedef NS_ENUM (NSInteger, BoolType){
    BoolType_unknown = 0,   /**< 未知类型 */
    BoolType_true    = 1,   /**< true */
    BoolType_false   = 2,   /**< false */
};
