//
//  PathEngine.h
//  wealth
//
//  Created by wangyingjie on 14/12/17.
//  Copyright (c) 2014年 puhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathEngine : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(PathEngine);

//获取应用程序路径
+ (NSString *)getApplicationPath;

//获取temp路径
+ (NSString *)getTempPath;

//获取获取document路径
+ (NSString *)getDocumentPath;

//获取cache缓存路径
+ (NSString *)getCachePath;

//获取资源文件
+ (NSString *)pathForResource:(NSString *)name ofType:(NSString *)type;

//创建路径
+ (BOOL)createPath:(NSString *)path;

//创建文件
+ (BOOL)createFile:(NSString *)fileName;

+ (BOOL)createFile:(NSString *)fileName path:(NSString *)path;

+ (BOOL)writeToFile:(NSData *)data fullName:(NSString *)fullName;

//删除文件
+ (BOOL)removeFile:(NSString *)fileName path:(NSString *)path;

//判断文件是否存在
+ (BOOL)isExistFile:(NSString *)filePath;

//判断文件是否完整
+ (BOOL)isFullFile:(NSString *)filePath size:(long long)size;

//获取文件大小
+ (unsigned long long)getFileSize:(NSString *)filePath;

@end
