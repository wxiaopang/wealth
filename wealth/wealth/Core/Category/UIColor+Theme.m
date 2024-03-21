//
//  UIColor+Theme.m
//  wealth
//
//  Created by wangyingjie on 15/2/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UIColor+Theme.h"

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end

//#define CREATECOLOR(r,g,b,a)        [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@implementation UIColor (Theme)

+ (UIColor *)colorWithHex:(NSInteger)hex {
    NSInteger r = (hex >> 16) & 255;
    NSInteger g = (hex >> 8) & 255;
    NSInteger b = hex & 255;
    
    CGFloat rf = (CGFloat)r / 255.0f;
    CGFloat gf = (CGFloat)g / 255.0f;
    CGFloat bf = (CGFloat)b / 255.0f;
    
    return CREATECOLOR(rf, gf, bf, 1.0);
}

+ (UIColor*)colorWithHexString:(NSString*)hex {
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];

    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];

    if ([cString length] != 6) return  [UIColor grayColor];

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];

    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return CREATECOLOR(r, g, b, 1.0f);
}

+ (UIColor *)getColorWithR236G231B227 {
    return CREATECOLOR(236, 231, 227, 1);
}

+ (UIColor *)getColorWithR252G115B108 {
    return CREATECOLOR(252, 115, 108, 1);
}

+ (UIColor *)getColorWithR176G163B150 {
    return CREATECOLOR(176, 163, 150, 1);
}

+ (UIColor *)getColorWithR250G50B50 {
    return CREATECOLOR(250, 50, 50, 1);
}

+ (UIColor *)getColorWithR157G21B30 {
    return CREATECOLOR(157, 21, 30, 1);
}

+ (UIColor *)getColorWithR189G189B189 {
    return CREATECOLOR(189, 189, 189, 1);
}

// 导航栏
+ (UIColor *)getColorWithR249G249B249 {
    return CREATECOLOR(249, 249, 249, 1);
}

// 页面背景
+ (UIColor *)getColorWithR245G245B245 {
    return CREATECOLOR(245, 245, 245, 1);
}

// 条目按下状态
+ (UIColor *)getColorWithR236G236B236 {
    return CREATECOLOR(236, 236, 236, 1);
}

+ (UIColor *)getColorWithR209G209B209 {
    return CREATECOLOR(209, 209, 209, 1);
}

// 输入框中间的间隔线
+ (UIColor *)getColorWithR230G230B230 {
    return CREATECOLOR(230, 230, 230, 1);
}

// 通知栏背景色
+ (UIColor *)getColorWithR229G232B239 {
    return CREATECOLOR(229, 232, 239, 1);
}

//个人信息录入/联系人信息录入  顶部View背景色
+ (UIColor *)getColorWithR234G234B234 {
    return CREATECOLOR(234, 234, 234, 1);
}

//红框按钮高亮的颜色值
+ (UIColor *)getColorWithR221G115B120 {
    return CREATECOLOR(221, 115, 120, 1);
}

+ (UIColor *)getColorWithR211G218B226 {
    return CREATECOLOR(211, 218, 226, 1);
}

+ (UIColor *)getColorWithR223G224B224 {
    return CREATECOLOR(223, 224, 224, 1);
}

/// ========================================
//每个页面的背景色
+ (UIColor *)viewControllerBackgroundColor {
    return CREATECOLOR(242, 244, 244, 1);
}

// 导航栏背景色
+ (UIColor *)navigateBarBackgroudColor {
    return CREATECOLOR(3, 160, 76, 1);
}

// 导航栏标题文字颜色
+ (UIColor *)navigateBarTitleColor {
    return CREATECOLOR(233, 241, 243, 1);
}

// 账户view背景颜色
+ (UIColor *)accoutViewBackgroudColor {
    return CREATECOLOR(76, 169, 156, 0.9);
}

// 表单左边提示文字颜色(未编辑状态下)
+ (UIColor *)formLeftTitleNormalColor {
    return CREATECOLOR(25, 46, 84, 1);
}

// 表单左边提示文字颜色(编辑状态下)
+ (UIColor *)formLeftTitleEditingColor {
    return CREATECOLOR(113, 127, 165, 1);
}

// 表单编辑框 placeholder 文字颜色
+ (UIColor *)formTextFieldPlaceholderColor {
    return CREATECOLOR(190, 201, 212, 1);
}

// 消息气泡 等突出强调信息的颜色
+ (UIColor *)messageBubbleColor {
    return CREATECOLOR(198, 22, 30, 1);
}

