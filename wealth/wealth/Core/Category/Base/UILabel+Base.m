//
//  UILabel+Base.m
//  iqianjin
//
//  Created by yangzhaofeng on 15/7/15.
//  Copyright (c) 2015年 iqianjin. All rights reserved.
//

#import "UILabel+Base.h"

@implementation UILabel (Base)

#pragma mark- init
- (id)initLabelWithFrame:(CGRect)frame
               textColor:(UIColor *)textColor
                    font:(UIFont *)font
           textAlignment:(NSTextAlignment)textAlignment {
    self = [self initWithFrame:frame];
    if (self) {
        if (font) {
            self.font = font;
        }
        if (textColor) {
            self.textColor = textColor;
        }
        self.textAlignment = textAlignment;
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

//普通文本自适应高度(包含给label赋值)
- (void)setAdaptionHeightWithText:(NSString *)text {
    [self setAdaptionHeightWithText:text lineSpacing:0];
}

//普通文本自适应高度(包含给label赋值)+设置行间距
- (void)setAdaptionHeightWithText:(NSString *)text lineSpacing:(CGFloat)lineSpacing {
    self.numberOfLines = 0;//设置无限字数
    //设置行高限制
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.lineSpacing = lineSpacing;
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT)
                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                      attributes:@{ NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paragraphStyle }
                                         context:nil].size;
    CGRect rect = self.frame;
    rect.size.height = textSize.height;
    self.frame = rect;
    [self setText:text];
}

//Attributed文本自适应高度(包含给label赋值)
- (void)setAdaptionHeightWithAttributedText:(NSString *)text
                                   textFont:(UIFont *)textFont
                                  textColor:(UIColor *)textColor
                              textLineStyle:(NSUnderlineStyle)textLineStyle
                                   unitText:(NSString *)unitText
                                   unitFont:(UIFont *)unitFont
                                  unitColor:(UIColor *)unitColor
                              unitLineStyle:(NSUnderlineStyle)unitLineStyle {
    
    [self setAdaptionHeightWithAttributedText:text
                                     textFont:textFont
                                    textColor:textColor
                                textLineStyle:textLineStyle
                                     unitText:unitText
                                     unitFont:unitFont
                                    unitColor:unitColor
                                unitLineStyle:unitLineStyle
                                  lineSpacing:0];
}

//Attributed文本自适应高度(包含给label赋值)+设置行间距
- (void)setAdaptionHeightWithAttributedText:(NSString *)text
                                   textFont:(UIFont *)textFont
                                  textColor:(UIColor *)textColor
                              textLineStyle:(NSUnderlineStyle)textLineStyle
                                   unitText:(NSString *)unitText
                                   unitFont:(UIFont *)unitFont
                                  unitColor:(UIColor *)unitColor
                              unitLineStyle:(NSUnderlineStyle)unitLineStyle
                                lineSpacing:(CGFloat)lineSpacing {
    self.numberOfLines = 0;//设置无限字数
    //设置行高限制
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.lineSpacing = lineSpacing;
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT)
                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                      attributes:@{ NSFontAttributeName:textFont, NSParagraphStyleAttributeName:paragraphStyle }
                                         context:nil].size;
    if (unitText && unitText.length > 0) {
        CGSize unitTextSize = [unitText boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT)
                                                     options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                  attributes:@{ NSFontAttributeName:unitFont, NSParagraphStyleAttributeName:paragraphStyle }
                                                     context:nil].size;
        textSize = CGSizeMake(textSize.width + unitTextSize.width, textSize.height + unitTextSize.height);
    }
    
    CGRect rect = self.frame;
    rect.size.height = textSize.height;
    self.frame = rect;
    NSAttributedString *resultText = [text getAttributedStringWithFont:textFont textColor:textColor textLineStyle:textLineStyle unitText:unitText unitFont:unitFont unitColor:unitColor unitLineStyle:unitLineStyle];
    
    [self setAttributedText:resultText];
}


//普通文本自适应宽度(包含给label赋值)
- (void)setAdaptionWidthWithText:(NSString *)text {
    self.numberOfLines = 1;//设置1行
    //设置行宽限制
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height)
                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                      attributes:@{ NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paragraphStyle }
                                         context:nil].size;
    
    CGRect rect = self.frame;
    rect.size.width = textSize.width;
    self.frame = rect;
    [self setText:text];
}

