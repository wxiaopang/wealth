//
//  UncaughtExceptionHandler.m
//  wealth
//
//  Created by wangyingjie on 15/7/13.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

static NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
static NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
static NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;
const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

@interface UncaughtExceptionHandler ()

+ (NSArray *)backtrace;

- (void)handleException:(NSException *)exception;

@end

static NSString* getAppInfo() {
    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion];
    //                         [UIDevice currentDevice].uniqueIdentifier];
    NSLog(@"Crash!!!! %@", appInfo);
    return appInfo;
}


static void MySignalHandler(int signal) {
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:@(signal) forKey:UncaughtExceptionHandlerSignalKey];
    userInfo[UncaughtExceptionHandlerAddressesKey] = [UncaughtExceptionHandler backtrace];
    [[[UncaughtExceptionHandler alloc] init] performSelectorOnMainThread:@selector(handleException:)
                                                              withObject:[NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
                                                                                                 reason:[NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.\n" @"%@", nil), signal, getAppInfo()]
                                                                                               userInfo:@{ UncaughtExceptionHandlerSignalKey:@(signal) }]
                                                           waitUntilDone:YES];
}

@implementation UncaughtExceptionHandler

+ (void)installUncaughtExceptionHandler {
    signal(SIGABRT, MySignalHandler);
    signal(SIGILL, MySignalHandler);
    signal(SIGSEGV, MySignalHandler);
    signal(SIGFPE, MySignalHandler);
    signal(SIGBUS, MySignalHandler);
    signal(SIGPIPE, MySignalHandler);

    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandlers);
}

+ (NSArray *)backtrace {
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (NSInteger i = UncaughtExceptionHandlerSkipAddressCount;
         i < UncaughtExceptionHandlerSkipAddressCount + UncaughtExceptionHandlerReportAddressCount;
         i++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex {
    if (anIndex == 0) {
        _dismissed = YES;
    }
}

- (void)handleException:(NSException *)exception {
    // 记录异常退出日志
    AppDelegate *appDelegate = GET_APP_DELEGATE;
    [appDelegate logoutLog:2];

#ifdef DEBUG
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unhandled exception", nil)
                                                    message:[NSString stringWithFormat:NSLocalizedString(@"You can try to continue but the application may be unstable.\n"
                                                                                                         @"%@\n%@", nil), [exception reason],
                                                             [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Quit", nil)
                                          otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
    [alert show];
#endif

    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    while (!_dismissed) {
        for (NSString *mode in (__bridge NSArray *)allModes) {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    CFRelease(allModes);

    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
        kill(getpid(), [exception.userInfo[UncaughtExceptionHandlerSignalKey] intValue]);
    } else {
        [exception raise];
    }
}

void UncaughtExceptionHandlers (NSException *exception) {
    // 记录异常退出日志
    AppDelegate *appDelegate = GET_APP_DELEGATE;
    [appDelegate logoutLog:2];

    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *urlStr = [NSString stringWithFormat:@"mailto://wangyingjie@puhuifinance.com?subject=bug报告&body=感谢您的配合!<br><br><br>"
                        "错误详情:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@",
                        name, reason, [arr componentsJoinedByString:@"<br>"]];
    NSURL *url = [NSURL URLWithString:[urlStr URLEncodedString]];
    [[UIApplication sharedApplication] openURL:url];

    //或者直接用代码，输入这个崩溃信息，以便在console中进一步分析错误原因
    NSLog(@"wealth, CRASH: %@", exception);
    NSLog(@"wealth, Stack Trace: %@", [exception callStackSymbols]);
}

@end
