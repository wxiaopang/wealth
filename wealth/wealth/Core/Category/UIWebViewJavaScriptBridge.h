//
//  UIWebViewJavaScriptBridge.h
//  wealth
//
//  Created by wangyingjie on 15/4/2.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIWebViewJavaScriptBridge : NSObject
//routines is like this:[(r'^mkey://alarm/set.*$', 'set_alarm'), (r'mkey://alarm/cancle.*$', 'cancle_alarm')]
@property (nonatomic, strong) NSArray *routines;

- (instancetype)initWithHandler:(id)handler;
- (BOOL)canHandleRequest:(NSURLRequest *)request error:(NSError **)error;
- (BOOL)handleRequest:(NSURLRequest *)request error:(NSError **)error;

@end
