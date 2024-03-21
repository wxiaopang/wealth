//
//  BaseModel.h
//  wealth
//
//  Created by wangyingjie on 14/12/16.
//  Copyright (c) 2014年 puhui. All rights reserved.
//

@class wealthDataBase;

@interface BaseModel : MojoModel

- (instancetype)init;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

- (void)mergerModel:(BaseModel *)model;

- (void)forceMergerModel:(BaseModel *)model;

- (NSArray *)getPropertyNamesArray;

- (void)save;

- (void)saveWithComplete:(dispatch_block_t)complete;

- (void)deleteSelf;

- (void)deleteSelfComplete:(dispatch_block_t)complete;

+ (wealthDataBase *)wealthDataBase;

// 数据库需要升级，model字段增加时调用
+ (void)upgradeTable;

+ (NSArray *)findAllItems;

+ (NSArray *)findItemsWithSqlWithParameters:(NSString *)sql, ...;

+ (NSArray *)findItemsWithSql:(NSString *)sql withParameters:(NSArray *)parameters;

+ (NSArray *)findItemsByColumn:(NSString *)column value:(id)value;

+ (NSArray *)findItemsByColumn:(NSString *)column unsignedIntegerValue:(NSUInteger)value;

+ (NSArray *)findItemsByColumn:(NSString *)column integerValue:(NSInteger)value;

+ (NSArray *)findItemsByColumn:(NSString *)column doubleValue:(double)value;

@end
