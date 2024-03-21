//
//  VersionInformation.h
//  wealth
//
//  Created by wangyingjie on 15/4/24.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VersionStatus) {
    VersionStatus_faild = 0,    /**< 版本检测失败 */ 
    VersionStatus_unknown,      /**< 有新版本，但不可更新 */
    VersionStatus_normal,       /**< 有新版本，不要求强制更新 */
    VersionStatus_force,        /**< 有新版本，需强制更新 */
    VersionStatus_none,         /**< 已经是最新版本 */
};

@interface VersionInformation : BaseModel

@property (nonatomic, copy) NSString *appVersion;           /**< 升级版本*/
@property (nonatomic, assign) VersionStatus updateStatus;   /**< 升级类别*/
@property (nonatomic, copy) NSString *updateMessage;        /**< 升级消息*/
@property (nonatomic, copy) NSString *updateDoc;            /**< 升级提醒*/
@property (nonatomic, copy) NSString *deviceType;           /**< 设备类别*/
@property (nonatomic, copy) NSString *updateURI;            /**< 升级地址*/



@end

typedef void(^VersionInformationCallBack)(VersionInformation *versionInformation);
