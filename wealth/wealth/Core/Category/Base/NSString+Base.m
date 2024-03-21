//
//  NSString+Base.m
//  iqianjin
//
//  Created by jiangyu on 15/7/26.
//  Copyright (c) 2015年 iqianjin. All rights reserved.
//

#import "NSString+Base.h"

@implementation NSString (Base)

- (CGSize)getSizeWithFont:(UIFont *)font width:(CGFloat)width {
    return [self getSizeWithFont:font width:width lineSpacing:0];
}

- (CGSize)getSizeWithFont:(UIFont *)font width:(CGFloat)width withParagraph:(NSMutableParagraphStyle *)paragraphStyle {
    return [self getSizeWithFont:font width:width lineSpacing:0 withParagraph:paragraphStyle];
}

//可设置行间距
- (CGSize)getSizeWithFont:(UIFont *)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.lineSpacing = lineSpacing;
    CGSize textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                      attributes:@{NSFontAttributeName : font,
                                                   NSParagraphStyleAttributeName:paragraphStyle}
                                         context:nil].size;
    return textSize;
}

//可设置行间距
- (CGSize)getSizeWithFont:(UIFont *)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing withParagraph:(NSMutableParagraphStyle *)paragraphStyle {
    if (!paragraphStyle) {
        return [self getSizeWithFont:font width:width];
    } else {
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.lineSpacing = lineSpacing;
        CGSize textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                             options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                          attributes:@{NSFontAttributeName : font,
                                                       NSParagraphStyleAttributeName:paragraphStyle}
                                             context:nil].size;
        return textSize;
    }
    return CGSizeZero;
}

- (CGSize)getSizeWithFont:(UIFont *)font height:(CGFloat)height {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize textSize = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                      attributes:@{NSFontAttributeName : font,
                                                   NSParagraphStyleAttributeName:paragraphStyle}
                                         context:nil].size;
    return textSize;
}

- (CGSize)getSizeWithFont:(UIFont *)font height:(CGFloat)height withParagraph:(NSMutableParagraphStyle *)paragraphStyle {
    if (!paragraphStyle) {
        return [self getSizeWithFont:font height:height];
    } else {
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        CGSize textSize = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                             options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                          attributes:@{NSFontAttributeName : font,
                                                       NSParagraphStyleAttributeName:paragraphStyle}
                                             context:nil].size;
        return textSize;
    }
    return CGSizeZero;
}

- (CGSize)getSizeWithFont:(UIFont *)font size:(CGSize)size {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize textSize = [self boundingRectWithSize:size
                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                      attributes:@{NSFontAttributeName : font,
                                                   NSParagraphStyleAttributeName:paragraphStyle}
                                         context:nil].size;
    return textSize;
}

- (CGSize)getSizeWithFont:(UIFont *)font size:(CGSize)size withParagraph:(NSMutableParagraphStyle *)paragraphStyle {
    if (!paragraphStyle) {
        return [self getSizeWithFont:font size:size];
    } else {
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        CGSize textSize = [self boundingRectWithSize:size
                                             options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                          attributes:@{NSFontAttributeName : font,
                                                       NSParagraphStyleAttributeName:paragraphStyle}
                                             context:nil].size;
        return textSize;
    }
    return CGSizeZero;
}

//获取属性文本-无单位的
- (NSAttributedString *)getAttributedStringWithFont:(UIFont *)font
                                          textColor:(UIColor *)textColor
                                      textLineStyle:(NSUnderlineStyle)textLineStyle {
    NSMutableAttributedString *resultText = [self getAttributedStringWithFont:font
                                                                    fontRange:NSMakeRange(0, self.length)
                                                                    textColor:textColor
                                                                   colorRange:NSMakeRange(0, self.length)
                                                               underlineStyle:textLineStyle
                                                               underlineRange:NSMakeRange(0, self.length)];
    return resultText;
}

