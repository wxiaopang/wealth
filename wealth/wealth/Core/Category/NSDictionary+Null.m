//
//  NSDictionary+Null.m
//  wealth
//
//  Created by wangyingjie on 15/1/14.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import "NSDictionary+Null.h"
#import <objc/runtime.h>

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_ ## name @end \
@implementation TT_FIX_CATEGORY_BUG_ ## name @end

@implementation NSDictionary (Null)

- (NSString *)stringForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [object isKindOfClass:[NSNull class]]) {
        return @"";
    }
    else if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        return [object stringValue];
    }
    return @"";
}

- (NSUInteger)hash {
    // Based upon standard hash algorithm ~ http://stackoverflow.com/a/4393493/337735
    NSUInteger result = 1;
    NSUInteger prime  = 31;
    // Fast enumeration has an unstable ordering, so explicitly sort the keys
    // http://stackoverflow.com/a/8529761/337735
    for (id key in [[self allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
        id value = [self objectForKey:key];
        // okay, so copying Java's hashCode a bit:
        // http://docs.oracle.com/javase/6/docs/api/java/util/Map.Entry.html#hashCode()
        result = prime * result + ([key hash] ^ [value hash]);
    }
    return result;
}

//- (NSString *)descriptionWithLocale:(id)locale {
//    NSString *desc = kNullStr;
//    @try {
//        desc = [self description];
//        desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding]
//                                  encoding:NSNonLossyASCIIStringEncoding];
//    } @catch (NSException *exception) {
//        NSLog(@"descriptionWithLocale = %@", exception);
//    } @finally {
//        return desc;
//    }
//}

@end
