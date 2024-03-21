//
//  NSString+Base.h
//  iqianjin
//
//  Created by jiangyu on 15/7/26.
//  Copyright (c) 2015年 iqianjin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base)

//固定宽度,自适应高度
- (CGSize)getSizeWithFont:(UIFont *)font width:(CGFloat)width;

- (CGSize)getSizeWithFont:(UIFont *)font width:(CGFloat)width withParagraph:(NSMutableParagraphStyle *)paragraphStyle;
//可设置行间距
- (CGSize)getSizeWithFont:(UIFont *)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;
//可设置行间距
- (CGSize)getSizeWithFont:(UIFont *)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing withParagraph:(NSMutableParagraphStyle *)paragraphStyle;

//固定高度,自适应宽度
- (CGSize)getSizeWithFont:(UIFont *)font height:(CGFloat)height;

- (CGSize)getSizeWithFont:(UIFont *)font height:(CGFloat)height withParagraph:(NSMutableParagraphStyle *)paragraphStyle;

//自定义size
- (CGSize)getSizeWithFont:(UIFont *)font size:(CGSize)size;

- (CGSize)getSizeWithFont:(UIFont *)font size:(CGSize)size withParagraph:(NSMutableParagraphStyle *)paragraphStyle;

//获取属性文本-无单位的
- (NSAttributedString *)getAttributedStringWithFont:(UIFont *)font
                                          textColor:(UIColor *)textColor
                                      textLineStyle:(NSUnderlineStyle)textLineStyle;

//获取属性文本-加单位的
- (NSAttributedString *)getAttributedStringWithFont:(UIFont *)font
                                          textColor:(UIColor *)textColor
                                      textLineStyle:(NSUnderlineStyle)textLineStyle
                                           unitText:(NSString *)unitText
                                           unitFont:(UIFont *)unitFont
                                          unitColor:(UIColor *)unitColor
                                      unitLineStyle:(NSUnderlineStyle)unitLineStyle;


//获我的红包30个 红色数字
- (NSAttributedString *)getAttributedStringWithFont:(UIFont *)font
                                           normalTextColor:(UIColor *)textColor
                                                     range:(NSRange)fontRange
                                            otherTextColor:(UIColor *)otherTextColor
                                                colorRange:(NSRange)colorFontRange;

+ (BOOL)isAvailableString:(NSString *)string;
+ (NSString *)getAvailableString:(NSString *)string;

//转换格式化后的金额string转化为double
- (double)getDouble;
- (NSURL *)getUrl;

//数值转换成货币格式字符串，带小数点，sign为是否带有单位
+ (NSString*) getStringFromNumber:(double)num point:(BOOL)point sign:(BOOL)sign;

@end
