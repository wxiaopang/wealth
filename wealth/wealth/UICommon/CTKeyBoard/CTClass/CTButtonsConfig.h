//
//  CTButtonsConfig.h
//  CTKeyboard
//
//  Created by wangyingjie on 15/8/12.
//  Copyright (c) 2015年 Keyboard. All rights reserved.
//
//  键盘上按钮设置  标记 和 UI
//

#import <Foundation/Foundation.h>
#import "CTKeyboardView.h"
#import "CTKeyboardType.h"

@interface CTButtonsConfig : NSObject

/**
 *  键盘上按钮的配置
 *  keyboardView：键盘主页面
 *  layoutType：  键盘上按钮的分布类型  0为33键位(即字符字母键盘)   1为14键位(即为数字键盘)
 */
+ (void)keyboardButtonsConfig:(CTKeyboardView *)keyboardView buttonsLayoutType:(NSInteger)layoutType random:(KeyboardCharsLayoutType)random;

@end
