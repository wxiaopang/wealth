//
//  CTButtonsFrame.m
//  CTKeyboard
//
//  Created by wangyingjie on 15/8/12.
//  Copyright (c) 2015年 Keyboard. All rights reserved.
//

#import "CTButtonsFrame.h"

#define KeyboardWidth   [UIScreen mainScreen].bounds.size.width     //键盘视图的总宽度
#define KeyboardHeight  216.0                                       //键盘视图的总高度

#define ButtonHeight    47.0    //按钮的高度  高度固定 宽度根据屏宽决定
#define RowSpace        5.0     //按钮的行间距
#define BoundsSpace     5.0     //临视图边界的按钮到边界的间隔


//字母 数字 字符等按钮的宽度 (33键位中使用)
#define FirstButtonTypeWidth ((KeyboardWidth - BoundsSpace*2 - RowSpace*9)/10.0)
//第三第四行中如大小写 删除 符号切换等按钮的宽度 (33键位中使用)
#define SecondButtonTypeWidth ((KeyboardWidth - (FirstButtonTypeWidth * 7) - RowSpace * 8 - BoundsSpace * 2)/2 - 2)


@implementation CTButtonsFrame

/**
 *  键盘上按钮的配置
 *  keyboardView：键盘主页面
 *  layoutType：  键盘上按钮的分布类型  0为33键位(即字符字母键盘)   1为14键位(即为数字键盘)
 */
+ (void)keyboardButtonsFrame:(CTKeyboardView *)keyboardView buttonsLayoutType:(NSInteger)layoutType
{
    if (layoutType == 1) {
        //19键位(即为数字键盘)    按钮配置
        [self numberKeyboardFrame:keyboardView];
    } else {
        //33键位(即字符字母键盘)  按钮配置
        [self characterKeyboardFrame:keyboardView];
    }
}

#pragma mark -
#pragma mark - 33键位布局的按钮配置 (字符字母键盘)
+ (void)characterKeyboardFrame:(CTKeyboardView *)keyboardView
{
    for (int i = 0; i < MaxButtnCount; i ++) {
        UIButton * button = (UIButton *)[keyboardView viewWithTag:(BaseButtonTag + i)];
        /*
         *  设置按钮的frame
         */
        
        CGFloat x = 0.0;          //按钮的x坐标
        CGFloat y = 0.0;          //按钮的y坐标
        CGFloat width = 0.0;      //按钮的宽度
        
        width = FirstButtonTypeWidth;
        
        if (i < 10) {
            //第一行 10个按钮
            x = BoundsSpace + i *(width + RowSpace);
            y = BoundsSpace + 2;
            
        } else if (i >= 10 && i < 19) {
            //第二行 9个按钮
            x = BoundsSpace + (width + RowSpace) / 2 + (i % 10) * (width + RowSpace);
            y = BoundsSpace + 2 + (ButtonHeight + RowSpace);
            
        } else if (i >= 19 && i < 28) {
            //第三行 9个按钮 前后两个比其他要宽
            if (i == 19) {
                x = BoundsSpace;
                width = SecondButtonTypeWidth;
                
            } else if (i == 27) {
                width = SecondButtonTypeWidth;
                UIButton * foreButton = (UIButton *)[keyboardView viewWithTag:BaseButtonTag + (i-1)];
                x = foreButton.frame.origin.x + foreButton.frame.size.width + RowSpace + 2;
                
            } else {
                //获取同行上前一个按钮的frame
                UIButton * foreButton = (UIButton *)[keyboardView viewWithTag:BaseButtonTag + (i-1)];
                x = foreButton.frame.origin.x + foreButton.frame.size.width + RowSpace;
                if (i == 20) {
                    x += 2;
                }
            }
            
            y = BoundsSpace + 2 + 2 * (ButtonHeight + RowSpace);
            
        } else {
            //第四行
            //获取同行上前一个按钮的frame
            UIButton * foreButton = (UIButton *)[keyboardView viewWithTag:BaseButtonTag + (i-1)];
            x = foreButton.frame.origin.x + foreButton.frame.size.width + (RowSpace + 2);
            y = BoundsSpace + 2 + 3 * (ButtonHeight + RowSpace);
            
            if (i == 28 ) {
                //第一、二个 数字键盘切换键
                width = SecondButtonTypeWidth;
                x = BoundsSpace;
            } else if (i == 29) {
                //第二个 符号键盘切换键
                width = SecondButtonTypeWidth;
            } else if (i == 30) {
                //第三个 空格键
                width = KeyboardWidth - (SecondButtonTypeWidth + RowSpace + 2) * 4 - BoundsSpace * 2 - 15;
            } else if (i == 31) {
                //第四个 退出键盘键
                width = SecondButtonTypeWidth - 5 ;
            } else {
                //最后一个 完成建
                width = SecondButtonTypeWidth + 20;
            }
        }
        
        button.frame = CGRectMake(x, y, width, ButtonHeight);

    }
}

#pragma mark -
#pragma mark - 14键位布局的按钮配置 (数字键盘)
+ (void)numberKeyboardFrame:(CTKeyboardView *)keyboardView
{
    for (int i = 0; i < MaxButtnCount; i ++) {
        UIButton * button = (UIButton *)[keyboardView viewWithTag:(BaseButtonTag + i)];
        
        if (i <= (MinButtnCount-1)) {
            CGFloat x = 0.0;          //按钮的x坐标
            CGFloat y = 0.0;          //按钮的y坐标
            CGFloat width = 0.0;      //按钮的宽度
            CGFloat height = 0.0;     //按钮的宽度
            
            height = ButtonHeight;
            //右边2个按钮的宽度为总宽度的1/4 数字键的总宽为总视图宽度的3/4
            width = KeyboardWidth/4;
            
            if (i < 12) {
                //数字键区域有4行 每一行有3个键
                int row = i / 3;
                y = BoundsSpace + 2 + row * (ButtonHeight + RowSpace);
                width = (KeyboardWidth - width - BoundsSpace*2 - RowSpace*3)/3;
                
                if ( i == 0 || i == 3 || i == 6 || i == 9) {
                    //每一行的第一个
                    x = BoundsSpace;
                } else {
                    UIButton * foreButton = (UIButton *)[keyboardView viewWithTag:BaseButtonTag + (i-1)];
                    x = foreButton.frame.origin.x + foreButton.frame.size.width + RowSpace;
                }
                
            } else {
                x = KeyboardWidth - width - RowSpace;
                
                if (i == 12) {
                    y = BoundsSpace + 2;
                } else {
                    UIButton * foreButton = (UIButton *)[keyboardView viewWithTag:BaseButtonTag + (i-1)];
                    y = foreButton.frame.origin.y + foreButton.frame.size.height + RowSpace;
                }
                
                height = (KeyboardHeight - RowSpace - BoundsSpace*2 - 2)/2;
            }
            
            button.frame = CGRectMake(x, y, width, height);
        }
    }
}

@end
