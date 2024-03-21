//
//  UILabel+XSCategory.h
//  iqianjin
//
//  Created by yangzhaofeng on 14-5-29.
//  Copyright (c) 2014年 iqianjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (XSCategory)

// 字间距
@property (nonatomic, assign) CGFloat characterSpacing;

// 行间距
@property (nonatomic, assign) CGFloat lineSpacing;

// 段间距
@property (nonatomic, assign) CGFloat paragraphSpacing;

+ (NSAttributedString *)spacingFormatAttributedStringWithText:(NSString *)text
                                                    textColor:(UIColor *)textColor
                                                         font:(UIFont *)font
                                                textAlignment:(NSTextAlignment)textAlignment
                                             characterSpacing:(CGFloat)characterSpacing
                                                  lineSpacing:(CGFloat)lineSpacing
                                             paragraphSpacing:(CGFloat)paragraphSpacing;

- (NSAttributedString *)spacingFormatAttributedString;

//label文本自适应高度(包含给label赋值)
- (void)setAdaptionHeightWithText:(NSString *)text;
//label文本自适应宽度(包含给label赋值)
- (void)setAdaptionWidthWithText:(NSString *)text;

- (CGSize)textSize;

// 动画显示数字
- (void)setNumberTextOfLabel:(UILabel *)label WithAnimationForValueContent:(CGFloat)value;

@end
