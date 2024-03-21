//
//  UIButton+Base.m
//  iqianjin
//
//  Created by yangzhaofeng on 15/7/15.
//  Copyright (c) 2015年 iqianjin. All rights reserved.
//

#import "UIButton+Base.h"

@implementation UIButton (Base)

#pragma mark- init
- (UIButton *)initButtonWithFrame:(CGRect)frame
                  backgroundColor:(UIColor *)backgroundColor
                             font:(UIFont *)font
                       titleColor:(UIColor *)titleColor
                            title:(NSString *)title {
    self = [self initWithFrame:frame];
    if (self) {
        if (backgroundColor) {
            self.backgroundColor = backgroundColor;
        }
        if (font) {
            self.titleLabel.font = font;
        }
        if (titleColor) {
            [self setTitleColor:titleColor forState:UIControlStateNormal];
        }
        if (title) {
            [self setTitle:title forState:UIControlStateNormal];
        }
    }
    return self;
}

- (void)setVerticalAlignmentWithPadding:(CGFloat)padding {
    NSString *titleText = [self titleForState:UIControlStateNormal];
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    if (self.titleLabel.hidden == YES || titleText.length == 0)
        titleSize = CGSizeZero;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -roundf(imageSize.width), -round(imageSize.height + padding), 0.0);
    
    titleSize = [[self titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    if (self.titleLabel.hidden == YES || titleText.length == 0)
        titleSize = CGSizeZero;
    self.imageEdgeInsets = UIEdgeInsetsMake(-roundf(titleSize.height + padding), 0.0, 0.0, -roundf(titleSize.width));
}

+ (UIButton *)buttonCustomRedButtonWithFrame:(CGRect)frame title:(NSString *)title {
    UIButton *redButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [redButton setFrame:frame];
    [redButton.titleLabel setFont:[UIFont get_A24_CN_NOR_Font]];
    [redButton setTitle:title forState:UIControlStateNormal];
    [redButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [redButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [redButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [redButton setBackgroundImage:[UIImage imageFromColor:[UIColor button1BackgroundNormalColor] withframe:redButton.frame] forState:UIControlStateNormal];
    [redButton setBackgroundImage:[UIImage imageFromColor:[UIColor button1BackgroundHighlightColor] withframe:redButton.frame] forState:UIControlStateHighlighted];
    [redButton setBackgroundImage:[UIImage imageFromColor:[UIColor button1BackgroundDisableColor] withframe:redButton.frame] forState:UIControlStateDisabled];
    redButton.layer.cornerRadius = 3.0;
    redButton.layer.masksToBounds = YES;
    return redButton;
}

+ (UIButton *)buttonCustomWhiteButtonWithFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor boundscolor:(UIColor *)boundscolor {
    UIButton *whiteButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [whiteButton setFrame:frame];
    [whiteButton.titleLabel setFont:[UIFont get_A24_CN_NOR_Font]];
    [whiteButton setTitle:title forState:UIControlStateNormal];
    [whiteButton setTitleColor:textColor ? textColor : [UIColor button1BackgroundNormalColor] forState:UIControlStateNormal];
    [whiteButton setTitleColor:textColor ? textColor : [UIColor button1BackgroundNormalColor] forState:UIControlStateHighlighted];
    [whiteButton setTitleColor:textColor ? textColor : [UIColor button1BackgroundNormalColor] forState:UIControlStateDisabled];
    [whiteButton setBackgroundImage:[UIImage imageFromColor:[UIColor button1BackgroundNormalColor] withframe:whiteButton.frame] forState:UIControlStateNormal];
    [whiteButton setBackgroundImage:[UIImage imageFromColor:[UIColor button1BackgroundNormalColor] withframe:whiteButton.frame] forState:UIControlStateHighlighted];
    [whiteButton setBackgroundImage:[UIImage imageFromColor:[UIColor button1BackgroundNormalColor] withframe:whiteButton.frame] forState:UIControlStateDisabled];
    whiteButton.layer.cornerRadius = 3.0;
    whiteButton.layer.masksToBounds = YES;
    whiteButton.layer.borderColor = boundscolor ? boundscolor.CGColor : [UIColor button1BackgroundNormalColor].CGColor;
    whiteButton.layer.borderWidth = 0.5f;
    return whiteButton;
}


+ (UIButton *)buttonUnderlineButtonWithFrame:(CGRect)frame font:(UIFont *)font title:(NSString *)title color:(UIColor *)color {
    UIButton *underLineButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [underLineButton setFrame:frame];
    [underLineButton.titleLabel setFont:font];
    underLineButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *investNormalLinkName = [[NSMutableAttributedString alloc] initWithString:title];
    [investNormalLinkName addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [investNormalLinkName length])];
    [investNormalLinkName addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [investNormalLinkName length])];
    
    NSMutableAttributedString *investLinkHighlightedLinkName = [[NSMutableAttributedString alloc] initWithString:title];
    [investLinkHighlightedLinkName addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [investLinkHighlightedLinkName length])];
    [investLinkHighlightedLinkName addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [investLinkHighlightedLinkName length])];
    
    [underLineButton setAttributedTitle:investNormalLinkName forState:UIControlStateNormal];
    [underLineButton setAttributedTitle:investLinkHighlightedLinkName forState:UIControlStateHighlighted];
    
    return underLineButton;
}

