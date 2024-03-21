//
//  CTTextField.h
//  CTKeyboard
//
//  Created by wangyingjie on 15/7/28.
//  Copyright (c) 2015年 Keyboard. All rights reserved.
//
//  定义textField 重新定制代理 使用自定义键盘时 需要使用新定义的CTTextField
//

#define ShareKeyboard [CTKeyboardView sharedInstance]

#import <UIKit/UIKit.h>
#import "CTKeyboardType.h"

@class CTKeyboardView;
@class CTTextField;
//CTTextField的代理 使用方法与UITextField的代理一致
@protocol CTTextFieldDelegate <NSObject>

@optional
/** 是否允许编辑 点击编辑框时触发 */
- (BOOL)CTTextFieldShouldBeginEditing:(CTTextField *)textField;

/** 开始编辑 点击编辑框 并且被允许编辑时触发 */
- (void)CTTextFieldDidBeginEditing:(CTTextField *)textField;

/** 是否结束编辑  焦点将要从当前编辑框离开时 即用户点击了另一个编辑框 或 结束编辑收起键盘时 */
- (BOOL)CTTextFieldShouldEndEditing:(CTTextField *)textField;

/** 焦点已离开编辑框 结束编辑 */
- (void)CTTextFieldDidEndEditing:(CTTextField *)textField;

/** 
 *  是否允许改变编辑框内的内容 从指定的位置增加或删减一个字符
 *  range:  location为光标当前的位置  lenght为1时是删减字符 为0时是输入字符
 *  string: 新输入的字符
 */
- (BOOL)CTTextField:(CTTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/** 是否允许删除编辑框上的全部内容  点击编辑框上的删除按钮时 */
- (BOOL)CTTextFieldShouldClear:(CTTextField *)textField;

/** 键盘上的确认键按钮 */
- (BOOL)CTTextFieldShouldReturn:(CTTextField *)textField;

@end



@interface CTTextField : UITextField

@property (nonatomic, assign) id <CTTextFieldDelegate> textFieldDelegate;       /**< 代理 */
@property (nonatomic, assign) KeyboardType keyboardtype;                        /**< 键盘类型 */
@property (nonatomic, assign) KeyboardCharsLayoutType charsLayoutType;          /**< 键盘上字符的布局方式 */
@property (nonatomic, strong) NSString * returnName;                            /**< 确认按钮 显示的标题 默认显示"确认"*/


/**
 *****  重要 ***
 *
 *  使用自定义键盘必须调此函数开启自定义键盘的相关配置
 *  不调此函数则使用系统原生的UITextField相关代理
 */
//- (void)openCTKeyboardViewConfig;

/** 
 *  键盘上点击字符将数据传递的函数
 *  text: 输入的字符  为nil时为删除
 *  isInput: YES代表输入  NO代表删除
 */
- (void)clickTheKeyboards:(NSString *)text isInput:(BOOL)isInput;

/**
 *  点击完成键位
 */
- (void)clickFinishKey;

@end
