//
//  NSNumber+NumberFormatter.h
//  wealth
//
//  Created by wangyingjie on 15/3/3.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (NumberFormatter)

typedef NS_ENUM(NSUInteger, NSNumberFormat) {
    NSNumberFormatP2f,
    NSNumberFormatP3f,
};

- (NSString *)doubleToStringWithFormat:(NSNumberFormat)format;

/*
 NSNumberFormatterNoStyle               无格式
 NSNumberFormatterDecimalStyle          千分位格式化，如123,456,789
 NSNumberFormatterCurrencyStyle         货币千分位格式化（保留小数点后三位），如￥123,456,789.000
 NSNumberFormatterPercentStyle          百分比格式化（不保留小数点后），如90%
 NSNumberFormatterScientificStyle       科学计数法格式化
 NSNumberFormatterSpellOutStyle         单词计数
 */
- (NSString *)stringFormatterStyle:(NSNumberFormatterStyle)style;

// 百分比格式化,保留小数点后2位
- (NSString *)stringPercentFormatter;

// 千分分隔,保留小数点后2位
- (NSString *)stringCommonFormatter;

// 千分分隔,保留小数点后2位 带货币符号
- (NSString *)stringCurrencyFormatter;

@end
