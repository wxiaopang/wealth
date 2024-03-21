//
//  UMAnalyticsEngine.h
//  wealth
//
//  Created by wangyingjie on 14/12/17.
//  Copyright (c) 2014年 puhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobClick.h>

#define um_regist_failed_key                @"um_regist_failed_event"  // 注册失败
#define um_regist_success_key               @"um_regist_success_event" // 注册成功
#define um_submit_failed_contact_key        @"um_submit_failed_contact_event" // 联系人提交失败
#define um_submit_failed_idCard_key         @"um_submit_failed_idCard_event" // 身份提交失败
#define um_submit_failed_loan_key           @"um_submit_failed_loan_event" // 借款提交失败
#define um_submit_failed_profession_key     @"um_submit_failed_profession_event" // 职业提交失败
#define um_submit_success_contact_key       @"um_submit_success_contact_event" // 联系人提交成功
#define um_submit_success_idCard_key        @"um_submit_success_idCard_event" // 身份提交成功
#define um_submit_success_loan_key          @"um_submit_success_loan_event" // 借款提交成功
#define um_submit_success_profession_key    @"um_submit_success_profession_event" // 职业提交成功

#define um_submit_failed_taobao_key         @"um_submit_failed_taobao_event" // 淘宝提交失败
#define um_submit_success_taobao_key        @"um_submit_success_taobao_event" // 淘宝提交成功
#define um_picture_failed_taobao_key        @"um_picture_failed_taobao_event" // 淘宝图片验证码获取失败
#define um_picture_success_taobao_key       @"um_picture_success_taobao_event" // 淘宝图片验证码获取成功
#define um_message_failed_taobao_key        @"um_message_failed_taobao_event" // 淘宝短信验证码获取失败
#define um_message_success_taobao_key       @"um_message_success_taobao_event" // 淘宝短信验证码获取成功


@interface UMAnalyticsEngine : NSObject

@property (nonatomic, readonly) BOOL enable;

- (void)start;

/**
 *    分析用户位置信息
 *
 *    @param latitude  经度
 *    @param longitude 纬度
 */
- (void)setLatitude:(double)latitude longitude:(double)longitude;

/**
 *    分析用户位置信息
 *
 *    @param location 系统位置信息
 */
- (void)setLocation:(CLLocation *)location;

/**
 *    标记进入页面时间点
 *
 *    @param pageName 页面名称
 */
- (void)beginLogPageView:(NSString *)pageName;

/**
 *    标记离开页面时间点
 *
 *    @param pageName 页面名称
 */
- (void)endLogPageView:(NSString *)pageName;

/**
 *    统计事件册数
 *
 *    @param eventId 事件key
 */
- (void)event:(NSString *)eventId;

@end
