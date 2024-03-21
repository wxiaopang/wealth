//
//  UITextField+Base.m
//  iqianjin
//
//  Created by yangzhaofeng on 15/7/15.
//  Copyright (c) 2015年 iqianjin. All rights reserved.
//

#import "UITextField+Base.h"


//银行卡号最大输入字符数限制
#define kMaxTextLength           25

@implementation UITextField (Base)

#pragma mark- init
- (id)initTextFieldWithFrame:(CGRect)frame
                        text:(NSString *)text
                        font:(UIFont *)font
                   textColor:(UIColor *)textColor
                     enabled:(BOOL)enabled
               textAlignment:(NSTextAlignment)textAlignment
                 placeholder:(NSString *)placeholder {
    self = [self initWithFrame:frame];
    if (self) {
        if (text) {
            self.text = text;
        }
        if (font) {
            self.font = font;
        }
        if (textColor) {
            self.textColor = textColor;
        }
        self.enabled = enabled;
        self.textAlignment = textAlignment;
        if (placeholder) {
            self.placeholder = placeholder;
        }
        
        self.backgroundColor = [UIColor clearColor];
        self.borderStyle = UITextBorderStyleNone; //设置边框样式，只有设置了才会显示边框样式
//        self.clearButtonMode = UITextFieldViewModeWhileEditing; //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
        self.clearButtonMode = UITextFieldViewModeNever;
        self.secureTextEntry = NO; //每输入一个字符就变成点 用语密码输入
        self.autocorrectionType = UITextAutocorrectionTypeNo; //是否自动纠错
        self.clearsOnBeginEditing = NO; //是否再次编辑就清空
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; //内容垂直对齐方式
        self.adjustsFontSizeToFitWidth = NO; //设置为YES时文本会自动缩小以适应文本窗口大小.默认是保持原来大小,而让长文本滚动
//        self.minimumFontSize = 20; //设置自动缩小显示的最小字体大小,当adjustsFontSizeToFitWidth = YES时使用
        self.autocapitalizationType = UITextAutocapitalizationTypeNone; //首字母是否大写
    }
    return self;
}


#pragma mark- 金额输入TextField验证
- (BOOL)amountsTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string completeBlock:(StringBlock)completeBlock {
    if (string && string.length > 0) {
        for (NSInteger i = 0; i < string.length; i++) {
            unichar single=[string characterAtIndex:i];
            if ((single >='0' && single<='9') || single=='.'){
                
            }else{
                return NO;
            }
        }
    }
    if ([string isEqualToString:@"0"]) {
        if (range.location == 0) {
            return NO;
        }
    }
    
    if ([textField.text doubleValue] == 0.0f && ![textField.text isEqualToString:@"."] && ![textField.text isEqualToString:@"0.0"]) {
        textField.text = @"";
    }
    if ([textField.text isEqualToString:@"."]) {
        textField.text = @"0.";
    }
    //不允许重复输入小数点
    NSMutableString *text = [NSMutableString stringWithString:textField.text];
    NSRange foundObj=[text rangeOfString:@"." options:NSCaseInsensitiveSearch];
    if ([string isEqualToString:@"."]) {
        if (foundObj.location > 0  && foundObj.location < 30) {
            return NO;
        }
    }
    //光标移动数输入小数点保留两位小数（199.999）
    NSRange selrange = [self getRangeWithTextField:textField];
    if (text.length - foundObj.location > 2 && text.length > 0 && string.length > 0 && foundObj.length > 0 && foundObj.location < selrange.location) {
        return NO;
    }

    //删除字符（删除判断string.length<1）
    NSString *resultStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if (string.length<1 && textField.text.length == 1) {
        resultStr = @"0";
    }
    if (string.length <1 && textField.text.length > 1) {
        resultStr = [resultStr substringToIndex:resultStr.length - 1];
    }
    
    completeBlock(resultStr);
    return YES;
}

