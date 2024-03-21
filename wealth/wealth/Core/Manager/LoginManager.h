//
//  LoginManager.h
//  wealth
//
//  Created by wangyingjie on 15/3/3.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountInformationModel.h"




typedef void(^LoginManagerCallBack)(NSString *errMsg);

@interface LoginManager : NSObject

@property (nonatomic, strong) AccountInformationModel *accountInformation;

/**
 *    标记APP启动过程中是否显示过手势验证页
 */
@property (nonatomic, assign) BOOL isHiddeShowGesturePasswordController;

/**
 *    当前登录状态
 */
@property (nonatomic, assign) LoginStatus status;

/**
 *    初始化注册登录信息
 */
- (void)initInformation;

/**
 *    清空注册登录信息
 */
- (void)clearInformation;

#pragma mark -- 业务操作接口
/**
 *  检查版本
 */
- (void)checkVersion;

///**
// *    退出登录
// *
// *    @param completion 回调
// */
//- (void)customerLoginOutMethod:(LoginManagerCallBack)completion;
- (void)userLogout;

/**
 *    登录
 *
 *    @param usrename   用户名
 *    @param password   用户密码
 *    @param completion 回调
 */
- (void)customerLoginMethod:(NSString *)usrename password:(NSString *)password complete:(HttpClientCallBack)completion;

/**
 *    自动重登录(登录超时，二次登录)
 *
 *    @param complete 回调
 */
- (void)autoRelogin:(void(^)(BOOL successed, NSString *error))complete;


/**
 *    注册第一步，验证手机号
 *
 *    @param mobile     手机号
 *    @param verifyCode 验证码
 *    @param passWord   密码
 *    @param completion 回调
 */
- (void)checkRegisterVerifyMethod:(NSString *)mobile
                       verifyCode:(NSString *)verifyCode
                         passWord:(NSString *)passWord
                         complete:(LoginManagerCallBack)completion;


/**
 *    登录后客户修改密码（使用手机验证码修改）
 *
 *    @param mobile     手机号
 *    @param verifyCode 验证码
 *    @param password   新密码
 *    @param completion 回调
 */
- (void)loginModifyPasswordByPhoneMethod:(NSString *)mobile
                              verifyCode:(NSString *)verifyCode
                                password:(NSString *)password
                                complete:(LoginManagerCallBack)completion;

/**
 *    登录后客户修改密码验证手机号（使用手机验证码修改）
 *
 *    @param mobile     手机号
 *    @param verifyCode 验证码
 *    @param completion 回调
 */
- (void)loginModifyPasswordByPhoneMethod:(NSString *)mobile
                              verifyCode:(NSString *)verifyCode
                                complete:(LoginManagerCallBack)completion;

/**
 *    获取手机验证码
 *
 *    @param mobile     手机号
 *    @param type       验证码类型
 *    @param completion 回调
 */
- (void)getVerifyCodeMethod:(NSString *)mobile
                       type:(VerifyCodeType)type
                   complete:(LoginManagerCallBack)completion;


- (void)checkThePassWord:(NSString *)pwd complete:(LoginManagerCallBack)completion;



@end