+ (UIButton *)buttonWhiteDoubleLineButtonWithFrame:(CGRect)frame title:(NSString *)title color:(UIColor *)color {
    UIButton *whiteButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [whiteButton setFrame:frame];
    [whiteButton.titleLabel setFont:[UIFont get_A24_CN_NOR_Font]];
    [whiteButton setTitle:title forState:UIControlStateNormal];
    [whiteButton setTitleColor:color forState:UIControlStateNormal];
    [whiteButton setTitleColor:color forState:UIControlStateHighlighted];
    [whiteButton setTitleColor:color forState:UIControlStateDisabled];
    [whiteButton setBackgroundImage:[UIImage imageFromColor:[UIColor button1BackgroundNormalColor] withframe:whiteButton.frame] forState:UIControlStateNormal];
    [whiteButton setBackgroundImage:[UIImage imageFromColor:[UIColor button1BackgroundNormalColor] withframe:whiteButton.frame] forState:UIControlStateHighlighted];
    [whiteButton setBackgroundImage:[UIImage imageFromColor:[UIColor button1BackgroundNormalColor] withframe:whiteButton.frame] forState:UIControlStateDisabled];
    [whiteButton addLineWithFrame:CGRectMake(0, 0, ScreenWidth, kSeparateLineHeight)];
    [whiteButton addLineWithFrame:CGRectMake(0, frame.size.height - kSeparateLineHeight, ScreenWidth, kSeparateLineHeight)];
    return whiteButton;
}

+ (UIButton *)buttonColorLineWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font color:(UIColor *)textColor useLine:(BOOL)line {
    UIButton *colorLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    colorLineBtn.frame = frame;
    NSAttributedString *colorLineBtnStr = [title getAttributedStringWithFont:font
                                                               textColor:textColor
                                                               textLineStyle:line ? NSUnderlineStyleSingle : NSUnderlineStyleNone];
    [colorLineBtn setAttributedTitle:colorLineBtnStr forState:UIControlStateNormal];
    colorLineBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    return colorLineBtn;
}

//上面是图片下面是文字的按钮
+ (UIButton *)buttonVerticalWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image padding:(CGFloat)padding {
    UIButton *verticalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    verticalBtn.frame = frame;
    [verticalBtn setTitle:title forState:UIControlStateNormal];
    verticalBtn.titleLabel.font = [UIFont get_A24_CN_NOR_Font];
    [verticalBtn setTitleColor:[UIColor button1BackgroundNormalColor] forState:UIControlStateNormal];
    [verticalBtn setTitleColor:[UIColor button1BackgroundNormalColor] forState:UIControlStateHighlighted];
    [verticalBtn setImage:image forState:UIControlStateNormal];
    [verticalBtn setImage:image forState:UIControlStateHighlighted];
    [verticalBtn setVerticalAlignmentWithPadding:padding];
    return verticalBtn;
}

@end
