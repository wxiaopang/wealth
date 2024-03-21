//
//  CustomerManager.h
//  wealth
//
//  Created by wangyingjie on 15/9/8.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CustomerManagerCallBack)(NSString *errMsg);

@interface CustomerManager : NSObject

/**
 *    用户注册信息
 */
//@property (nonatomic, readonly) CustomerInformation *customerInformation;

/**
 *    初始化用户信息
 */
- (void)initInformation;

/**
 *    清空用户信息
 */
- (void)clearInformation;

/**
 *    重置用户信息
 */
- (void)resetInformation;

/**
 *    设置用户信息
 *
 *    @param customerInformation 新用户信息
 */
//- (void)setInformation:(CustomerInformation *)customerInformation;

/**
 *    获取用户注册信息
 *
 *    @param completion 回调
 */
- (void)getCustomerInfoMethod:(CustomerManagerCallBack)completion;

/**
 *    获取用户头像信息
 *
 *    @param completion 回调
 */
- (void)getCustomerMyMessageMethod:(HttpClientCallBack)completion;

@end
