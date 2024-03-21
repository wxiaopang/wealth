//
//  UITextField+Base.h
//  iqianjin
//
//  Created by yangzhaofeng on 15/7/15.
//  Copyright (c) 2015年 iqianjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Base)

#pragma mark- init
- (id)initTextFieldWithFrame:(CGRect)frame
                        text:(NSString *)text
                        font:(UIFont *)font
                   textColor:(UIColor *)textColor
                     enabled:(BOOL)enabled
               textAlignment:(NSTextAlignment)textAlignment
                 placeholder:(NSString *)placeholder;

#pragma mark- 金额输入TextField验证
- (BOOL)amountsTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string completeBlock:(StringBlock)completeBlock;
#pragma mark 获取光标位置
- (NSRange)getRangeWithTextField:(UITextField *)textField;
- (void) setSelectedRange:(NSRange) range;

#pragma mark- 银行卡输入TextField验证
- (BOOL)cardTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
#pragma mark 输入完成获取Text
- (NSString *)getBlankStringWithString:(NSString *)cardInputString textFiledDidChanged:(UITextField *)textField;
#pragma mark 获取银行卡号格式化字符串（4个数字1空格）
- (NSString *)getBankStringFromNormalString:(NSString *)sourceString;
#pragma mark 获取银行卡号正常字符串
- (NSString *)getNormalStringFromBankString:(NSString *)blankString;


#pragma mark- 纯数字验证
- (BOOL)numberTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
