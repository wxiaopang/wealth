//
//  CTKeyboardType.h
//  CTKeyboard
//
//  Created by wangyingjie on 15/7/30.
//  Copyright (c) 2015年 Keyboard. All rights reserved.
//
//  键盘可设置类型
//

#import <Foundation/Foundation.h>

/** 键盘的UI类型  布局分为字符和数字两大类 */
typedef NS_ENUM (NSInteger, KeyboardType)
{
    //字母/字符布局  UI分布一样 内容变更
    KeyboardTypeDefault,                        /**< 默认键盘 即字母键盘 可切换到数字和特殊字符 */
    KeyboardTypeSymbol,                         /**< 符号键盘 */
    KeyboardTypeSymbolAndNumber,                /**< 数字和符号键盘 */
    
    //数字布局 UI分布一致
    KeyboardTypeNumberAndChangeable,            /**< 纯数字并且可切换键盘 */
    KeyboardTypeNumberAndUnchangeable,          /**< 纯数字并且不可切换键盘 */
    KeyboardTypeNumberIdCard,                   /**< 身份证键盘 即将KeyboardTypeNumberAndUnchangeable中的"."换成"X" */
};

/** 键盘上的按钮类型 */
typedef NS_ENUM (NSInteger, KeyboardButtonType)
{
    KeyboardButtonTypeDefault,                  /**< 默认类型 所有可输入编辑框内容的按钮 */
    KeyboardButtonTypeChangeNumber,             /**< 切换到数字键盘按钮 */
    KeyboardButtonTypeChangeLetter,             /**< 切换到字母键盘按钮 */
    KeyboardButtonTypeChangeSymbol,             /**< 切换到符号键盘按钮 */
    KeyboardButtonTypeCapital,                  /**< 大小写切换按钮*/
    KeyboardButtonTypeMore,                     /**< 更多符号按钮 */
    KeyboardButtonTypeBack,                     /**< 返回按钮 */
    KeyboardButtonTypeDelete,                   /**< 删除按钮 */
    KeyboardButtonTypeSpace,                    /**< 空格按钮 */
    KeyboardButtonTypeExit,                     /**< 退出键盘按钮 */
    KeyboardButtonTypeFinish,                   /**< 完成按钮 可定义成下一步、确认等等 */
    
    KeyboardButtonTypeX,                        /**< 输入身份证存在X */
};

/** 键盘字符的布局方式 固定或者随机布局 */
typedef NS_ENUM(NSInteger, KeyboardCharsLayoutType)
{
    KeyboardCharsLayoutTypeDefault,            /**< 键盘按钮默认布局  固定方式 */
    KeyboardCharsLayoutTypeRandom,             /**< 键盘按钮默认布局  随机方式  每次键盘弹出 字符的位置随机 */
};

/** 字母大小写类型 */
typedef NS_ENUM(NSInteger, KeyboardLetterType)
{
    KeyboardLetterTypeCapital,            /**< 默认大写字母 */
    KeyboardLetterTypeLower,              /**< 小写字母 */
};

@interface CTKeyboardType : NSObject

@end
