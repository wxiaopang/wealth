//
//  UITextField+ExtentRange.m
//  wealth
//
//  Created by 心冷如灰 on 15/11/18.
//  Copyright © 2015年 普惠金融. All rights reserved.
//

#import "UITextField+ExtentRange.h"

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end

static void *const kUITextFieldId = (void *)&kUITextFieldId;
static void *const kUITextFieldLogInformation = (void *)&kUITextFieldLogInformation;

@implementation UITextField (ExtentRange)

- (void)setTextFieldId:(NSInteger)textFieldId {
    objc_setAssociatedObject(self, kUITextFieldId, @(textFieldId), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)textFieldId {
    return [objc_getAssociatedObject(self, kUITextFieldId) integerValue];
}

- (void)setActionLogInformation:(ActionLogInformation *)actionLogInformation {
    objc_setAssociatedObject(self, kUITextFieldLogInformation, actionLogInformation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ActionLogInformation *)actionLogInformation {
    return objc_getAssociatedObject(self, kUITextFieldLogInformation);
}

- (NSRange)selectedRange {
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void)setSelectedRange:(NSRange) range {
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

@end
