//
//  UITimerLable.m
//  wealth
//
//  Created by wangyingjie on 15/2/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UITimerLable.h"

@interface UITimerLable ()

@property (nonatomic, strong) NSDate *expirationDate;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval numSeconds;

@end

@implementation UITimerLable

- (instancetype)initWithFrame:(CGRect)frame format:(NSString *)string time:(int)seconds delegate:(id <TimerLableDelegate>)delegate {
    NSAssert(seconds > 0, @"You must provide a positive amount of time.");
    self = [super initWithFrame:frame];
    if (self) {
        self.stringFormat   = string ?: @"%@";
        self.delegate       = delegate;
        [self defaultLabel];
        [self updateLabel];
        self.numSeconds     = seconds;
    }
    return self;
}

- (BOOL)valid {
    return self.timer.valid;
}

#pragma mark - Public methods

- (void)setTime:(NSTimeInterval)seconds {
    self.numSeconds = seconds;
    self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:self.numSeconds];
    if ( self.stringFormat == nil ) {
        self.stringFormat = @"%@";
    }
    [self updateLabel];
    [self restart];
}

- (void)restart {
    [self.timer invalidate];
    
    self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:self.numSeconds];
    self.text  = [NSString stringWithFormat:self.stringFormat, [self currentTimeString]];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
}

- (void)cancel {
    [self.timer invalidate];
    self.expirationDate = [NSDate date];
    self.text = [NSString stringWithFormat:self.stringFormat, [self currentTimeString]];
}

#pragma mark - Private methods

- (void)defaultLabel {
    self.backgroundColor = [UIColor clearColor];
    self.textAlignment   = NSTextAlignmentCenter;
    self.font            = [UIFont boldSystemFontOfSize:17];
    self.textColor       = [UIColor darkTextColor];
    self.shadowColor     = [UIColor clearColor];
}

- (void)updateLabel {
    NSString *currentTime = [self currentTimeString];
    self.text = [NSString stringWithFormat:self.stringFormat, currentTime];
    
    if ([[NSDate date] timeIntervalSinceDate:self.expirationDate] >= 0) {
        [self cancel];
        if ([self.delegate respondsToSelector:@selector(timeOut:)]) {
            [self.delegate timeOut:self];
        }
    }
}

- (NSString *)currentTimeString {
    NSDateComponents *countdown = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                                                  fromDate:[NSDate date]
                                                                    toDate:self.expirationDate
                                                                   options:0];
    NSString *timeRemaining;
    
    if ([countdown hour] > 0) {
        timeRemaining = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)[countdown hour],
                                                                         (long)[countdown minute],
                                                                         (long)[countdown second]];
    } else if ([countdown minute] > 0) {
        timeRemaining = [NSString stringWithFormat:@"%02ld:%02ld", (long)[countdown minute],
                                                                   (long)[countdown second]];
    } else {
        timeRemaining = [NSString stringWithFormat:@"%ld", (long)[countdown second]];
    }
    return timeRemaining;
}

@end
