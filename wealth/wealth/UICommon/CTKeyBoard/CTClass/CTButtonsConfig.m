//
//  CTButtonsConfig.m
//  CTKeyboard
//
//  Created by wangyingjie on 15/8/12.
//  Copyright (c) 2015年 Keyboard. All rights reserved.
//

#import "CTButtonsConfig.h"

@implementation CTButtonsConfig

/**
 *  键盘上按钮的配置
 *  keyboardView：键盘主页面
 *  layoutType：  键盘上按钮的分布类型  0为33键位(即字符字母键盘)   1为14键位(即为数字键盘)
 */
+ (void)keyboardButtonsConfig:(CTKeyboardView *)keyboardView buttonsLayoutType:(NSInteger)layoutType random:(KeyboardCharsLayoutType)random
{
    if (layoutType == 1) {
        //14键位(即为数字键盘)    按钮配置
        [self numberKeyboardCongif:keyboardView random:random];
    } else {
        //33键位(即字符字母键盘)  按钮配置
        [self characterKeyboardCongif:keyboardView random:random];
    }
}

#pragma mark - 
#pragma mark - 33键位布局的按钮配置 (字符字母键盘)
+ (void)characterKeyboardCongif:(CTKeyboardView *)keyboardView random:(KeyboardCharsLayoutType)random
{
    /*
     *  设置按钮 标题或图片
     */
    
    NSMutableArray * charaArray = nil;
    if (keyboardView.keyboardType == KeyboardTypeDefault) {
        //字母键盘字符
        charaArray = [NSMutableArray arrayWithObjects:@[@"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P",
                                                        @"A", @"S", @"D", @"F", @"G", @"H", @"J", @"K", @"L",
                                                        @"Z", @"X", @"C", @"V", @"B", @"N", @"M"],
                                                      @[@"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p",
                                                        @"a", @"s", @"d", @"f", @"g", @"h", @"j", @"k", @"l",
                                                        @"z", @"x", @"c", @"v", @"b", @"n", @"m"], nil];
        
        if (random != KeyboardCharsLayoutTypeDefault) {
            //将字符随机分布
            [charaArray enumerateObjectsUsingBlock:^(NSArray * array, NSUInteger idx, BOOL *stop) {
                //数组内部随机
                array = [array sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
                    return arc4random() % 2;
                }];
                
                //将随机分布后的数据替换掉原来的数据
                if (idx < array.count) {
                    [charaArray replaceObjectAtIndex:idx withObject:array];
                }
            }];
        }
        
    } else {
        //数字和特殊字符键盘字符
        charaArray = [NSMutableArray arrayWithObjects:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0",
                                                        @"~", @"!", @"@", @"#", @"$", @"%", @"^", @"&", @"*",
                                                        @"(", @")", @"_", @"+", @"{", @"}", @"|"],
                                                      @[@"<", @">", @"?", @"'", @",", @".", @"-", @"=", @"[", @"]",
                                                        @"\\", @";", @"`", @".", @"/", @"≠", @"∞", @"√", @"→",
                                                        @":", @"//", @"\"", @"￥", @"$", @"(", @")"], nil];
        
        if (random != KeyboardCharsLayoutTypeDefault) {
            //将字符随机分布 0-9字符单独随机 总体位置范围不变
            [charaArray enumerateObjectsUsingBlock:^(NSArray * array, NSUInteger idx, BOOL *stop) {
                if (idx == 0) {
                    //将数字和字符分开 随机后在放到一起
                    NSArray * numberArray = [array subarrayWithRange:NSMakeRange(0, 10)];
                    numberArray = [numberArray sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
                        return arc4random() % 2;
                    }];
                    
                    NSArray * charsArray = [array subarrayWithRange:NSMakeRange(10, (array.count-10))];
                    charsArray = [charsArray sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
                        return arc4random() % 2;
                    }];
                    
                    NSMutableArray * arrays = [[NSMutableArray alloc] initWithCapacity:2];
                    [arrays addObjectsFromArray:numberArray];
                    [arrays addObjectsFromArray:charsArray];
                    
                    //将随机分布后的数据替换掉原来的数据
                    [charaArray replaceObjectAtIndex:idx withObject:arrays];
                    
                } else {
                    //数组内部随机
                    array = [array sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
                        return arc4random() % 2;
                    }];
                    
                    //将随机分布后的数据替换掉原来的数据
                    [charaArray replaceObjectAtIndex:idx withObject:array];
                }
            }];
        }
    }
    
    
    for (int i = 0; i < MaxButtnCount; i ++) {
        UIButton * button = (UIButton *)[keyboardView viewWithTag:(BaseButtonTag + i)];
        NSString * iconName = nil;
        NSString * titleName = nil;
        
        if (button.hidden) {
            button.hidden = NO;
        }
        
        if (i == 19 || i >= 27) {
            //功能键位 19以及27之后的7个按钮
            switch (i) {
                case 19:
                    //类型切换
                    if (keyboardView.keyboardType == KeyboardTypeDefault) {
                        //字母时 为大小写按钮
                        iconName = @"capital";
                        button.selected = keyboardView.letterType;
                        button.otherTag = KeyboardButtonTypeCapital;
                        [button setImage:[UIImage imageNamed:@"capital_w"] forState:UIControlStateSelected];
                    } else if (keyboardView.keyboardType == KeyboardTypeSymbolAndNumber) {
                        //字母和符号时 为更多按钮
                        titleName = @"更多";
                        button.selected = NO;
                        button.otherTag = KeyboardButtonTypeMore;
                    } else if (keyboardView.keyboardType == KeyboardTypeSymbol) {
                        //纯符号时 为返回按钮
                        titleName = @"返回";
                        button.selected = NO;
                        button.otherTag = KeyboardButtonTypeBack;
                    }
                    break;
                    
                case 27:
                    //删除
                    button.otherTag = KeyboardButtonTypeDelete;
                    iconName = @"delete";
                    break;
                    
                case 28:
                    //数字切换
                    button.otherTag = KeyboardButtonTypeChangeNumber;
                    titleName = @"123";
                    break;
                    
                case 29:
                    //符号切换
                    if (keyboardView.keyboardType == KeyboardTypeDefault) {
                        button.otherTag = KeyboardButtonTypeChangeSymbol;
                        titleName = @"符";
                    } else {
                        button.otherTag = KeyboardButtonTypeChangeLetter;
                        titleName = @"ABC";
                    }
                    break;
                    
                case 30:
                    //空格
                    button.otherTag = KeyboardButtonTypeSpace;
                    iconName = @"blank";
                    [button setBackgroundImage:@"english_icon1_n" highlighted:@"english_icon1_p"];
                    break;
                    
                case 31:
                    //退出
                    button.otherTag = KeyboardButtonTypeExit;
                    iconName = @"keyboard_s";
                    break;
                    
                case 32:
                    //确定
                    button.otherTag = KeyboardButtonTypeFinish;
                    titleName = keyboardView.returnName;
                    break;
                default:
                    break;
            }
            
            button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            
            if (i != 30) {
                [button setBackgroundImage:@"english_icon_n" highlighted:@"english_icon1_p"];
            } else {
                [button setBackgroundImage:@"english_icon1_n" highlighted:@"english_icon1_p"];
            }
            
        } else {
            //字符键位
            if (i < 19) {
                if (keyboardView.keyboardType != KeyboardTypeSymbol) {
                    if (keyboardView.keyboardType == KeyboardTypeDefault && keyboardView.letterType == YES) {
                        titleName = charaArray[1][i];
                    } else {
                        titleName = charaArray[0][i];
                    }
                } else {
                    titleName = charaArray[1][i];
                }
            } else if (i > 19 && i < 27) {
                if (keyboardView.keyboardType != KeyboardTypeSymbol) {
                    if (keyboardView.keyboardType == KeyboardTypeDefault && keyboardView.letterType == YES) {
                        titleName = charaArray[1][i -1];
                    } else {
                        titleName = charaArray[0][i -1];
                    }
                } else {
                    titleName = charaArray[1][i -1];
                }
            }

            button.titleLabel.font = [UIFont systemFontOfSize:20.0f];
            [button setBackgroundImage:@"english_icon1_n" highlighted:@"english_icon1_p"];
            button.otherTag = KeyboardButtonTypeDefault;
        }
        
        [button setTitle:titleName forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark - 14键位布局的按钮配置 (数字键盘)
+ (void)numberKeyboardCongif:(CTKeyboardView *)keyboardView random:(KeyboardCharsLayoutType)random
{
    NSArray * charaArray = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    
    if (random != KeyboardCharsLayoutTypeDefault) {
        //将字符随机分布
        charaArray = [charaArray sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
            return arc4random() % 2;
        }];
    }
    
    for (int i = 0; i < MaxButtnCount; i ++) {
        UIButton * button = (UIButton *)[keyboardView viewWithTag:(BaseButtonTag + i)];
        NSString * iconName = nil;
        NSString * titleName = nil;
        
        if (i > (MinButtnCount-1)) {
            button.hidden = YES;
        } else {
            /*
             *  设置按钮 标题或图片
             */
            if (i < 12 ) {
                //数字键位
                if (i < 9) {
                    titleName = charaArray[i];
                    button.titleLabel.font = [UIFont systemFontOfSize:20.0f];
                    button.otherTag = KeyboardButtonTypeDefault;
                } else {
                    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                    if (i == 9) {
                        if (keyboardView.keyboardType == KeyboardTypeNumberAndChangeable) {
                            button.otherTag = KeyboardButtonTypeChangeLetter;
                            titleName = @"ABC";
                        } else if (keyboardView.keyboardType == KeyboardTypeNumberIdCard) {
                            button.otherTag = KeyboardButtonTypeX;
                            titleName = @"X";
                        } else {
                            button.otherTag = KeyboardButtonTypeDefault;
                            titleName = @".";
                        }
                    } else if (i == 10) {
                        //0~9
                        titleName = charaArray[i-1];
                        button.titleLabel.font = [UIFont systemFontOfSize:20.0f];
                        button.otherTag = KeyboardButtonTypeDefault;
                    } else {
                        if (keyboardView.keyboardType == KeyboardTypeNumberAndChangeable) {
                            //符号切换
                            button.otherTag = KeyboardButtonTypeChangeSymbol;
                            titleName = @"符";
                        } else {
                            //退出
                            button.otherTag = KeyboardButtonTypeExit;
                            iconName = @"keyboard_s";
                        }
                    }
                }
                
                [button setBackgroundImage:@"english_icon1_n" highlighted:@"english_icon1_p"];
                
            } else {
                //功能键位 19以及27之后的7个按钮
                
                if (i == 12) {
                    //删除
                    button.otherTag = KeyboardButtonTypeDelete;
                    iconName = @"delete";
                } else if (i == 13) {
                    //确定
                    button.otherTag = KeyboardButtonTypeFinish;
                    titleName = keyboardView.returnName;
                }
                
                button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                [button setBackgroundImage:@"english_icon_n" highlighted:@"english_icon1_p"];
            }
            [button setTitle:titleName forState:UIControlStateNormal];
            if ( iconName ) {
                [button setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
            }
        }
    }
}

@end
