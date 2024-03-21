//
//  MessageManager.h
//  wealth
//
//  Created by wangyingjie on 16/5/17.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MessageManagerCallBack)(NSString *errMsg);


@interface MessageManager : NSObject


@property (nonatomic, strong) NSMutableArray *messageList;
@property (nonatomic, assign) long long totalPage;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) MessageDetailModel *msgDetailModel;

/**
 *  获取消息列表
 *
 *  @param number 每页数量
 *  @param page   第几页 从1开始
 */
- (void)getMessageListWithNumber:(NSInteger)number range:(NSInteger)page Complete:(MessageManagerCallBack)completion;

/**
 *  获取消息详情
 *
 *  @param msgId 消息ID
 */
- (void)getMessageDetailWithMessageId:(long long)msgId Complete:(MessageManagerCallBack)completion;

/**
 *  注册推送别名
 *
 *
 */
- (void)registThePushDeviceToken;

/**
 *    初始化消息信息
 */
- (void)initInformation;

/**
 *    清空消息信息
 */
- (void)clearInformation;


@end
