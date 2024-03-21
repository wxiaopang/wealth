//
//  UILabel+XSCategory.m
//  iqianjin
//
//  Created by yangzhaofeng on 14-5-29.
//  Copyright (c) 2014年 iqianjin. All rights reserved.
//

#import "UILabel+XSCategory.h"

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end

static void *const kUILabelCharacterSpacingKey = (void *)&kUILabelCharacterSpacingKey;
static void *const kUILabelLineSpacingKey      = (void *)&kUILabelLineSpacingKey;
static void *const kUILabelParagraphSpacingKey = (void *)&kUILabelParagraphSpacingKey;
static void *const kUILabelTimerKey            = (void *)&kUILabelTimerKey;

@implementation UILabel (XSCategory)

- (void)setCharacterSpacing:(CGFloat)characterSpacing {
    objc_setAssociatedObject(self, &kUILabelCharacterSpacingKey, @(characterSpacing), OBJC_ASSOCIATION_ASSIGN);
    [self setNeedsDisplay];
}

- (CGFloat)characterSpacing {
    return [objc_getAssociatedObject(self, &kUILabelCharacterSpacingKey) floatValue];
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    objc_setAssociatedObject(self, &kUILabelLineSpacingKey, @(lineSpacing), OBJC_ASSOCIATION_ASSIGN);
    [self setNeedsDisplay];
}

- (CGFloat)lineSpacing {
    return [objc_getAssociatedObject(self, &kUILabelLineSpacingKey) floatValue];
}

- (void)setParagraphSpacing:(CGFloat)paragraphSpacing {
    objc_setAssociatedObject(self, &kUILabelParagraphSpacingKey, @(paragraphSpacing), OBJC_ASSOCIATION_ASSIGN);
    [self setNeedsDisplay];
}

- (CGFloat)paragraphSpacing {
    return [objc_getAssociatedObject(self, &kUILabelParagraphSpacingKey) floatValue];
}

+ (NSAttributedString *)spacingFormatAttributedStringWithText:(NSString *)text
                                                    textColor:(UIColor *)textColor
                                                         font:(UIFont *)font
                                                textAlignment:(NSTextAlignment)textAlignment
                                             characterSpacing:(CGFloat)characterSpacing
                                                  lineSpacing:(CGFloat)lineSpacing
                                             paragraphSpacing:(CGFloat)paragraphSpacing {
    //去掉空行
    NSString *myString = [text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];

    //创建AttributeString
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:myString];

    NSMutableDictionary     *attributeDic   = [[NSMutableDictionary alloc] initWithCapacity:0];
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
    paragraphStyle.alignment = textAlignment;

    // 设置文本行间距
    paragraphStyle.lineSpacing = lineSpacing;

    // 设置文本段间距
    paragraphStyle.paragraphSpacing = paragraphSpacing;

    // 设置字间距
    attributeDic[NSKernAttributeName] = @(characterSpacing);

    // 设置字体
    attributeDic[NSFontAttributeName] = font;

    // 设置颜色
    attributeDic[NSForegroundColorAttributeName] = textColor;

    // 设置段落属性
    attributeDic[NSParagraphStyleAttributeName] = paragraphStyle;

    // 应用格式化
    [attributedString addAttributes:attributeDic range:NSMakeRange(0, myString.length)];

    return attributedString;
}

/*
 *初始化AttributedString并进行相应设置
 */
- (NSAttributedString *)spacingFormatAttributedString {
    return [UILabel spacingFormatAttributedStringWithText:self.text
                                                textColor:self.textColor
                                                     font:self.font
                                            textAlignment:self.textAlignment
                                         characterSpacing:self.characterSpacing
                                              lineSpacing:self.lineSpacing
                                         paragraphSpacing:self.paragraphSpacing];
}

//label文本自适应高度(包含给label赋值)
- (void)setAdaptionHeightWithText:(NSString *)text {
    if ([text isEqual:[NSNull null]]) {
        return;
    }
    self.numberOfLines = 0;//设置无限字数
    //设置行高限制
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT)
                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                      attributes:@{ NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paragraphStyle }
                                         context:nil].size;
    CGRect rect = self.frame;
    rect.size.height = textSize.height;
    self.frame       = rect;
    [self setText:text];
}

//label文本自适应宽度(包含给label赋值)
- (void)setAdaptionWidthWithText:(NSString *)text {
    self.numberOfLines = 1;//设置1行
    //设置行宽限制
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(200, self.bounds.size.height)
                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                      attributes:@{ NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paragraphStyle }
                                         context:nil].size;

    CGRect rect = self.frame;
    rect.size.width = textSize.width;
    self.frame      = rect;
    [self setText:text];
}

- (CGSize)textSize {
    return [self.text boundingRectWithSize:CGSizeMake(ScreenWidth, CGFLOAT_MAX)
                                   options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                attributes:@{ NSFontAttributeName:self.font }
                                   context:nil].size;
}

- (void)setNumberTextOfLabel:(UILabel *)label WithAnimationForValueContent:(CGFloat)value {
    CGFloat lastValue = [label.text floatValue];
    CGFloat delta     = value - lastValue;
    if (delta == 0) return;

    if (delta > 0) {
        CGFloat      ratio     = value / 60.0;
        NSDictionary *userInfo = @{ @"label" : label,
                                    @"value" : @(value),
                                    @"ratio" : @(ratio) };
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(setupLabelAnimationForValueContent:) userInfo:userInfo repeats:YES];
        objc_setAssociatedObject(self, &kUILabelTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        //        NSString *text = [NSString stringWithFormat:@"%.2f", value];
        NSString *text = [@(value)stringCommonFormatter];
        if (label.attributedText) {
            NSRange                   range           = NSMakeRange(0, 0);
            NSDictionary              *dic            = [label.attributedText attributesAtIndex:0 effectiveRange:&range];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:dic];
            label.attributedText = attributedText;
        } else {
            label.text = text;
        }
    }
}

- (void)setupLabelAnimationForValueContent:(NSTimer *)timer {
    NSDictionary *userInfo = timer.userInfo;
    UILabel      *label    = userInfo[@"label"];
    CGFloat      value     = [userInfo[@"value"] floatValue];
    CGFloat      ratio     = [userInfo[@"ratio"] floatValue];

    static int flag        = 1;
    CGFloat    lastValue   = [label.text floatValue];
    CGFloat    randomDelta = (arc4random_uniform(2) + 1) * ratio;
    CGFloat    resValue    = lastValue + randomDelta;

    if ((resValue >= value) || (flag == 50)) {
        //        NSString *text = [NSString stringWithFormat:@"%.2f", value];
        NSString *text = [@(value)stringCommonFormatter];
        if (label.attributedText) {
            NSRange                   range           = NSMakeRange(0, 0);
            NSDictionary              *dic            = [label.attributedText attributesAtIndex:0 effectiveRange:&range];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:dic];
            label.attributedText = attributedText;
        } else {
            label.text = text;
        }
        flag = 1;
        [timer invalidate];
        timer = nil;
        return;
    } else {
        NSString *text = [NSString stringWithFormat:@"%.2f", resValue];
        if (label.attributedText) {
            NSRange                   range           = NSMakeRange(0, 0);
            NSDictionary              *dic            = [label.attributedText attributesAtIndex:0 effectiveRange:&range];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:dic];
            label.attributedText = attributedText;
        } else {
            label.text = text;
        }
    }
    flag++;
}

@end
