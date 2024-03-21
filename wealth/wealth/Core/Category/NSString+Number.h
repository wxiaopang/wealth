//
//  NSString+Number.h
//  wealth
//
//  Created by wangyingjie on 15/3/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Number)

- (NSString *)URLEncodedString;

- (NSDecimalNumber *)findNumFromStr;

- (NSUInteger)countWords;

- (NSString *)reverse;

- (NSString *)transformToPingYin;

- (BOOL)customContainsString:(NSString *)aString;

- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet;

- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet;

+ (BOOL)stringContainsEmoji:(NSString *)string;

@end
