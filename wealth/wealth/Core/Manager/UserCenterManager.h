//
//  UserCenterManager.h
//  wealth
//
//  Created by wangyingjie on 16/4/8.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^UserCenterManagerCallBack)(NSString *errMsg);


@interface UserCenterManager : NSObject


@property (nonatomic, strong) UserCenterMainModel *ucMainModel;   /**< */
@property (nonatomic, assign) long long code;   /**< */


@property (nonatomic, strong) NSMutableArray *bankList;   /**< */
@property (nonatomic, strong) NSMutableArray *bankMessageList;   /**< */



/**
 *    初始化消息信息
 */
- (void)initInformation;

/**
 *    清空消息信息
 */
- (void)clearInformation;
/**
 *  获取我的页面信息
 *
 *  @param completion 信息回调
 */
- (void)getUserCenterMainMessageComplete:(UserCenterManagerCallBack)completion;
/**
 *  获取鉴权成功列表
 *
 *  @param completion 信息回调
 */
- (void)getMyBankMessageListComplete:(UserCenterManagerCallBack)completion;
/**
 *  获取银行列表
 *
 *  @param completion 信息回调
 */
- (void)getBankListComplete:(UserCenterManagerCallBack)completion;
/**
 *  鉴权
 *
 *  @param msgDic     信息
 *  @param completion 信息回调
 */
- (void)submitTheBankMessageWithDic:(NSDictionary *)msgDic Complete:(UserCenterManagerCallBack)completion;







@end
