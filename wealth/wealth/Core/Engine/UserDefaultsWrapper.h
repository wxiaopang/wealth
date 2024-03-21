//
//  UserDefaultsWrapper.h
//  wealth
//
//  Created by wangyingjie on 14/12/17.
//  Copyright (c) 2014年 puhui. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DeviceTokenStringKEY            @"DeviceTokenStringKEY"
#define DeviceTokenRegisteredKEY        @"DeviceTokenRegisteredKEY"

#define kCheckVersion                   @"CheckVersion"

#define kRSAPublicKey                   @"RSAPublicKey"
#define kPublicToken                    @"PublicToken"

#define kFirstLaunchApp                 @"FirstLaunchApp"
#define kLonginUserid                   @"LonginUserid"
#define kAlertAuthorLocation            @"AlertAuthorLocation"

#define kComplianceClick                @"ComplianceClick"

@interface UserDefaultsWrapper : NSObject

+ (void)setUserDefaults:(NSDictionary *)dic;

+ (void)setUserDefaultsObject:(id)obj forKey:(NSString *)key;

+ (id)userDefaultsObject:(NSString *)key;

+ (void)removeUserDefaults:(NSString *)key;

// 通用plsit文件处理

+ (void)setDictionary:(NSDictionary *)dic forPlist:(NSString *)plist;

+ (NSDictionary *)getDictionary:(NSString *)plist;

+ (void)removeDictionary:(NSDictionary *)dic forPlist:(NSString *)plist;

// 归档

+ (void)archiver:(id)object forFile:(NSString *)fileName;

+ (id)unarchiver:(NSString *)fileName;

@end
