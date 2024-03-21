//
//  CTKeyboardView.h
//  CTKeyboard
//
//  Created by wangyingjie on 15/7/27.
//  Copyright (c) 2015年 Keyboard. All rights reserved.
//
//  custom keyboard view 自定义键盘
//

#define MaxButtnCount   33      //所以类型键盘里 最多会出现的按钮个数
#define MinButtnCount   14      //所以类型键盘里 至少会出现的按钮个数

#define BaseButtonTag   500     //按钮tag的基数 避免出现tag为0的情况

#import <UIKit/UIKit.h>
#import "CTKeyboardType.h"
#import "UIButton+Params.h"

@class CTTextField;
@interface CTKeyboardView : UIView

@property (nonatomic, assign) KeyboardType keyboardType;                    /**< 键盘类型 */
@property (nonatomic, assign) KeyboardCharsLayoutType charsLayoutType;      /**< 键盘上字符的布局方式 */
@property (nonatomic, strong) CTTextField * customTextField;                /**< 当前与键盘直接关联的Textfield */
@property (nonatomic, assign, readonly) BOOL letterType;                    /**< 字母类型 大小写 */
@property (nonatomic, strong) NSString * returnName;                        /**< 确认按钮 显示的标题 默认显示"确认" */
@property (nonatomic, assign) BOOL closeVoice;                              /**< 是否关闭音效 默认NO:开启*/
@property (nonatomic, assign) BOOL closeAnimation;                          /**< 是否关闭键盘类型切换动效 默认NO:开启*/

/** 创建键盘单利对象 */
+ (CTKeyboardView *)sharedInstance;

@end
