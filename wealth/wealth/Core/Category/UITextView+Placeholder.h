//
//  UITextView+Placeholder.h
//  wealth
//
//  Created by wangyingjie on 15/8/4.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Placeholder)

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, strong) NSDictionary *placeholderAttributes;

@property (nonatomic, assign) BOOL isBeginEditing;

@end
