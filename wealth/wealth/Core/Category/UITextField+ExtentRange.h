//
//  UITextField+ExtentRange.h
//  wealth
//
//  Created by 心冷如灰 on 15/11/18.
//  Copyright © 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActionLogInformation;

@interface UITextField (ExtentRange)

@property (nonatomic, assign) NSInteger textFieldId;
@property (nonatomic, strong) ActionLogInformation *actionLogInformation;

- (NSRange)selectedRange;
- (void)setSelectedRange:(NSRange)range;

@end
