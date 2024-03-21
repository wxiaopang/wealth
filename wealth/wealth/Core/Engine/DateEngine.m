//
//  DateEngine.m
//  wealth
//
//  Created by wangyingjie on 15/2/4.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import "DateEngine.h"

static NSDateFormatter *_g_YYYYMMDD_formatter_ = nil;
static NSDateFormatter *_g_YYYYMMDDHHMMSS_formatter_ = nil;
static NSDateFormatter *_g_YYYYMMDDHHMM_formatter_ = nil;

static NSDateFormatter *_g_Point_YYYYMMDD_formatter_ = nil;
static NSDateFormatter *_g_Point_YYYYMMDDHHMMSS_formatter_ = nil;

static NSDateFormatter *_g_HHMMSS_formatter_ = nil;
static NSDateFormatter *_g_HHMM_formatter_ = nil;
static NSDateFormatter *_g_HH_formatter_ = nil;

static NSDateFormatter *_g_MMDDHHMM_formatter_ = nil;

static NSDateFormatter *_g_China_YYYYMMDD_formatter_ = nil;
static NSDateFormatter *_g_China_YYYYMM_formatter_ = nil;

#define GetDateString(dateFormatter, timeInterval) ((timeInterval) != 0) \
                                                        ? [(dateFormatter) stringFromDate:[NSDate dateWithTimeIntervalSince1970:(timeInterval)]] \
                                                        : @"--";

@implementation DateEngine

+ (void)initialize {
    // 自动获取当前设备时区
    NSCalendar *alendar = [NSCalendar autoupdatingCurrentCalendar];
    
    // YYYY-MM-DD 格式化
    _g_YYYYMMDD_formatter_ = [DateEngine createDateFormatter:@"yyyy-MM-dd" calendar:alendar];
    
    // YYYY-MM-DD HH:MM:SS 格式化
    _g_YYYYMMDDHHMMSS_formatter_ = [DateEngine createDateFormatter:@"yyyy-MM-dd HH:mm:ss" calendar:alendar];
    
    // YYYY-MM-DD HH:MM 格式化
    _g_YYYYMMDDHHMM_formatter_ = [DateEngine createDateFormatter:@"yyyy-MM-dd HH:mm" calendar:alendar];
    
    // YYYY.MM.DD 格式化
    _g_Point_YYYYMMDD_formatter_ = [DateEngine createDateFormatter:@"yyyy.MM.dd" calendar:alendar];
    
    // YYYY.MM.DD HH:MM:SS 格式化
    _g_Point_YYYYMMDDHHMMSS_formatter_ = [DateEngine createDateFormatter:@"yyyy.MM.dd HH:mm:ss" calendar:alendar];
    
    // HH:MM:SS 格式化
    _g_HHMMSS_formatter_ = [DateEngine createDateFormatter:@"HH:mm:ss" calendar:alendar];
    
    // HH:MM 格式化
    _g_HHMM_formatter_ = [DateEngine createDateFormatter:@"HH:mm" calendar:alendar];
    
    // HH 格式化
    _g_HH_formatter_ = [DateEngine createDateFormatter:@"HH" calendar:alendar];
    
    // 01-12 14:00 格式化
    _g_MMDDHHMM_formatter_ = [DateEngine createDateFormatter:@"MM-dd HH:mm" calendar:alendar];
    
    // YYYY年MM月DD日 格式化
    _g_China_YYYYMMDD_formatter_ = [DateEngine createDateFormatter:@"yyyy年MM月dd日" calendar:alendar];
    
    // YYYY年MM月 格式化
    _g_China_YYYYMM_formatter_ = [DateEngine createDateFormatter:@"yyyy年MM月" calendar:alendar];
}

+ (NSDateFormatter *)createDateFormatter:(NSString *)formatter calendar:(NSCalendar *)calendar {
    NSDateFormatter *ret = [[NSDateFormatter alloc] init];
    ret.dateFormat = formatter;
    ret.calendar = calendar;
    return ret;
}

+ (NSString *)getYYYYMMDDString:(NSTimeInterval)timeInterval {
    return GetDateString(_g_YYYYMMDD_formatter_, timeInterval);
}

+ (NSString *)getYYYYMMDDHHMMSSString:(NSTimeInterval)timeInterval {
    return GetDateString(_g_YYYYMMDDHHMMSS_formatter_, timeInterval);
}

+ (NSString *)getYYYYMMDDHHMMString:(NSTimeInterval)timeInterval {
    return GetDateString(_g_YYYYMMDDHHMM_formatter_, timeInterval);
}

+ (NSString *)getPointYYYYMMDDString:(NSTimeInterval)timeInterval {
    return GetDateString(_g_Point_YYYYMMDD_formatter_, timeInterval);
}

+ (NSString *)getPointYYYYMMDDHHMMSSString:(NSTimeInterval)timeInterval {
    return GetDateString(_g_Point_YYYYMMDDHHMMSS_formatter_, timeInterval);
}

+ (NSString *)getHHMMSSString:(NSTimeInterval)timeInterval {
    return GetDateString(_g_HHMMSS_formatter_, timeInterval);
}

+ (NSString *)getHHMMString:(NSTimeInterval)timeInterval {
    return GetDateString(_g_HHMM_formatter_, timeInterval);
}

+ (NSString *)getMMDDHHMMString:(NSTimeInterval)timeInterval {
    return GetDateString(_g_MMDDHHMM_formatter_, timeInterval);
}

+ (NSString *)getChinaYYYYMMDDString:(NSTimeInterval)timeInterval {
    NSString *resultDate = kNullStr;
    if (timeInterval > 0) {
        resultDate = GetDateString(_g_China_YYYYMMDD_formatter_, timeInterval);
    }
    return resultDate;
}

+ (NSString *)getChinaYYYYMMString:(NSTimeInterval)timeInterval {
    NSString *resultDate = kNullStr;
    if (timeInterval > 0) {
        resultDate = GetDateString(_g_China_YYYYMM_formatter_, timeInterval);
    }
    return resultDate;
}

+ (NSString *)getTimeDayString:(NSTimeInterval)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    if (date == nil)
        return @"";
    
    NSMutableString *displayStr = [NSMutableString string];
    NSDate *now = [NSDate date];
    NSTimeInterval time = [now timeIntervalSinceDate:date];
    
    int nowHour = [[_g_HH_formatter_ stringFromDate:now] intValue];
    int days_ago = ((int)time + 3600*(24-nowHour))/(3600*24);
    
    if (days_ago == 0) {
        [displayStr appendString:@"今天"];
    } else if(days_ago == 1) {
        [displayStr appendString:@"昨天"];
    } else if(days_ago > 1) {
        [displayStr appendString:@"更早"];
    }
    return displayStr;
}

+ (NSDate *)convertFromString:(NSString *)string {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";
    df.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
    df.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    df.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDate *date = [df dateFromString:string];
    NSInteger interval = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:date];
    return [date dateByAddingTimeInterval:interval];
}

+ (NSString *)getTodayString {
    return [_g_YYYYMMDDHHMMSS_formatter_ stringFromDate:[NSDate date]];
}

+ (NSTimeInterval)timeDiff:(NSString *)begin end:(NSString *)end {
    NSDate *bt = [_g_YYYYMMDDHHMMSS_formatter_ dateFromString:begin];
    NSDate *et = [_g_YYYYMMDDHHMMSS_formatter_ dateFromString:end];
    return fabs([et timeIntervalSince1970] - [bt timeIntervalSince1970]);
}

@end
