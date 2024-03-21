//
//  NSNumber+NumberFormatter.m
//  wealth
//
//  Created by wangyingjie on 15/3/3.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "NSNumber+NumberFormatter.h"
#import <objc/runtime.h>

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
                                    @implementation TT_FIX_CATEGORY_BUG_##name @end

static NSNumberFormatter *_g_number_formatter_ = nil;

@implementation NSNumber (NumberFormatter)

+ (void)initialize {
    _g_number_formatter_ = [[NSNumberFormatter alloc] init];
    // 使用数学上的四舍五入算法 http://blog.csdn.net/alanzyy/article/details/8465098
    _g_number_formatter_.roundingMode = NSNumberFormatterRoundHalfUp;
    _g_number_formatter_.numberStyle = NSNumberFormatterNoStyle;
}

#pragma mark -Nonstatic

- (NSString *)doubleToStringWithFormat:(NSNumberFormat)format {
    NSString *formatStr = [self formatString:format];
    
    CGFloat factor = 1.0f;
    NSInteger count = (format == NSNumberFormatP3f) ? 3 : 2;
    for (NSInteger i = 0; i < count; i++) {
        factor = factor * 10.0f;
    }
    NSString *result = [NSString stringWithFormat:formatStr, round(self.doubleValue*factor)/factor];
    
    return result;
}


#pragma mark - Private methods

- (NSString *)formatString:(NSNumberFormat)format {
    switch (format) {
        case NSNumberFormatP2f:
            return @"%.2f";
        case NSNumberFormatP3f:
            return @"%.3f";
            
        default:
            return @"";
    }
}

- (NSString *)stringFormatterStyle:(NSNumberFormatterStyle)style {
    _g_number_formatter_.numberStyle = style;
    _g_number_formatter_.positiveFormat = nil;
    return [_g_number_formatter_ stringFromNumber:self];
}

- (NSString *)stringPercentFormatter {
    _g_number_formatter_.positiveFormat = @"#0.00%";
    return [_g_number_formatter_ stringFromNumber:self];
}

- (NSString *)stringCommonFormatter {
    _g_number_formatter_.positiveFormat = @"###,##0.00";
    return [_g_number_formatter_ stringFromNumber:self];
}

- (NSString *)stringCurrencyFormatter {
    _g_number_formatter_.positiveFormat = @"￥###,##0.00";
    return [_g_number_formatter_ stringFromNumber:self];
}

@end