//Attributed文本自适应宽度(包含给label赋值)
- (void)setAdaptionWidthWithAttributedText:(NSString *)text
                                  textFont:(UIFont *)textFont
                                 textColor:(UIColor *)textColor
                             textLineStyle:(NSUnderlineStyle)textLineStyle
                                  unitText:(NSString *)unitText
                                  unitFont:(UIFont *)unitFont
                                 unitColor:(UIColor *)unitColor
                             unitLineStyle:(NSUnderlineStyle)unitLineStyle {
    self.numberOfLines = 1;//设置1行
    //设置行宽限制
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height)
                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                      attributes:@{ NSFontAttributeName:textFont, NSParagraphStyleAttributeName:paragraphStyle }
                                         context:nil].size;
    if (unitText && unitText.length > 0) {
        CGSize unitTextSize = [unitText boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height)
                                                     options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                  attributes:@{ NSFontAttributeName:unitFont, NSParagraphStyleAttributeName:paragraphStyle }
                                                     context:nil].size;
        textSize = CGSizeMake(textSize.width + unitTextSize.width, textSize.height + unitTextSize.height);
    }
    CGRect rect = self.frame;
    rect.size.width = textSize.width;
    self.frame = rect;
    NSAttributedString *resultText = [text getAttributedStringWithFont:textFont textColor:textColor textLineStyle:textLineStyle unitText:unitText unitFont:unitFont unitColor:unitColor unitLineStyle:unitLineStyle];
    [self setAttributedText:resultText];
}


#pragma mark 三种字体Attributed文本自适应宽度(包含给label赋值)
- (void)setAdaptionWidthWithWithFirstText:(NSString *)fText
                                    fFont:(UIFont *)fFont
                                   fColor:(UIColor *)fColor
                               secondText:(NSString *)sText
                                    sFont:(UIFont *)sFont
                                   sColor:(UIColor *)sColor
                                thirdText:(NSString *)tText
                                    tFont:(UIFont *)tFont
                                   tColor:(UIColor *)tColor {
    [self setAdaptionWidthWithWithFirstText:fText
                                      fFont:fFont
                                     fColor:fColor
                                 secondText:sText
                                      sFont:sFont
                                     sColor:sColor
                                  thirdText:tText
                                      tFont:tFont
                                     tColor:tColor
                            bottomAlignment:NO];
}

- (void)setAdaptionWidthWithWithFirstText:(NSString *)fText
                                    fFont:(UIFont *)fFont
                                   fColor:(UIColor *)fColor
                               secondText:(NSString *)sText
                                    sFont:(UIFont *)sFont
                                   sColor:(UIColor *)sColor
                                thirdText:(NSString *)tText
                                    tFont:(UIFont *)tFont
                                   tColor:(UIColor *)tColor
                          bottomAlignment:(BOOL)bottomBool {
    self.numberOfLines = 1;//设置1行
    
    UILabel *fLable = [self viewWithTag:SubLabTag_First];
    if ([NSString isAvailableString:fText]) {
        if (!fLable) {
            fLable = [[UILabel alloc] initLabelWithFrame:CGRectMake(0, 0, 0, fFont.pointSize) textColor:fColor font:fFont textAlignment:NSTextAlignmentLeft];
            fLable.tag = SubLabTag_First;
        }
        [self addSubview:fLable];
        fLable.hidden = NO;
        [fLable setAdaptionWidthWithText:fText];
    } else if (fLable) {
        fLable.hidden = YES;
        [fLable setAdaptionWidthWithText:@""];
    }
    
    
    UILabel *sLable = [self viewWithTag:SubLabTag_Second];
    if ([NSString isAvailableString:sText]) {
        if (!sLable) {
            sLable = [[UILabel alloc] initLabelWithFrame:CGRectMake(fLable.right, fLable.top, 0, sFont.pointSize) textColor:sColor font:sFont textAlignment:NSTextAlignmentLeft];
            sLable.tag = SubLabTag_Second;
        }
        [self addSubview:sLable];
        sLable.hidden = NO;
        sLable.left = fLable.right + 1.5;
        sLable.center = CGPointMake(sLable.center.x, fLable.center.y);
        [sLable setAdaptionWidthWithText:sText];
    } else if (sLable) {
        sLable.hidden = YES;
        [sLable setAdaptionWidthWithText:@""];
    }

    
    UILabel *tLable = [self viewWithTag:SubLabTag_Third];
    if ([NSString isAvailableString:tText]) {
        if (!tLable) {
            tLable = [[UILabel alloc] initLabelWithFrame:CGRectMake(sLable.right, sLable.top, 0, tFont.pointSize) textColor:tColor font:tFont textAlignment:NSTextAlignmentLeft];
            tLable.tag = SubLabTag_Third;
        }
        [self addSubview:tLable];
        tLable.hidden = NO;
        tLable.left = sLable.right + 1.5;
        tLable.center = CGPointMake(tLable.center.x, sLable.center.y);
        [tLable setAdaptionWidthWithText:tText];
    } else if (sLable) {
        tLable.hidden = YES;
        [tLable setAdaptionWidthWithText:@""];
    }

    if (bottomBool) {
        fLable.bottom = sLable.bottom = self.height;
        if ([NSString isAvailableString:tText]) {
            tLable.bottom = self.height;
        }
    }
    
    if ([NSString isAvailableString:tText]) {
        self.width = kGetMax(fLable.right, sLable.right, tLable.right);
    } else {
        self.width = MAX(fLable.right, sLable.right);
    }
}


@end
