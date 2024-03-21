//
//  UIColor+Theme.h
//  wealth
//
//  Created by wangyingjie on 15/2/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (Theme)

+ (UIColor *)colorWithHex:(NSInteger)hex;

+ (UIColor*)colorWithHexString:(NSString*)hex;

+ (UIColor *)getColorWithR236G231B227;
//
//+ (UIColor *)getColorWithR252G115B108;
//
//+ (UIColor *)getColorWithR176G163B150;
//
//// 未读消息气泡
//+ (UIColor *)getColorWithR250G50B50;
//
//+ (UIColor *)getColorWithR157G21B30;
//
//+ (UIColor *)getColorWithR189G189B189;
//
//// 导航栏背景
//+ (UIColor *)getColorWithR249G249B249;
//
//// 页面背景
//+ (UIColor *)getColorWithR245G245B245;

// 条目按下状态
+ (UIColor *)getColorWithR236G236B236;

// 线的颜色
+ (UIColor *)getColorWithR209G209B209;

// 输入框中间的间隔线
+ (UIColor *)getColorWithR230G230B230;
//
// 通知栏背景色
+ (UIColor *)getColorWithR229G232B239;
//
////个人信息录入/联系人信息录入  顶部View背景色
//+ (UIColor *)getColorWithR234G234B234;

//红框按钮高亮的颜色值
+ (UIColor *)getColorWithR221G115B120;

+ (UIColor *)getColorWithR211G218B226;

+ (UIColor *)getColorWithR223G224B224;
//
/// ==================================
//每个页面的背景色
+ (UIColor *)viewControllerBackgroundColor;

// 导航栏背景色
+ (UIColor *)navigateBarBackgroudColor;

// 导航栏标题文字颜色
+ (UIColor *)navigateBarTitleColor;

// 账户view背景颜色
+ (UIColor *)accoutViewBackgroudColor;

// 表单左边提示文字颜色(未编辑状态下)
+ (UIColor *)formLeftTitleNormalColor;

// 表单左边提示文字颜色(编辑状态下)
+ (UIColor *)formLeftTitleEditingColor;

// 表单编辑框 placeholder 文字颜色
+ (UIColor *)formTextFieldPlaceholderColor;

// 消息气泡 等突出强调信息的颜色
+ (UIColor *)messageBubbleColor;
//
//// 可点击文字颜色
//+ (UIColor *)superLinkTitleColor;

// 质检通过 颜色
+ (UIColor *)QACheckSuccessedColor;
//
//// 设置页面 条目颜色
//+ (UIColor *)settingRightTitleColor;

/*
    红色背景 的按钮
 */
// 按钮标题文字颜色(正常状态)
+ (UIColor *)button1TitleNormalColor;

// 按钮标题文字颜色(按下状态)
+ (UIColor *)button1TitleHighlightColor;

// 按钮标题文字颜色(不可用状态)
+ (UIColor *)button1TitleDisableColor;

// 按钮背景颜色(正常状态)
+ (UIColor *)button1BackgroundNormalColor;

// 按钮背景颜色(按下状态)
+ (UIColor *)button1BackgroundHighlightColor;

// 按钮背景颜色(不可用状态)
+ (UIColor *)button1BackgroundDisableColor;

/*
 绿色背景 的按钮
 */
// 按钮标题文字颜色(正常状态)
+ (UIColor *)button2TitleNormalColor;

// 按钮标题文字颜色(按下状态)
+ (UIColor *)button2TitleHighlightColor;

// 按钮标题文字颜色(不可用状态)
+ (UIColor *)button2TitleDisableColor;

// 按钮背景颜色(正常状态)
+ (UIColor *)button2BackgroundNormalColor;

// 按钮背景颜色(按下状态)
+ (UIColor *)button2BackgroundHighlightColor;

// 按钮背景颜色(不可用状态)
+ (UIColor *)button2BackgroundDisableColor;



+ (UIColor *)get_1_Color;
+ (UIColor *)get_2_Color;
+ (UIColor *)get_3_Color;
+ (UIColor *)get_4_Color;
+ (UIColor *)get_5_Color;
+ (UIColor *)get_6_Color;
+ (UIColor *)get_7_Color;
+ (UIColor *)get_8_Color;
+ (UIColor *)get_9_Color;
+ (UIColor *)get_10_Color;
+ (UIColor *)get_11_Color;
+ (UIColor *)get_12_Color;
//+ (UIColor *)get_13_Color;







@end
