//
//  UIRegExTextField.m
//  wealth
//
//  Created by wangyingjie on 15/3/5.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UIRegExTextField.h"

@implementation UIRegExTextField

- (instancetype)init {
    self = [super init];
    if ( self ) {
        [self registNotification];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        [self registNotification];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        [self registNotification];
    }
    return self;
}

- (void)dealloc {
    [self unregistNotification];
}

- (NSString *)text {
    return [[super text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)setText:(NSString *)text {
    [super setText:text];
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    [super setSecureTextEntry:secureTextEntry];
    
    UITextPosition *beginning = [self beginningOfDocument];
    [self setSelectedTextRange:[self textRangeFromPosition:beginning toPosition:beginning]];
    UITextPosition *end = [self endOfDocument];
    [self setSelectedTextRange:[self textRangeFromPosition:end toPosition:end]];
}

//控制placeHolder的颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect {
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentLeft;
    CGRect frame = CGRectMake(0, (rect.size.height - 17)/2, rect.size.width, 17);
    [self.placeholder drawInRect:frame
                  withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14],
                                    NSForegroundColorAttributeName:[UIColor formTextFieldPlaceholderColor],
                                    NSParagraphStyleAttributeName:style
                                  }];
}

- (void)registNotification {
    [self addTarget:self action:@selector(validatorInput:) forControlEvents:UIControlEventEditingDidEnd];
    [self addTarget:self action:@selector(formatInput:) forControlEvents:UIControlEventEditingChanged];
}

- (void)unregistNotification {
    [self removeTarget:self action:@selector(validatorInput:) forControlEvents:UIControlEventEditingDidEnd];
    [self removeTarget:self action:@selector(formatInput:) forControlEvents:UIControlEventEditingChanged];
}

- (void)validatorInput:(UITextField *)textField {
    if ( self.regExPattern ) {
        Rx *rx = [self.regExPattern toRxWithOptions:NSRegularExpressionCaseInsensitive];
        if ( rx && ![rx isMatch:textField.text] ) {
            [self shake:10 withDelta:5 andSpeed:0.03 shakeDirection:ShakeDirectionHorizontal];
        } else {
            [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
        }
    }
}

- (void)formatInput:(UIRegExTextField *)textField {
    if ( self.maxLength > 0 ) {
        NSString *text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:kNullStr];
        if ( text.length > self.maxLength ) {
            textField.text = [text substringToIndex:self.maxLength];
        }
    }
}

@end
