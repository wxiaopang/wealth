//
//  UncaughtExceptionHandler.h
//  wealth
//
//  Created by wangyingjie on 15/7/13.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>

//利用 NSSetUncaughtExceptionHandler，当程序异常退出的时候，可以先进行处理，然后做一些自定义的动作，比如下面一段代码，就是网上有人写的，直接在发生异常时给某人发送邮件，</span>
void UncaughtExceptionHandlers(NSException *exception);

@interface UncaughtExceptionHandler : NSObject {
    BOOL _dismissed;
}

+ (void)installUncaughtExceptionHandler;

@end
