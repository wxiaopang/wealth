//
//  UITimerLable.h
//  wealth
//
//  Created by wangyingjie on 15/2/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFALUT_TIMEOUT_SECOND    60

@class UITimerLable;

@protocol TimerLableDelegate <NSObject>

@optional

- (void)timeOut:(UITimerLable *)lable;

@end

/*
    计时器lable
 */
@interface UITimerLable : UILabel

@property (nonatomic, strong) NSString *stringFormat;
@property (nonatomic, weak) id<TimerLableDelegate> delegate;
@property (nonatomic, readonly) BOOL valid;

/**
 Initializes and returns a newly allocated UILabel object with a timer configured with the specified number of seconds.
 @param frame    The fram of the UILabel.
 @param string   The format string text of the UILabel, `%@` to define where to place the timer.
 @param seconds  The number of seconds of the timer.
 @param delegate The delegate that will receive callbacks when time out.
 @since 0.0.1
 */
- (instancetype)initWithFrame:(CGRect)frame
                       format:(NSString *)string
                         time:(int)seconds
                     delegate:(id <TimerLableDelegate>)delegate;

/**
 Restart the timer.
 */
- (void)restart;

/**
 Cancel the timer setting the countdown to 0.
 */
- (void)cancel;

/**
 Set a new amount of seconds to the timer and restarts it.
 @param seconds The new amount of seconds to define on the timer.
 */
- (void)setTime:(NSTimeInterval)seconds;

@end
