//
//  NSObject+DTDebug.m
//  wealth
//
//  Created by wangyingjie on 15/12/18.
//  Copyright © 2015年 普惠金融. All rights reserved.
//

#import "NSObject+DTDebug.h"

@implementation NSObject (DTDebug)

+ (void)replaceClassMethodWithClass:(Class)clazz
                       originMethod:(SEL)originMethodSEL
                         withMethod:(SEL)newMethodSEL {
    Method originMethod = class_getInstanceMethod(clazz, originMethodSEL);
    Method newMethod = class_getInstanceMethod(clazz, newMethodSEL);
    method_exchangeImplementations(originMethod, newMethod);
}

@end

@implementation NSString (DTDebug)

//http://stackoverflow.com/questions/2099349/using-objective-c-cocoa-to-unescape-unicode-characters-ie-u1234?lq=1
+ (NSString*) stringByReplaceUnicode:(NSString*)string {
    // unescape quotes and backwards slash
    NSString* unescapedString = [string stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    unescapedString = [unescapedString stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];

    // tokenize based on unicode escape char
    NSMutableString* tokenizedString = [NSMutableString string];
    NSScanner* scanner = [NSScanner scannerWithString:unescapedString];
    while ([scanner isAtEnd] == NO)
    {
        // read up to the first unicode marker
        // if a string has been scanned, it's a token
        // and should be appended to the tokenized string
        NSString* token = @"";
        [scanner scanUpToString:@"\\u" intoString:&token];
        if (token != nil && token.length > 0)
        {
            [tokenizedString appendString:token];
            continue;
        }
        // skip two characters to get past the marker
        // check if the range of unicode characters is
        // beyond the end of the string (could be malformed)
        // and if it is, move the scanner to the end
        // and skip this token
        NSUInteger location = [scanner scanLocation];
        NSInteger extra = scanner.string.length - location - 4 - 2;
        if (extra < 0)
        {
            NSRange range = {location, -extra};
            [tokenizedString appendString:[scanner.string substringWithRange:range]];
            [scanner setScanLocation:location - extra];
            continue;
        }
        // move the location pas the unicode marker
        // then read in the next 4 characters
        location += 2;
        NSRange range = {location, 4};
        token = [scanner.string substringWithRange:range];
        unichar codeValue = (unichar) strtol([token UTF8String], NULL, 16);
        [tokenizedString appendString:[NSString stringWithFormat:@"%C", codeValue]];
        // move the scanner past the 4 characters
        // then keep scanning
        location += 4;
        [scanner setScanLocation:location];
    }
    // done
    return tokenizedString;
}

@end

@implementation NSDictionary (DEBUGING)

+ (void)load {
    [self replaceClassMethodWithClass:[NSDictionary class] originMethod:@selector(description) withMethod:@selector(Exchangeddescription)];
    [self replaceClassMethodWithClass:[NSDictionary class] originMethod:@selector(descriptionWithLocale:) withMethod:@selector(ExchangeddescriptionWithLocale:)];
    [self replaceClassMethodWithClass:[NSDictionary class] originMethod:@selector(descriptionWithLocale:indent:) withMethod:@selector(ExchangeddescriptionWithLocale:indent:)];
}

- (NSString *)Exchangeddescription {
    NSString * description = [self Exchangeddescription];
    description = [NSString stringByReplaceUnicode:description];
    return description;
}

- (NSString *)ExchangeddescriptionWithLocale:(id)locale {
    NSString * description = [self ExchangeddescriptionWithLocale:locale];
    description = [NSString stringByReplaceUnicode:description];
    return description;
}

- (NSString *)ExchangeddescriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSString * description = [self ExchangeddescriptionWithLocale:locale indent:level];
    description = [NSString stringByReplaceUnicode:description];
    return description;
}

@end

@implementation NSArray (DTDebug)

+ (void)load {
    [self replaceClassMethodWithClass:[NSArray class] originMethod:@selector(description) withMethod:@selector(Exchangeddescription)];
    [self replaceClassMethodWithClass:[NSArray class] originMethod:@selector(descriptionWithLocale:) withMethod:@selector(ExchangeddescriptionWithLocale:)];
    [self replaceClassMethodWithClass:[NSArray class] originMethod:@selector(descriptionWithLocale:indent:) withMethod:@selector(ExchangeddescriptionWithLocale:indent:)];
}

- (NSString *)Exchangeddescription {
    NSString * description = [self Exchangeddescription];
    description = [NSString stringByReplaceUnicode:description];
    return description;
}

- (NSString *)ExchangeddescriptionWithLocale:(id)locale {
    NSString * description = [self ExchangeddescriptionWithLocale:locale];
    description = [NSString stringByReplaceUnicode:description];
    return description;
}

- (NSString *)ExchangeddescriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSString * description = [self ExchangeddescriptionWithLocale:locale indent:level];
    description = [NSString stringByReplaceUnicode:description];
    return description;
}

@end

@implementation NSSet (DTDebug)

+ (void)load {
    [self replaceClassMethodWithClass:[NSSet class] originMethod:@selector(description) withMethod:@selector(Exchangeddescription)];
    [self replaceClassMethodWithClass:[NSSet class] originMethod:@selector(descriptionWithLocale:) withMethod:@selector(ExchangeddescriptionWithLocale:)];
}

- (NSString *)Exchangeddescription {
    NSString * description = [self Exchangeddescription];
    description = [NSString stringByReplaceUnicode:description];
    return description;
}

- (NSString *)ExchangeddescriptionWithLocale:(id)locale {
    NSString * description = [self ExchangeddescriptionWithLocale:locale];
    description = [NSString stringByReplaceUnicode:description];
    return description;
}

@end