#pragma mark 获取光标位置
- (NSRange)getRangeWithTextField:(UITextField *)textField {
    UITextPosition* beginning = textField.beginningOfDocument;
    UITextRange* selectedRange = textField.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    NSInteger location = [textField offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [textField offsetFromPosition:selectionStart toPosition:selectionEnd];
    NSRange range = NSMakeRange(location, length);
    return range;
}

- (void) setSelectedRange:(NSRange) range
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}


#pragma mark- 银行卡输入TextField验证
- (BOOL)cardTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string && string.length > 0) {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if (!(single >='0' && single<='9')){
            return NO;
        }
    }
    NSString *currentString = [self getNormalStringFromBankString:textField.text];
    if (currentString.length + string.length - range.length > kMaxTextLength) {
        if (currentString.length >= kMaxTextLength) {
            currentString = [currentString substringToIndex:kMaxTextLength];
        }else{
            NSUInteger remainLength = kMaxTextLength - currentString.length + range.length;
            if (string.length < 1) {
                return YES;
            }
            currentString = [currentString stringByReplacingCharactersInRange:range withString:[string substringToIndex:remainLength]];
            
        }
        textField.text = [self getBankStringFromNormalString:currentString];
        return NO;
    }
    //判断删除最后一位是空格时,需要越过空格直接删空格前的数
    if (range.location + range.length == textField.text.length && range.length >0 && ((range.location + 1) % 5 == 0)) {
        textField.text = [textField.text substringToIndex:textField.text.length - 1];
    }
    //判断若在中间插入字符时遇到需要格式化加空格,则光标向后跳一位
    if (range.length == 0 && ((range.location + 1) % 5 == 0)) {
        UITextPosition *oldPosition = [textField positionFromPosition:textField.selectedTextRange.start offset:1];
        textField.selectedTextRange = [textField textRangeFromPosition:oldPosition toPosition:oldPosition];
    }
    return YES;
}

#pragma mark 银行卡输入完成获取Text
- (NSString *)getBlankStringWithString:(NSString *)cardInputString textFiledDidChanged:(UITextField *)textField {
    NSString *currentString = [self getNormalStringFromBankString:textField.text];
    if (currentString.length > kMaxTextLength) {
        if (textField.markedTextRange == nil) {
            currentString = [currentString substringToIndex:kMaxTextLength];
        }
    }
    
    if (currentString.length <= cardInputString.length) {//删除操作
        UITextPosition *oldPosition = [textField positionFromPosition:textField.selectedTextRange.start offset:0];
        textField.text = [self getBankStringFromNormalString:currentString];
        textField.selectedTextRange = [textField textRangeFromPosition:oldPosition toPosition:oldPosition];
    } else {//插入操作
        UITextPosition *oldPosition = [textField positionFromPosition:textField.selectedTextRange.start offset:0];
        textField.text = [self getBankStringFromNormalString:currentString];
        textField.selectedTextRange = [textField textRangeFromPosition:oldPosition toPosition:oldPosition];
    }
    return currentString;
}


#pragma mark 获取格式化字符串（4个数字1空格）
- (NSString *)getBankStringFromNormalString:(NSString *)sourceString {
    NSString *normalString = [self getNormalStringFromBankString:sourceString];
    NSUInteger size = (normalString.length / 4);
    NSMutableArray *tempStringArray = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < size; i ++) {
        [tempStringArray addObject:[normalString substringWithRange:NSMakeRange(i * 4, 4)]];
    }
    [tempStringArray addObject:[normalString substringWithRange:NSMakeRange(size * 4, (normalString.length % 4))]];
    return [tempStringArray componentsJoinedByString:@" "];
}

#pragma mark 获取正常字符串
- (NSString *)getNormalStringFromBankString:(NSString *)blankString {
    return [blankString stringByReplacingOccurrencesOfString:@" " withString:@""];
}


#pragma mark- 纯数字验证
- (BOOL)numberTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string && string.length > 0) {
        unichar single=[string characterAtIndex:0];
        if (!(single >='0' && single<='9')){
            return NO;
        }
    }
    return YES;
}

@end
