//
//  DataBaseManager.h
//  wealth
//
//  Created by wangyingjie on 15/3/5.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseManager : NSObject

/**
 *    sqlite数据库
 */
@property (readonly, nonatomic) wealthDataBase *appDataBase;

/**
 *    初始化数据库
 */
- (void)initInformation;
- (void)initInformationWithUid:(long long)userId ;

/**
 *    关闭数据库
 */
- (void)clearInformation;

@end