//获取属性文本-加单位的
- (NSAttributedString *)getAttributedStringWithFont:(UIFont *)font
                                          textColor:(UIColor *)textColor
                                      textLineStyle:(NSUnderlineStyle)textLineStyle
                                           unitText:(NSString *)unitText
                                           unitFont:(UIFont *)unitFont
                                          unitColor:(UIColor *)unitColor
                                      unitLineStyle:(NSUnderlineStyle)unitLineStyle {
    NSMutableAttributedString *resultText = [self getAttributedStringWithFont:font
                                                                    fontRange:NSMakeRange(0, self.length)
                                                                    textColor:textColor
                                                                   colorRange:NSMakeRange(0, self.length)
                                                               underlineStyle:textLineStyle
                                                               underlineRange:NSMakeRange(0, self.length)];
    if (unitText && unitText.length > 0) {
        NSMutableAttributedString *unitString = [unitText getAttributedStringWithFont:unitFont
                                                                            fontRange:NSMakeRange(0, unitText.length)
                                                                            textColor:unitColor
                                                                           colorRange:NSMakeRange(0, unitText.length)
                                                                       underlineStyle:unitLineStyle
                                                                       underlineRange:NSMakeRange(0, self.length)];
        [resultText appendAttributedString:unitString];
    }
    return resultText;
}

//获取基本属性文本
- (NSMutableAttributedString *)getAttributedStringWithFont:(UIFont *)font
                                                 fontRange:(NSRange)fontRange
                                                 textColor:(UIColor *)textColor
                                                colorRange:(NSRange)colorRange
                                            underlineStyle:(NSUnderlineStyle)underlineStyle
                                            underlineRange:(NSRange)underlineRange {
    NSMutableAttributedString *resultText = [[NSMutableAttributedString alloc] initWithString:self];
    if (underlineStyle != NSUnderlineStyleNone) {
        [resultText addAttribute:NSUnderlineStyleAttributeName value:@(underlineStyle) range:underlineRange];
    }
    if (font) {
        [resultText addAttribute:NSFontAttributeName value:font range:fontRange];
    }
    if (textColor) {
        [resultText addAttribute:NSForegroundColorAttributeName value:textColor range:colorRange];
    }
    return resultText;
}


//获我的红包30个 红色数字
- (NSAttributedString *)getAttributedStringWithFont:(UIFont *)font
                                   normalTextColor:(UIColor *)textColor
                                             range:(NSRange)fontRange
                                    otherTextColor:(UIColor *)otherTextColor
                                        colorRange:(NSRange)colorFontRange {
    NSMutableAttributedString *resultText = [[NSMutableAttributedString alloc] initWithString:self];
    if (font) {
        [resultText addAttribute:NSFontAttributeName value:font range:fontRange];
    }
    if (textColor) {
        [resultText addAttribute:NSForegroundColorAttributeName value:textColor range:fontRange];
    }
    if (otherTextColor) {
        [resultText addAttribute:NSForegroundColorAttributeName value:otherTextColor range:colorFontRange];
    }
    return resultText;
}

+ (BOOL)isAvailableString:(NSString *)string {
    if (string && string.length > 0) {
        return YES;
    }
    return NO;
}

+ (NSString *)getAvailableString:(NSString *)string {
    return [NSString isAvailableString:string] ? string : @"";
}

//转换格式化后的金额string转化为double
- (double)getDouble {
    if (self && self.length > 0) {
        NSMutableString *resultString = [NSMutableString stringWithCapacity:1];
        for (int i = 0; i < self.length; i ++) {
            char character = [self characterAtIndex:i];
            if (character == 46 || (character >= 48 && character <= 57 )) {
                [resultString appendString:[NSString stringWithFormat:@"%c",character]];
            }
        }
        return [resultString doubleValue];
    }
    else {
        return 0.00;
    }
}

//将string 转 URL
- (NSURL *)getUrl {
    return [NSURL URLWithString:[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString*) getStringFromNumber:(double)num point:(BOOL)point sign:(BOOL)sign {
    NSArray * array = [[NSString stringWithFormat:@"%.2f",num] componentsSeparatedByString:@"."];
    NSUInteger len = [array[0] length];
    NSUInteger x = len%3;
    NSUInteger y = len/3;
    NSUInteger dotNumber = y;
    
    if (x == 0) {
        dotNumber -= 1;
        x = 3;
    }
    NSMutableString * rs = [@"" mutableCopy];
    [rs appendString:[array[0] substringWithRange:NSMakeRange(0, x)]];
    
    for (NSInteger i=0; i<dotNumber; i++) {
        [rs appendString:@","];
        [rs appendString:[array[0] substringWithRange:NSMakeRange(x + i*3, 3)]];
    }
    //小数点
    if (point) {
        [rs appendString:@"."];
        [rs appendString:array[1]];
    }
    
    if (sign) {
        [rs appendString:@"元"];
    }
    return rs;
}



@end
