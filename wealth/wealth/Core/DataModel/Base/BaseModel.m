//
//  BaseModel.m
//  wealth
//
//  Created by wangyingjie on 14/12/16.
//  Copyright (c) 2014年 puhui. All rights reserved.
//

#import "BaseModel.h"
#import "wealthDataBase.h"

#define __database__ ((wealthDataBase *)[[self class] database])

@interface BaseModel ()

@end

@implementation BaseModel

+ (wealthDataBase *)wealthDataBase {
    return __database__;
}

- (instancetype)init {
    self = [super init];
    if ( self ) {
        unsigned int count;
        objc_property_t* props = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i++) {
            objc_property_t property = props[i];
            const char *property_type = property_getAttributes(property);
            if ( '@' == property_type[1] ) {
                const char *property_name = property_getName(property);
                NSString *propertyName = [NSString stringWithCString:property_name encoding:NSUTF8StringEncoding];
                NSString *typeString = [NSString stringWithUTF8String:property_type];
                NSArray *attributes = [typeString componentsSeparatedByString:@","];
                NSString *typeAttribute = [attributes objectAtIndex:0];
                NSString *typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length] - 4)];
                if ( [typeClassName isEqualToString:NSStringFromClass([NSString class])] ) {
                    [self setValue:kNullStr forKey:propertyName];
                } else if ( [typeClassName isEqualToString:NSStringFromClass([NSNumber class])] ) {
                    [self setValue:@(0) forKey:propertyName];
                }
            }
        }
        free(props);
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [self init];
    if ( self ) {
        if ( dic && [dic isKindOfClass:[NSDictionary class]] ) {
            NSArray *propertyNames = [self getPropertyNamesArray];
            [propertyNames enumerateObjectsUsingBlock:^(NSString *property, NSUInteger idx, BOOL *stop1) {
//TODO: 暂时处理  遇到空串过滤
                [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop2) {
                    if ( [key isEqualToString:property] ) {
                        [self setValue:obj forKey:property];
                        *stop2 = YES;
                    }
                }];
            }];
        }
    }
    return self;
}

- (NSArray *)getPropertyNamesArray {
    NSMutableArray *propertyNamesArray = [NSMutableArray array];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(self.class, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNamesArray addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    return propertyNamesArray;
}

- (void)mergerModel:(BaseModel *)model {
    NSArray *propertyNames = [self getPropertyNamesArray];
    [propertyNames enumerateObjectsUsingBlock:^(NSString *property, NSUInteger idx, BOOL *stop) {
        id value = [model valueForKey:property];
        if ( value ) {
            [self setValue:value forKey:property];
        }
    }];
}

- (void)forceMergerModel:(BaseModel *)model {
    NSArray *propertyNames = [self getPropertyNamesArray];
    [propertyNames enumerateObjectsUsingBlock:^(NSString *property, NSUInteger idx, BOOL *stop) {
        id value = [model valueForKey:property];
        if ( value ) {
            [self setValue:value forKey:property];
        }
    }];
}

- (void)save {
    [self saveWithComplete:nil];
}

- (void)saveWithComplete:(dispatch_block_t)complete {
    dispatch_barrier_async(__database__.dataBaseQueue.dispatchQueue, ^{
        [super save];

        if ( complete ) {
            dispatch_barrier_sync(dispatch_get_main_queue(), complete);
        }
    });
}

- (void)deleteSelf {
    [self deleteSelfComplete:nil];
}

- (void)deleteSelfComplete:(dispatch_block_t)complete {
    dispatch_barrier_async(__database__.dataBaseQueue.dispatchQueue, ^{
        [super deleteSelf];
        
        if ( complete ) {
            dispatch_barrier_sync(dispatch_get_main_queue(), complete);
        }
    });
}

- (void)beforeSave {
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(self.class, &propertyCount);
    objc_property_t property = properties[0];
    const char *name = property_getName(property);
    NSString *propertyName = [NSString stringWithUTF8String:name];
    id propertyValue = [self valueForKey:propertyName];
    free(properties);
    NSArray *ret = [[self class] findWithSql:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",
                                                   NSStringFromClass([self class]), propertyName]
                              withParameters:@[ propertyValue ]];
    self.primaryKey = [ret.firstObject primaryKey];
    self.savedInDatabase = ret.count > 0;
}

+ (void)upgradeTable {
    NSArray *data = [self findAll];
    [__database__ executeSql:[NSString stringWithFormat:@"DROP TABLE %@", NSStringFromClass([self class])]];
    [data setValue:[NSNumber numberWithBool:NO] forKey:@"savedInDatabase"];
    [data makeObjectsPerformSelector:@selector(save)];
}

+ (NSArray *)findAllItems {
    __block NSArray *ret = nil;
    dispatch_sync(__database__.dataBaseQueue.dispatchQueue, ^{
        ret = [[self class] findAll];
    });
    return ret;
}

+ (NSArray *)findItemsWithSqlWithParameters:(NSString *)sql, ... {
    __block NSArray *ret = nil;
    dispatch_sync(__database__.dataBaseQueue.dispatchQueue, ^{
        ret = [[self class] findWithSql:sql];
    });
    return ret;
}

+ (NSArray *)findItemsWithSql:(NSString *)sql withParameters:(NSArray *)parameters {
    __block NSArray *ret = nil;
    dispatch_sync(__database__.dataBaseQueue.dispatchQueue, ^{
        ret = [[self class] findWithSql:sql withParameters:parameters];
    });
    return ret;
}

+ (NSArray *)findItemsByColumn:(NSString *)column value:(id)value {
    __block NSArray *ret = nil;
    dispatch_sync(__database__.dataBaseQueue.dispatchQueue, ^{
        ret = [[self class] findByColumn:column value:value];
    });
    return ret;
}

+ (NSArray *)findItemsByColumn:(NSString *)column unsignedIntegerValue:(NSUInteger)value {
    __block NSArray *ret = nil;
    dispatch_sync(__database__.dataBaseQueue.dispatchQueue, ^{
        ret = [[self class] findByColumn:column unsignedIntegerValue:value];
    });
    return ret;
}

+ (NSArray *)findItemsByColumn:(NSString *)column integerValue:(NSInteger)value {
    __block NSArray *ret = nil;
    dispatch_sync(__database__.dataBaseQueue.dispatchQueue, ^{
        ret = [[self class] findByColumn:column integerValue:value];
    });
    return ret;
}

+ (NSArray *)findItemsByColumn:(NSString *)column doubleValue:(double)value {
    __block NSArray *ret = nil;
    dispatch_sync(__database__.dataBaseQueue.dispatchQueue, ^{
        ret = [[self class] findByColumn:column doubleValue:value];
    });
    return ret;
}

@end
