//
//  UIFont+TextFont.m
//  wealth
//
//  Created by wangyingjie on 15/9/12.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UIFont+TextFont.h"

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end

@implementation UIFont (TextFont)

//细体汉字字体

+ (UIFont *)get_A24_CN_NOR_Font{
    return [UIFont get_CN_NOR_FontWithFont:24];
}
+ (UIFont *)get_B26_CN_NOR_Font{
    return [UIFont get_CN_NOR_FontWithFont:26];
}
+ (UIFont *)get_C30_CN_NOR_Font{
    return [UIFont get_CN_NOR_FontWithFont:30];
}
+ (UIFont *)get_D32_CN_NOR_Font{
    return [UIFont get_CN_NOR_FontWithFont:32];
}
+ (UIFont *)get_E36_CN_NOR_Font{
    return [UIFont get_CN_NOR_FontWithFont:36];
}
+ (UIFont *)get_F40_CN_NOR_Font{
    return [UIFont get_CN_NOR_FontWithFont:40];
}
+ (UIFont *)get_G60_CN_NOR_Font{
    return [UIFont get_CN_NOR_FontWithFont:60];
}
+ (UIFont *)get_H72_CN_NOR_Font{
    return [UIFont get_CN_NOR_FontWithFont:72];
}


//加粗汉字字体
+ (UIFont *)get_A24_CN_BOL_Font{
    return [UIFont get_CN_BOL_FontWithFont:24];
}
+ (UIFont *)get_B26_CN_BOL_Font{
    return [UIFont get_CN_BOL_FontWithFont:26];
}
+ (UIFont *)get_C30_CN_BOL_Font{
    return [UIFont get_CN_BOL_FontWithFont:30];
}
+ (UIFont *)get_D32_CN_BOL_Font{
    return [UIFont get_CN_BOL_FontWithFont:32];
}
+ (UIFont *)get_E36_CN_BOL_Font{
    return [UIFont get_CN_BOL_FontWithFont:36];
}
+ (UIFont *)get_F40_CN_BOL_Font{
    return [UIFont get_CN_BOL_FontWithFont:40];
}
+ (UIFont *)get_G60_CN_BOL_Font{
    return [UIFont get_CN_BOL_FontWithFont:60];
}
+ (UIFont *)get_H72_CN_BOL_Font{
    return [UIFont get_CN_BOL_FontWithFont:72];
}




//细体字母数字字体
+ (UIFont *)get_A24_EN_NOR_Font{
    return [UIFont get_EN_NOR_FontWithFont:24];
}
+ (UIFont *)get_B26_EN_NOR_Font{
    return [UIFont get_EN_NOR_FontWithFont:26];
}
+ (UIFont *)get_C30_EN_NOR_Font{
    return [UIFont get_EN_NOR_FontWithFont:30];
}
+ (UIFont *)get_D32_EN_NOR_Font{
    return [UIFont get_EN_NOR_FontWithFont:32];
}
+ (UIFont *)get_E36_EN_NOR_Font{
    return [UIFont get_EN_NOR_FontWithFont:36];
}
+ (UIFont *)get_F40_EN_NOR_Font{
    return [UIFont get_EN_NOR_FontWithFont:40];
}
+ (UIFont *)get_G60_EN_NOR_Font{
    return [UIFont get_EN_NOR_FontWithFont:60];
}
+ (UIFont *)get_H72_EN_NOR_Font{
    return [UIFont get_EN_NOR_FontWithFont:72];
}




//粗体字母数字字体
+ (UIFont *)get_A24_EN_BOL_Font{
    return [UIFont get_EN_BOL_FontWithFont:24];
}
+ (UIFont *)get_B26_EN_BOL_Font{
    return [UIFont get_EN_BOL_FontWithFont:26];
}
+ (UIFont *)get_C30_EN_BOL_Font{
    return [UIFont get_EN_BOL_FontWithFont:30];
}
+ (UIFont *)get_D32_EN_BOL_Font{
    return [UIFont get_EN_BOL_FontWithFont:32];
}
+ (UIFont *)get_E36_EN_BOL_Font{
    return [UIFont get_EN_BOL_FontWithFont:36];
}
+ (UIFont *)get_F40_EN_BOL_Font{
    return [UIFont get_EN_BOL_FontWithFont:40];
}
+ (UIFont *)get_G60_EN_BOL_Font{
    return [UIFont get_EN_BOL_FontWithFont:60];
}
+ (UIFont *)get_H72_EN_BOL_Font{
    return [UIFont get_EN_BOL_FontWithFont:72];
}




//公共用字体可以集体做处理
+ (UIFont *)get_CN_NOR_FontWithFont:(CGFloat)font{
    return FONT_CN_NORMAL(font);
}

+ (UIFont *)get_CN_BOL_FontWithFont:(CGFloat)font{
    return FONT_CN_BOLD(font);
}

+ (UIFont *)get_EN_NOR_FontWithFont:(CGFloat)font{
    return FONT_EN_NORMAL(font);
}

+ (UIFont *)get_EN_BOL_FontWithFont:(CGFloat)font{
    return FONT_EN_BOLD(font);
}




+ (UIFont *)getOtherFont:(CGFloat)fontNumber{
    return [UIFont systemFontOfSize:fontNumber];
}

+ (UIFont *)getOtherBoldFont:(CGFloat)fontNumber{
    return [UIFont boldSystemFontOfSize:fontNumber];
}

@end
