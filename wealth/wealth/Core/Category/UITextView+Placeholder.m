//
//  UITextView+Placeholder.m
//  wealth
//
//  Created by wangyingjie on 15/8/4.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UITextView+Placeholder.h"

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end

static void * const kUITextViewPlaceholderKey = (void*)&kUITextViewPlaceholderKey;
static void * const kUITextViewPlaceholderAttributesKey = (void*)&kUITextViewPlaceholderAttributesKey;
static void * const kUITextViewBeginEditingKey = (void*)&kUITextViewBeginEditingKey;

@implementation UITextView (Placeholder)

+ (NSDictionary *)defaultPlaceholderAttributes {
    NSMutableDictionary *attributeDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];

    // 首行头部缩进
    //    paragraphStyle.firstLineHeadIndent = 28.0f;

    // 设置左缩进
    //    paragraphStyle.headIndent = 28.0f;

    // 设置右缩进
    //    paragraphStyle.tailIndent = 28.0f;

    // 设置换行方式
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    // 设置文本对齐方式
    paragraphStyle.alignment = NSTextAlignmentLeft;

    // 设置文本行间距
    paragraphStyle.lineSpacing = 3.5f;

    // 设置文本段间距
    paragraphStyle.paragraphSpacing = 10.0f;

    // 设置字间距
    attributeDic[NSKernAttributeName] = @(0.0f);

    // 设置字体
    attributeDic[NSFontAttributeName] = [UIFont systemFontOfSize:14];

    // 设置颜色
//    attributeDic[NSForegroundColorAttributeName] = [UIColor formTextFieldPlaceholderColor];

    // 设置段落属性
    attributeDic[NSParagraphStyleAttributeName] = paragraphStyle;

    return attributeDic;
}

- (void)setPlaceholder:(NSString *)placeholder {
    objc_setAssociatedObject(self, kUITextViewPlaceholderKey, placeholder, OBJC_ASSOCIATION_COPY_NONATOMIC);

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    if ( placeholder ) {
        [center addObserver:self selector:@selector(textViewTextDidBeginEditing) name:UITextViewTextDidBeginEditingNotification object:nil];
        [center addObserver:self selector:@selector(textViewTextDidEndEditing) name:UITextViewTextDidEndEditingNotification object:nil];
    } else {
        [center removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
        [center removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
    }
}

- (NSString *)placeholder {
    return objc_getAssociatedObject(self, kUITextViewPlaceholderKey);
}

- (void)setPlaceholderAttributes:(NSDictionary *)placeholderAttributes {
    objc_setAssociatedObject(self, kUITextViewPlaceholderAttributesKey, placeholderAttributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)placeholderAttributes {
    return objc_getAssociatedObject(self, kUITextViewPlaceholderAttributesKey);
}

- (void)setIsBeginEditing:(BOOL)isBeginEditing {
    objc_setAssociatedObject(self, kUITextViewBeginEditingKey, @(isBeginEditing), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isBeginEditing {
    return [objc_getAssociatedObject(self, kUITextViewBeginEditingKey) boolValue];
}

- (void)textViewTextDidBeginEditing {
    self.isBeginEditing = YES;
    [self setNeedsDisplay];
}

- (void)textViewTextDidEndEditing {
    self.isBeginEditing = NO;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if ( self.isBeginEditing || self.text.length > 0 ) {

    } else if ( self.placeholder ) {
        NSAttributedString *atributedString = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                              attributes:(self.placeholderAttributes
                                                                                          ? self.placeholderAttributes
                                                                                          : [UITextView defaultPlaceholderAttributes])];
        [atributedString drawInRect:CGRectMake(self.textContainerInset.left + 5, self.textContainerInset.bottom,
                                               rect.size.width - self.textContainerInset.left - self.textContainerInset.right,
                                               rect.size.height - self.textContainerInset.top - self.textContainerInset.bottom)];
    }
}

@end