// 可点击文字颜色
+ (UIColor *)superLinkTitleColor {
   return CREATECOLOR(4, 110, 208, 1);
}

// 质检通过 颜色
+ (UIColor *)QACheckSuccessedColor {
    return CREATECOLOR(69, 170, 156, 1);
}

// 设置页面 条目颜色
+ (UIColor *)settingRightTitleColor {
    return CREATECOLOR(145, 162, 183, 1);
}

/*
 红色背景 的按钮
 */
// 按钮标题文字颜色(正常状态)
+ (UIColor *)button1TitleNormalColor {
    return CREATECOLOR(255, 255, 255, 1);
}

// 按钮标题文字颜色(按下状态)
+ (UIColor *)button1TitleHighlightColor {
    return CREATECOLOR(255, 255, 255, 1);
}

// 按钮标题文字颜色(不可用状态)
+ (UIColor *)button1TitleDisableColor {
    return CREATECOLOR(255, 255, 255, 1);
}

// 按钮背景颜色(正常状态)
+ (UIColor *)button1BackgroundNormalColor {
    return CREATECOLOR(198, 22, 30, 1);
}

// 按钮背景颜色(按下状态)
+ (UIColor *)button1BackgroundHighlightColor {
    return CREATECOLOR(159, 18, 24, 1);
}

// 按钮背景颜色(不可用状态)
+ (UIColor *)button1BackgroundDisableColor {
    return CREATECOLOR(198, 22, 30, 1);
}

/*
 绿色背景 的按钮
 */
// 按钮标题文字颜色(正常状态)
+ (UIColor *)button2TitleNormalColor {
    return CREATECOLOR(255, 255, 255, 1);
}

// 按钮标题文字颜色(按下状态)
+ (UIColor *)button2TitleHighlightColor {
    return CREATECOLOR(174, 200, 196, 1);
}

// 按钮标题文字颜色(不可用状态)
+ (UIColor *)button2TitleDisableColor {
    return CREATECOLOR(141, 198, 189, 1);
}

// 按钮背景颜色(正常状态)
+ (UIColor *)button2BackgroundNormalColor {
    return CREATECOLOR(69, 170, 156, 1);
}

// 按钮背景颜色(按下状态)
+ (UIColor *)button2BackgroundHighlightColor {
    return CREATECOLOR(53, 133, 122, 1);
}

// 按钮背景颜色(不可用状态)
+ (UIColor *)button2BackgroundDisableColor {
    return CREATECOLOR(69, 170, 156, 1);
}



//联系人信息 按钮文字的颜色
+ (UIColor *)linkManButtonTextColor {
    return CREATECOLOR(0, 108, 93, 1);
}
//联系人信息 钮点击后的背景颜色
+ (UIColor *)linkManButtonSelecetBackgroundColor {
    return CREATECOLOR(248, 248, 227, 1);
}
//联系人信息 按钮未点击后的背景颜色
+ (UIColor *)linkManButtonBackgroundColor {
     return CREATECOLOR(243, 252, 242, 1);
}










+ (UIColor *)get_1_Color{
    return CREATECOLOR(89, 89, 89, 1);
}

+ (UIColor *)get_2_Color{
    return CREATECOLOR(115, 115, 115, 1);
}

//+ (UIColor *)get_3_Color{
//    return CREATECOLOR(128, 128, 128, 1);
//}

+ (UIColor *)get_3_Color{
    return CREATECOLOR(178, 178, 178, 1);
}
+ (UIColor *)get_4_Color{
    return CREATECOLOR(203, 203, 203, 1);
}

+ (UIColor *)get_5_Color{
    return CREATECOLOR(230, 230, 230, 1);
}

+ (UIColor *)get_6_Color{
    return CREATECOLOR(243, 243, 243, 1);
}

+ (UIColor *)get_7_Color{
    return CREATECOLOR(250, 250, 250, 1);
}

+ (UIColor *)get_8_Color{
    return CREATECOLOR(255, 255, 255, 1);
}

+ (UIColor *)get_9_Color{
    return CREATECOLOR(219, 183, 107, 1);
}

+ (UIColor *)get_10_Color{
    return CREATECOLOR(0, 150, 255, 1);
}

+ (UIColor *)get_11_Color{
    return CREATECOLOR(230, 0, 0, 1);
}

+ (UIColor *)get_12_Color{
    return CREATECOLOR(0, 191, 126, 1);
}





@end
