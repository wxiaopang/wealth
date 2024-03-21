//
//  AppDelegate.h
//  wealth
//
//  Created by wangyingjie on 16/3/14.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UMAnalyticsEngine *umAnalyticsEngine;

@property (nonatomic, assign) BOOL isShared;

@property (nonatomic, readonly) NSTimeInterval start_time;

@property (nonatomic, assign) NSInteger visitedPageNumber;

@property (nonatomic, strong) NSDate *systemDate;

- (NSTimeInterval)getSystemTime;

- (NSString *)getSystemTimeString;

- (void)logoutLog:(NSInteger)type;


@end

