//
//  CTKeyboardView.m
//  CTKeyboard
//
//  Created by wangyingjie on 15/7/27.
//  Copyright (c) 2015年 Keyboard. All rights reserved.
//

#import "CTKeyboardView.h"
#import "CTTextField.h"
//#import "UIButton+Params.h"
#import "CTButtonsConfig.h"
#import "CTButtonsFrame.h"

//#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


#define KeyboardWidth   [UIScreen mainScreen].bounds.size.width     //键盘视图的总宽度
#define KeyboardHeight  216.0                                       //键盘视图的总高度

#define ButtonHeight    47.0    //按钮的高度  高度固定 宽度根据屏宽决定
#define RowSpace        5.0     //按钮的行间距
#define BoundsSpace     5.0     //临视图边界的按钮到边界的间隔

//#define MaxButtnCount   33      //所以类型键盘里 最多会出现的按钮个数
//#define MinButtnCount   14      //所以类型键盘里 至少会出现的按钮个数
//#define BaseButtonTag   500     //按钮tag的基数 避免出现tag为0的情况

//字母 数字 字符等按钮的宽度 (33键位中使用)
#define FirstButtonTypeWidth ((KeyboardWidth - BoundsSpace*2 - RowSpace*9)/10.0)
//第三第四行中如大小写 删除 符号切换等按钮的宽度 (33键位中使用)
#define SecondButtonTypeWidth ((KeyboardWidth - (FirstButtonTypeWidth * 7) - RowSpace * 8 - BoundsSpace * 2)/2 - 2)


@interface CTKeyboardView ()
{
    SystemSoundID shake_sound_male_id;      /**< 音效ID*/
}

@end

@implementation CTKeyboardView

/** 创建键盘单利对象 */
+ (CTKeyboardView *)sharedInstance
{
    static CTKeyboardView * sharedKeyboard;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedKeyboard = [[CTKeyboardView alloc] init];
    });
    
    return sharedKeyboard;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    //不允许自定义键盘的frame
    frame = CGRectMake(0, 0, KeyboardWidth, KeyboardHeight);
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:203/255.0 green:204/255.0 blue:214/255.0 alpha:1];
        
        //创建33个按钮
        for (int i = 0; i < MaxButtnCount; i ++) {
            UIButton * button= [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = BaseButtonTag + i;
            button.backgroundColor = [UIColor clearColor];
            [button setTitleColor:[UIColor colorWithRed:44/255.0 green:45/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        
        //注册声音到系统
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Voice" ofType:@"wav"];
        if (path) {
            shake_sound_male_id = 0;
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        }
    }
    
    return self;
}

- (void)layout
{
    if (self.customTextField.returnName.length > 0 && self.customTextField.returnName != nil && ![self.customTextField.returnName isEqualToString:@""]) {
        self.returnName = self.customTextField.returnName;
    } else {
        self.returnName = @"确认";
    }

    
    //33键位 即字母或者特殊字符键盘
    if (self.keyboardType == KeyboardTypeDefault
        || self.keyboardType == KeyboardTypeSymbolAndNumber
        || self.keyboardType == KeyboardTypeSymbol) {
        //配置按钮样式
        [CTButtonsConfig keyboardButtonsConfig:self buttonsLayoutType:0 random:self.charsLayoutType];
        //设置按钮frame
        [CTButtonsFrame keyboardButtonsFrame:self buttonsLayoutType:0];
    }
    
    //14键位 即数字键盘
    else if (self.keyboardType == KeyboardTypeNumberAndChangeable
             || self.keyboardType == KeyboardTypeNumberAndUnchangeable
             || self.keyboardType == KeyboardTypeNumberIdCard) {
        //配置按钮样式
        [CTButtonsConfig keyboardButtonsConfig:self buttonsLayoutType:1 random:self.charsLayoutType];
        //设置按钮frame
        [CTButtonsFrame keyboardButtonsFrame:self buttonsLayoutType:1];
    }
    
}


#pragma mark -
#pragma mark - 设置键盘的类型
- (void)setKeyboardType:(KeyboardType)keyboardType
{
    _keyboardType = keyboardType;
    
    [self layout];
}

#pragma mark - 
#pragma mark - 键盘上的按钮事件
- (void)buttonAction:(UIButton *)sender
{
    //播放注册的声音
    if (self.closeVoice) {
        AudioServicesPlaySystemSound(shake_sound_male_id);
    }
    
    switch (sender.otherTag) {
        case KeyboardButtonTypeChangeNumber:
            //切换到数字键盘
            [self changeTypeViewWithAnimation];
            self.keyboardType = KeyboardTypeNumberAndChangeable;
            self.customTextField.keyboardtype = KeyboardTypeNumberAndChangeable;
            break;

        case KeyboardButtonTypeChangeLetter:
            //切换到字母键盘
            [self changeTypeViewWithAnimation];
            self.keyboardType = KeyboardTypeDefault;
            self.customTextField.keyboardtype = KeyboardTypeDefault;
            break;
            
        case KeyboardButtonTypeChangeSymbol:
            //切换到符号键盘
            [self changeTypeViewWithAnimation];
            self.keyboardType = KeyboardTypeSymbolAndNumber;
            self.customTextField.keyboardtype = KeyboardTypeSymbolAndNumber;
            break;
            
        case KeyboardButtonTypeCapital:
            //切换大小写
            [self changeTypeViewWithAnimation];
            _letterType = !_letterType;
            //刷新UI
            [self layout];
            break;
            
        case KeyboardButtonTypeMore:
            //切换到更多 符号键盘
            [self changeTypeViewWithAnimation];
            self.keyboardType = KeyboardTypeSymbol;
            self.customTextField.keyboardtype = KeyboardTypeSymbol;
            break;

        case KeyboardButtonTypeBack:
            //从纯符号键盘返回数字符号键盘
            [self changeTypeViewWithAnimation];
            self.keyboardType = KeyboardTypeSymbolAndNumber;
            self.customTextField.keyboardtype = KeyboardTypeSymbolAndNumber;
            break;
            
        case KeyboardButtonTypeDelete:
            //删除字符
            [self.customTextField clickTheKeyboards:nil isInput:NO];
            break;
            
        case KeyboardButtonTypeSpace:
            //输入空格
            [self.customTextField clickTheKeyboards:@" " isInput:YES];
            break;
            
        case KeyboardButtonTypeExit:
            //退出键盘
            [self.customTextField resignFirstResponder];
            break;
            
        case KeyboardButtonTypeFinish:
            //完成
            [self.customTextField clickFinishKey];
            break;
            
        case KeyboardButtonTypeDefault:
        default:
            //输入字符 如果是字母键盘 还需判断大小写
            [self.customTextField clickTheKeyboards:sender.titleLabel.text isInput:YES];
            break;
    }
}

#pragma mark - 
#pragma mark - 改变键盘视图类型时 添加动效
- (void)changeTypeViewWithAnimation
{
    if (!self.closeAnimation) {
        [self.layer removeAllAnimations];
        //水波纹动效(私有动画 慎用)
        CATransition * animation = [CATransition animation];
        animation.type = @"rippleEffect";
        animation.duration = 0.8;
        animation.repeatCount = 1;
        [self.layer addAnimation:animation forKey:@"rippleEffect"];
    }
}


@end
