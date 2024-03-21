//
//  ClientManager.h
//  wealth
//
//  Created by wangyingjie on 15/2/28.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseManager.h"
//#import "AddressBookManager.h"
#import "PushManager.h"
#import "LoginManager.h"
#import "ProductionManager.h"
#import "UserCenterManager.h"
#import "MessageManager.h"

#import "AnalyticsManager.h"
#import "CustomerManager.h"

#define kClientManagerUid GET_CLIENT_MANAGER.uid

/**
 *    服务器系统时间类型枚举
 */
typedef NS_ENUM(NSInteger, SystemTimeType){
    /**
     *    产品选择时间
     */
    SystemTimeType_ProductInformation,
    /**
     *    借款信息录入时间
     */
    SystemTimeType_LoanInformation,
    /**
     *    身份基础信息录入时间
     */
    SystemTimeType_IdentityInformation_base,
    /**
     *    居住信息录入时间
     */
    SystemTimeType_IdentityInformation_living,
    /**
     *    资产信息录入时间
     */
    SystemTimeType_IdentityInformation_property,
    /**
     *    收入信息录入时间
     */
    SystemTimeType_IdentityInformation_income,
    /**
     *    房产信息录入时间
     */
    SystemTimeType_IdentityInformation_house,
    /**
     *    经营信息录入时间
     */
    SystemTimeType_IdentityInformation_operate,
    /**
     *    直系亲属信息录入时间
     */
    SystemTimeType_LinkManInformation_lineal,
    /**
     *    职业联系人信息录入时间
     */
    SystemTimeType_LinkManInformation_colleagues,
    /**
     *    其他联系人信息录入时间
     */
    SystemTimeType_LinkManInformation_other,
    /**
     *    职业信息录入时间
     */
    SystemTimeType_Occupation,
    /**
     *    淘宝信息验证时间
     */
    SystemTimeType_TaoBao,
    /**
     *    附件拍照信息录入时间
     */
    SystemTimeType_Photo,
};

@interface ClientManager : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(ClientManager);

/**
 *    当前登录用户的uid
 */
@property (nonatomic, assign) long long uid;

/**
 *    用户位置信息
 */
@property (nonatomic, readonly) LocationInformation *locationInformation;

/**
 *    数据库管理者
 */
@property (nonatomic, readonly) DataBaseManager *dataBaseManager;

/**
 *    通讯录管理者
 */
//@property (nonatomic, readonly) AddressBookManager *addressBookManager;

/**
 *    推送通知管理者
 */
@property (nonatomic, readonly) PushManager *pushManager;

/**
 *    注册登录管理者
 */
@property (nonatomic, readonly) LoginManager *loginManager;

/**
 *    用户信息管理者
 */
@property (nonatomic, readonly) CustomerManager *customerManager;

/**
 *    产品信息管理者
 */
@property (nonatomic, readonly) ProductionManager *productionManager;
/**
 *    用户信息管理者
 */
@property (nonatomic, readonly) UserCenterManager *userCenterManager;
/**
 *    信息管理者
 */
@property (nonatomic, readonly) MessageManager *messageManager;

/**
 *    初始化当前登录用户的所有缓存信息
 */
- (void)initInformation;

/**
 *    清空当前登录用户的所有缓存信息
 */
- (void)clearInformation;

#pragma mark -- 业务操作接口

/**
 *    从服务器端获取RSA加密公钥
 *
 *    @param callback 反馈结果回调
 */
- (void)getRSAPublicKey:(void(^)(BOOL isSuccessed))callback;

//
/**
 *    检测版本更新
 *
 *    @param completion 反馈结果回调
 */
- (void)getVersionMethod:(VersionInformationCallBack)completion;

/**
 *    获取服务器时间
 *
 *    @param type 服务器系统时间类型枚举
 */
- (void)getSystemTimeMethod:(SystemTimeType)type;

/**
 *    获取服务器时间
 *
 *    @param text 服务器系统时间的文字描述
 */
- (void)getSystemTimeByString:(NSString *)text;

/**
 *    提交客户设备推送别名(IOS push机制)
 */
- (void)submitCustomerPushAliasMethod;

/**
 *    上传位置信息
 */
//- (void)submitCustomerGpsMethod;

/**
 *    获取位置信息
 */
- (void)getCustomerGpsInformation;

/**
 *    上传通讯录信息
 */
//- (void)submitMobileContactsMethod;

/**
 *    上传通话记录信息 (ios 不支持获取通话记录)
 */
//- (void)submitMobileRecordsMethod;

/**
 *    获取省份信息
 *
 *    @param callback 业务支持的所有省份列表
 */
- (void)getProvinceMethod:(void(^)(NSArray *provinces, NSString *errMsg))callback;

/**
 *    获取城市信息
 *
 *    @param provinceCode 省份编码
 *    @param completion 所选省份下的城市列表
 */
- (void)getCityMethod:(NSString *)provinceCode complete:(void(^)(NSArray *citys, NSString *errMsg))completion;

/**
 *    获取区域信息
 *
 *    @param cityCode   城市编码
 *    @param completion 所选城市下的地区列表
 */
- (void)getDistMethod:(NSString *)cityCode complete:(void(^)(NSArray *dists, NSString *errMsg))completion;

/**
 *    手动退出登录，并清空缓存信息
 *
 *    @param block 退出登录回调
 */
- (void)manualRelogon:(dispatch_block_t)block;


//resetUserAgent(H5需求)
- (void)saveOriginalUserAgent:(NSString *)originalUserAgent;

- (NSString *)getOriginalUserAgent;

- (void)setOriginalUserAgent;

- (void)setIQianJinUserAgent;

- (void)clearCacheTheDocument;


@end
