//
//  UIFont+TextFont.h
//  wealth
//
//  Created by wangyingjie on 15/9/12.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (TextFont)



//细体汉字字体
+ (UIFont *)get_A24_CN_NOR_Font;
+ (UIFont *)get_B26_CN_NOR_Font;
+ (UIFont *)get_C30_CN_NOR_Font;
+ (UIFont *)get_D32_CN_NOR_Font;
+ (UIFont *)get_E36_CN_NOR_Font;
+ (UIFont *)get_F40_CN_NOR_Font;
+ (UIFont *)get_G60_CN_NOR_Font;
+ (UIFont *)get_H72_CN_NOR_Font;


//加粗汉字字体
+ (UIFont *)get_A24_CN_BOL_Font;
+ (UIFont *)get_B26_CN_BOL_Font;
+ (UIFont *)get_C30_CN_BOL_Font;
+ (UIFont *)get_D32_CN_BOL_Font;
+ (UIFont *)get_E36_CN_BOL_Font;
+ (UIFont *)get_F40_CN_BOL_Font;
+ (UIFont *)get_G60_CN_BOL_Font;
+ (UIFont *)get_H72_CN_BOL_Font;



//细体字母数字字体
+ (UIFont *)get_A24_EN_NOR_Font;
+ (UIFont *)get_B26_EN_NOR_Font;
+ (UIFont *)get_C30_EN_NOR_Font;
+ (UIFont *)get_D32_EN_NOR_Font;
+ (UIFont *)get_E36_EN_NOR_Font;
+ (UIFont *)get_F40_EN_NOR_Font;
+ (UIFont *)get_G60_EN_NOR_Font;
+ (UIFont *)get_H72_EN_NOR_Font;



//粗体字母数字字体
+ (UIFont *)get_A24_EN_BOL_Font;
+ (UIFont *)get_B26_EN_BOL_Font;
+ (UIFont *)get_C30_EN_BOL_Font;
+ (UIFont *)get_D32_EN_BOL_Font;
+ (UIFont *)get_E36_EN_BOL_Font;
+ (UIFont *)get_F40_EN_BOL_Font;
+ (UIFont *)get_G60_EN_BOL_Font;
+ (UIFont *)get_H72_EN_BOL_Font;



//公共用字体可以集体做处理
+ (UIFont *)get_CN_NOR_FontWithFont:(CGFloat)font;
+ (UIFont *)get_CN_BOL_FontWithFont:(CGFloat)font;
+ (UIFont *)get_EN_NOR_FontWithFont:(CGFloat)font;
+ (UIFont *)get_EN_BOL_FontWithFont:(CGFloat)font;


+ (UIFont *)getOtherFont:(CGFloat)fontNumber;
+ (UIFont *)getOtherBoldFont:(CGFloat)fontNumber;

@end
