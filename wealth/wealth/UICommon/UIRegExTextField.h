//
//  UIRegExTextField.h
//  wealth
//
//  Created by wangyingjie on 15/3/5.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIRegExTextField : UITextField

@property (nonatomic, copy) NSString *regExPattern;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, assign) NSInteger separatorSize;
@property (nonatomic, copy) NSString *separatorString;

@property (nonatomic, copy) NSString *text;

@end
