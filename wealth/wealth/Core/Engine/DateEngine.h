//
//  DateEngine.h
//  wealth
//
//  Created by wangyingjie on 15/2/4.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateEngine : NSObject

// YYYY-MM-DD 格式化
+ (NSString *)getYYYYMMDDString:(NSTimeInterval)timeInterval;

// YYYY-MM-DD HH:MM:SS 格式化
+ (NSString *)getYYYYMMDDHHMMSSString:(NSTimeInterval)timeInterval;

// YYYY-MM-DD HH:MM 格式化
+ (NSString *)getYYYYMMDDHHMMString:(NSTimeInterval)timeInterval;

// YYYY.MM.DD 格式化
+ (NSString *)getPointYYYYMMDDString:(NSTimeInterval)timeInterval;

// YYYY.MM.DD HH:MM:SS 格式化
+ (NSString *)getPointYYYYMMDDHHMMSSString:(NSTimeInterval)timeInterval;

// HH:MM:SS 格式化
+ (NSString *)getHHMMSSString:(NSTimeInterval)timeInterval;

// HH:MM 格式化
+ (NSString *)getHHMMString:(NSTimeInterval)timeInterval;

// 01-12 14:00 格式化
+ (NSString *)getMMDDHHMMString:(NSTimeInterval)timeInterval;

// YYYY年MM月DD日 格式化
+ (NSString *)getChinaYYYYMMDDString:(NSTimeInterval)timeInterval;

// YYYY年MM月 格式化
+ (NSString *)getChinaYYYYMMString:(NSTimeInterval)timeInterval;

//计算所给的时间是今天，昨天还是更早
+ (NSString *)getTimeDayString:(NSTimeInterval)timeInterval;

// "Wed, 23 Dec 2015 07:01:38 GMT" 转 NSDate
+ (NSDate *)convertFromString:(NSString *)string;

// 获取今天的时间
+ (NSString *)getTodayString;

// 计算时间差
+ (NSTimeInterval)timeDiff:(NSString *)begin end:(NSString *)end;

@end
