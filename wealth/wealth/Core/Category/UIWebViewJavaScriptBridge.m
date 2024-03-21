//
//  UIWebViewJavaScriptBridge.m
//  wealth
//
//  Created by wangyingjie on 15/4/2.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UIWebViewJavaScriptBridge.h"

static NSString *const UIWebViewJavaScriptBridgeErrorDomain = @"UIWebViewJavaScriptBridgeErrorDomain";
const NSInteger UIWebViewJavaScriptBridgeErrorCode = 1;

@interface UIWebViewJavaScriptBridge ()

@property (nonatomic, weak) id handler;

@end

@implementation UIWebViewJavaScriptBridge

- (instancetype)initWithHandler:(id)handler {
    self = [super init];
    if (self) {
        self.handler = handler;
    }
    return self;
}

- (BOOL)canHandleRequest:(NSURLRequest *)request error:(NSError **)error
{
    NSInteger matchIndex = [self findMatchIndexOfURLScheme:request.URL.absoluteString error:error];
    if (matchIndex == NSNotFound) {
        if ( error ) {
            *error = [NSError errorWithDomain:UIWebViewJavaScriptBridgeErrorDomain
                                         code:UIWebViewJavaScriptBridgeErrorCode
                                     userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"can not match any of your url pattern", @"")}];
        }
    }
    return !(matchIndex == NSNotFound) ;
}

- (NSInteger)findMatchIndexOfURLScheme:(NSString *)url error:(NSError **)error
{
    NSPredicate *p = nil;
    NSInteger matchIndex = NSNotFound;
    for (NSUInteger i = 0; i < self.routines.count; i++) {
        if (![self.routines[i] isKindOfClass:[NSArray class]]) {
            if ( error ) {
                *error = [NSError errorWithDomain:UIWebViewJavaScriptBridgeErrorDomain
                                             code:UIWebViewJavaScriptBridgeErrorCode
                                         userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"element in routines is not NSArray", @"")}];
            }
            break;
        }
        NSArray *routinePair = self.routines[i];
        if (routinePair.count != 2) {
            if ( error ) {
                *error = [NSError errorWithDomain:UIWebViewJavaScriptBridgeErrorDomain
                                             code:UIWebViewJavaScriptBridgeErrorCode
                                         userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"element in routines should be NSArray that contains 2 items", @"")}];
            }
            break;
        }
        NSString *pattern = routinePair[0];
        p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        if ([p evaluateWithObject:url]) {
            matchIndex = i;
        }
    }
    return matchIndex;
}

- (NSString *)getQueryStringInURL:(NSString *)url
{
    NSURL *_url = [NSURL URLWithString:url];
    return _url.query;
}

- (NSDictionary *)dictionaryFromQueryString:(NSString *)queryString
{
    NSArray *urlComponents = [queryString componentsSeparatedByString:@"&"];
    if (urlComponents.count <= 0) {
        return nil;
    }
    NSMutableDictionary *queryDict = [NSMutableDictionary dictionary];
    for (NSString *keyValuePair in urlComponents) {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        if ([pairComponents[1] isKindOfClass:[NSString class]]) {
            [queryDict setObject:[pairComponents[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                          forKey:pairComponents[0]];
        } else {
            [queryDict setObject:pairComponents[1] forKey:pairComponents[0]];
        }
    }
    return [queryDict copy];
}

- (BOOL)handleRequest:(NSURLRequest *)request error:(NSError **)error
{
    NSString *url = request.URL.absoluteString;
    NSInteger matchIndex = [self findMatchIndexOfURLScheme:url error:error];
    NSDictionary *errorUserInfo = nil;
    if (matchIndex == NSNotFound) {
        errorUserInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"url pattern not found!", @"")};
        if ( error ) {
            *error = [NSError errorWithDomain:UIWebViewJavaScriptBridgeErrorDomain
                                         code:UIWebViewJavaScriptBridgeErrorCode
                                     userInfo:errorUserInfo];
        }
        NSLog(@"error:can not find one url that matches your url pattern");
        return NO;
    }
    NSString *handlerName = self.routines[matchIndex][1];
    if (!handlerName) {
        errorUserInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"handler of match url pattern is nil!", @"")};
        if ( error ) {
            *error = [NSError errorWithDomain:UIWebViewJavaScriptBridgeErrorDomain
                                         code:UIWebViewJavaScriptBridgeErrorCode
                                     userInfo:errorUserInfo];
        }
        NSLog(@"error:pass nil handler!");
        return NO;
    }
    NSString *queryString = [self getQueryStringInURL:url];
    NSDictionary *parameters = [self dictionaryFromQueryString:queryString];
    //selector signature should be: (void) methodName:(NSDictionary *)parameters
    SEL selector = nil;
    if ( parameters ) {
        selector = NSSelectorFromString([NSString stringWithFormat:@"%@:", handlerName]);
    } else {
        selector = NSSelectorFromString([NSString stringWithFormat:@"%@", handlerName]);
    }
    if (![self.handler respondsToSelector:selector]) {
        NSString *e = [NSString stringWithFormat:@"method:%@ of handler:%@ not define!", handlerName, NSStringFromClass([self.handler class])];
        errorUserInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(e, @"")};
        if ( error ) {
            *error = [NSError errorWithDomain:UIWebViewJavaScriptBridgeErrorDomain
                                         code:UIWebViewJavaScriptBridgeErrorCode
                                     userInfo:errorUserInfo];
        }
        return NO;
    }
    
    //the following will cause this warning:performSelector may cause a leak because its selector is unknown, solve it with:http://stackoverflow.com/a/20058585/544251
    //[self.handler performSelector:selector withObject:parameters];
    IMP imp = [self.handler methodForSelector:selector];
    void (*func)(id, SEL, NSDictionary *) = (void *)imp;
    func(self.handler, selector, parameters);
    return YES;
}

@end
