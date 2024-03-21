//
//  EnumMacro.h
//  wealth
//
//  Created by wangyingjie on 16/3/16.
//  Copyright © 2016年 puhui. All rights reserved.
//

#ifndef Wealth_EnumMacro_h
#define Wealth_EnumMacro_h


typedef NS_ENUM (NSInteger, RegisterTextFeildType){
    RegisterTextFeildType_none      = 0,   /**< 未知类型 */
    RegisterTextFeildType_code      = 1,   /**< 获取验证码 */
    RegisterTextFeildType_PWD_eye   = 2,   /**< 密码可显示 */
    RegisterTextFeildType_PWD       = 3,   /**< 密码不可显示 */
};

typedef NS_ENUM (NSInteger, SetMainCellType){
    SetMainCellType_call        = 0,   /**< 电话 */
    SetMainCellType_section1    = 1,   /**< 空白 */
    SetMainCellType_pwd         = 2,   /**< 修改登录密码 */
    SetMainCellType_gest        = 3,   /**< 修改手势密码 */
    SetMainCellType_wetchat     = 4,   /**< 官方微信 */
    SetMainCellType_about       = 5,   /**< 关于 */
    SetMainCellType_section2    = 6,   /**< 空白 */
    SetMainCellType_logout      = 7,   /**< 退出账号 */
};

/**
 *    登录状态枚举
 */
typedef NS_ENUM(NSInteger, LoginStatus){
    LoginStatus_unknown,        /**< 未登录 */
    LoginStatus_failed,         /**< 登录失败 */
    LoginStatus_timeout,        /**< 登录超时 */
    LoginStatus_conflit,        /**< 异地登录 */
    LoginStatus_Success,        /**< 登录成功 */
    LoginStatus_logout,         /**< 登出 */
};

/**
 *    验证码类型枚举
 */
typedef NS_ENUM(NSInteger, VerifyCodeType){
    VerifyCodeType_Regist,              /**< 注册验证码 */
    VerifyCodeType_Modify_PassWord,     /**< 修改登录密码验证码 */
    VerifyCodeType_Modify_Phone,        /**< 修改登录手机号验证码 */
};

/**
 *    产品页header类型枚举
 */
typedef NS_ENUM(NSInteger, HeaderDisType){
    HeaderDisType_login,            /**< 产品页登录状态 */
    HeaderDisType_haveSale,         /**< 产品页有销售经理 */
    HeaderDisType_noSale,           /**< 产品页头不显示 */
};

/* WebView加载方式Type*/
typedef NS_ENUM(NSInteger, WebViewLoadingType)  {
    WebViewType_Url = 0,                    /**<地址加载*/
    WebViewType_Html,                       /**<html数据加载…………*/
    WebViewType_Url_Several,                /**<从服务器获取地址后加载()…………*/
    WebViewType_Url_Treaty,                 /**<从服务器获取地址后加载(协议)*/
    WebViewType_Url_Problem,                /**<从服务器获取地址后加载(常见问题)*/
    WebViewType_Url_Token,                  /**<从服务器获取地址后加载(获取token)*/
    WebViewType_Url_Baidu,                  /**<百度商桥专用*/
    WebViewType_Url_Token_tab,              /**<从服务器获取地址后加载(获取token)*/
    WebViewType_Url_AITreaty,               /**<从服务器获取地址后加载(奖励说明)…………*/
    WebViewType_Html_Several,               /**<从服务器获取html数据加载()…………*/
    WebViewType_Html_CTAgreement,           /**<从服务器获取地址后加载(爱活宝合同)*/
    WebViewType_Html_TCAgreement,           /**<从服务器获取地址后加载(债权转让合同)*/
    WebViewType_Html_SCAgreement,           /**<从服务器获取地址后加载(散标合同)*/
    WebViewType_Html_DPAgreement,           /**<从服务器获取地址后加载(整存宝+合同)*/
    WebViewType_Html_ATAgreement,           /**<从服务器获取地址后加载(爱定投合同)*/
    WebViewType_Html_NoTitle,
};


/* 登陆注册加载方式Type*/
typedef NS_ENUM(NSInteger, LoginType)  {
    LoginType_Normal = 0,                   /**< 普通登录*/
    LoginType_Gesture,                      /**< 手势密码登陆*/
    LoginType_UserCenter,                   /**< 用户中心登陆*/
    LoginType_Other,                        /**< 其他地方登陆*/
    LoginType_WebView,                      /**< H5交互登陆*/
};

/* PushType*/
typedef NS_ENUM(NSInteger, PushType)  {
    PushType_Normal = 0,                    /**< 推送没有被识别*/
    PushType_Message,                       /**< 信息类推送*/
    PushType_Other,                         /**< 其他类推送*/
};






#endif /* EnumMacro_h */
