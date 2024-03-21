//
//  UILabel+Base.h
//  iqianjin
//
//  Created by yangzhaofeng on 15/7/15.
//  Copyright (c) 2015年 iqianjin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SubLabTag) {
    SubLabTag_First     =20151201,
    SubLabTag_Second    =20151202,
    SubLabTag_Third     =20151203,
};

@interface UILabel (Base)

#pragma mark- init
- (id)initLabelWithFrame:(CGRect)frame
               textColor:(UIColor *)textColor
                    font:(UIFont *)font
           textAlignment:(NSTextAlignment)textAlignment;

//普通文本自适应高度(包含给label赋值)
- (void)setAdaptionHeightWithText:(NSString *)text;
//普通文本自适应高度(包含给label赋值)+设置行间距
- (void)setAdaptionHeightWithText:(NSString *)text lineSpacing:(CGFloat)lineSpacing;

//Attributed文本自适应高度(包含给label赋值)
- (void)setAdaptionHeightWithAttributedText:(NSString *)text
                                   textFont:(UIFont *)textFont
                                  textColor:(UIColor *)textColor
                              textLineStyle:(NSUnderlineStyle)textLineStyle
                                   unitText:(NSString *)unitText
                                   unitFont:(UIFont *)unitFont
                                  unitColor:(UIColor *)unitColor
                              unitLineStyle:(NSUnderlineStyle)unitLineStyle;
//Attributed文本自适应高度(包含给label赋值)+设置行间距
- (void)setAdaptionHeightWithAttributedText:(NSString *)text
                                   textFont:(UIFont *)textFont
                                  textColor:(UIColor *)textColor
                              textLineStyle:(NSUnderlineStyle)textLineStyle
                                   unitText:(NSString *)unitText
                                   unitFont:(UIFont *)unitFont
                                  unitColor:(UIColor *)unitColor
                              unitLineStyle:(NSUnderlineStyle)unitLineStyle
                                lineSpacing:(CGFloat)lineSpacing;


//普通文本自适应宽度(包含给label赋值)
- (void)setAdaptionWidthWithText:(NSString *)text;

//Attributed文本自适应宽度(包含给label赋值)
- (void)setAdaptionWidthWithAttributedText:(NSString *)text
                                  textFont:(UIFont *)textFont
                                 textColor:(UIColor *)textColor
                             textLineStyle:(NSUnderlineStyle)textLineStyle
                                  unitText:(NSString *)unitText
                                  unitFont:(UIFont *)unitFont
                                 unitColor:(UIColor *)unitColor
                             unitLineStyle:(NSUnderlineStyle)unitLineStyle;


//三种字体Attributed文本自适应宽度(包含给label赋值)
//中心对齐
- (void)setAdaptionWidthWithWithFirstText:(NSString *)fText
                                    fFont:(UIFont *)fFont
                                   fColor:(UIColor *)fColor
                               secondText:(NSString *)sText
                                    sFont:(UIFont *)sFont
                                   sColor:(UIColor *)sColor
                                thirdText:(NSString *)tText
                                    tFont:(UIFont *)tFont
                                   tColor:(UIColor *)tColor;
//可设置底部对齐
- (void)setAdaptionWidthWithWithFirstText:(NSString *)fText
                                    fFont:(UIFont *)fFont
                                   fColor:(UIColor *)fColor
                               secondText:(NSString *)sText
                                    sFont:(UIFont *)sFont
                                   sColor:(UIColor *)sColor
                                thirdText:(NSString *)tText
                                    tFont:(UIFont *)tFont
                                   tColor:(UIColor *)tColor
                          bottomAlignment:(BOOL)bottomBool;

@end
