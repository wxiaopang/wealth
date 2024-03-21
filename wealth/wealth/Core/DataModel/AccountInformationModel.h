//
//  AccountInformationModel.h
//  wealth
//
//  Created by wangyingjie on 16/3/24.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "BaseModel.h"

@interface AccountInformationModel : BaseModel

@property (nonatomic, assign) long long        userid;                  /**< 当前登录的用户ID */
@property (nonatomic, copy) NSString           *password;               /**< 登录密码 */
@property (nonatomic, copy) NSString           *gesturePassword;        /**< 手势密码 */
@property (nonatomic, copy) NSString           *customerName;           /**< 用户昵称 */
@property (nonatomic, assign) BOOL             enableTouchID;           /**< 启用touch id */
@property (nonatomic, copy) NSString           *mobileNo;               /**< 当前登录的手机号 */
@property (nonatomic, copy) NSString           *picUrl;                 /**< 销售人员头像 */
@property (nonatomic, copy) NSString           *sellerName;             /**< 销售人员姓名 */
@property (nonatomic, copy) NSString           *sellerPosition;         /**< 销售人员姓名 */
@property (nonatomic, assign) BOOL             haveSales;               /**< 是否有销售人员 */
@property (nonatomic, assign) long long        seller;                  /**< 销售人员ID */


//- (void)initAccountInformationWithDic:(NSDictionary *)bodyDic;


@end
