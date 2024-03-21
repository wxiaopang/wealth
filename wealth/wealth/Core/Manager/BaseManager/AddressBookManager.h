//
//  AddressBookManager.h
//  wealth
//
//  Created by wangyingjie on 15/1/13.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAddressBookContactSize         1000
#define kAddressBookContactChanged      @"AddressBookContactChanged"
#define kAddressBookContactIncreased    @"AddressBookContactIncreased"
#define kAddressBookContactDecreased    @"AddressBookContactDecreased"

@interface AddressBookManager : NSObject

//SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(AddressBookManager);

@property (nonatomic, strong) RACSignal *rac_initilized;

/**
 *    通讯录增量数组
 */
@property (nonatomic, readonly) NSArray *increase;

/**
 *    通讯录减量数组
 */
@property (nonatomic, readonly) NSArray *decrease;

/**
 *    标记通讯录是否同步完毕
 */
@property (nonatomic, readonly) BOOL isReady;

/**
 *    通讯录后台同步线程的queue
 */
@property (nonatomic, readonly) GCDQueue *queue;

/**
 *    缓存已经上传成功的通讯录至本地plist文件(以追加方式存储)的同步线程
 */
@property (nonatomic, readonly) GCDQueue *savaQueue;

/**
 *    清空通讯录缓存
 */
- (void)clearInformation;

/**
 *    启动同步通讯录
 */
- (void)refreshAddressBookContacts;

/**
 *    模态显示向通讯录中添加新联系人
 *
 *    @param vc 模态的父窗口
 */
- (void)showNewPersonViewController:(UIViewController *)vc;

/**
 *    获取本地数据库中缓存的通讯录信息
 *
 *    @return 联系人列表
 */
+ (NSArray *)getContactList;

@end
