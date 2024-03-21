//
//  NSString+Number.m
//  wealth
//
//  Created by wangyingjie on 15/3/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "NSString+Number.h"

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
                                    @implementation TT_FIX_CATEGORY_BUG_##name @end

@implementation NSString (Number)

- (NSString *)URLEncodedString {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
}

- (NSNumber *)findNumFromStr {
    if ( self.length > 0 ) {
        NSMutableString *numberString = [[NSMutableString alloc] initWithCapacity:0];
        NSString *tempStr = @"";
        NSScanner *scanner = [NSScanner scannerWithString:self];
        NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        
        while (![scanner isAtEnd]) {
            // Throw away characters before the first number.
            [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
            
            // Collect numbers.
            [scanner scanCharactersFromSet:numbers intoString:&tempStr];
            [numberString appendString:tempStr];
            tempStr = @"";
        }
        NSDecimalNumber *result = [[NSDecimalNumber alloc] initWithString:numberString];
        return (isnan([result doubleValue]) ? nil : result);
    } else {
        return nil;
    }
}

- (NSUInteger)countWords {
    __block NSUInteger wordCount = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByWords
                          usingBlock:^(NSString *character, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              wordCount++;
                          }];
    return wordCount;
}

- (NSString *)reverse {
    NSInteger length = [self length];
    unichar *buffer = calloc(length, sizeof(unichar));
    
    // TODO(gabe): Apparently getCharacters: is really slow
    [self getCharacters:buffer range:NSMakeRange(0, length)];
    
    for(int i = 0, mid = ceil(length/2.0); i < mid; i++) {
        unichar c = buffer[i];
        buffer[i] = buffer[length-i-1];
        buffer[length-i-1] = c;
    }
    
    NSString *s = [[NSString alloc] initWithCharacters:buffer length:length];
    if ( buffer ) {
        free(buffer);
    }
    return s;
}

- (NSString *)transformToPingYin {
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, (__bridge_retained CFStringRef)self);
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    return [(__bridge_transfer NSString *)string stringByReplacingOccurrencesOfString:@" " withString:kNullStr];
}

- (BOOL)customContainsString:(NSString *)aString {
    if ( [self respondsToSelector:@selector(containsString:)] ) {
        return [self containsString:aString];
    } else {
        return [self rangeOfString:aString].length > 0;
    }
}

- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet {
    NSInteger location = 0;
    NSInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    for (location = 0; location < length; location++) {
        if (![characterSet characterIsMember:charBuffer[location]]) {
            break;
        }
    }
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet {
    NSInteger location = 0;
    NSInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    for (length = 0; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

//是否含有表情
+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    return returnValue;
}

@end
