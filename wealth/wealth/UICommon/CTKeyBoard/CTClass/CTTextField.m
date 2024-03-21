//
//  CTTextField.m
//  CTKeyboard
//
//  Created by wangyingjie on 15/7/28.
//  Copyright (c) 2015年 Keyboard. All rights reserved.
//

#import "CTTextField.h"
#import "CTKeyboardView.h"

@interface CTTextField () <UITextFieldDelegate>

@property (nonatomic,assign) id <UITextInput> textInputDelegate;

@end

@implementation CTTextField

- (id)init
{
    self = [super init];
    if (self) {
        [self openCTKeyboardViewConfig];
    }
    return self;
}

- (void)awakeFromNib
{
    [self openCTKeyboardViewConfig];
}

// 防止self.delegate == self 造成循环引用，卡死界面
- (id)customOverlayContainer {
    return self;
}

- (void)openCTKeyboardViewConfig
{
    self.delegate = self;
    self.inputView = ShareKeyboard;
    self.textInputDelegate = self;
}

- (void)setTextFieldDelegate:(id<CTTextFieldDelegate>)textFieldDelegate
{
    _textFieldDelegate = textFieldDelegate;
    if ( _textFieldDelegate ) {
        //设置键盘属性
        ShareKeyboard.customTextField = self;
        ShareKeyboard.charsLayoutType = self.charsLayoutType;
        //设置这个属性后 键盘会重新布局
        ShareKeyboard.keyboardType = self.keyboardtype;
    }
}

// 控制placeHolder的颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect {
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentLeft;
    CGRect frame = CGRectMake(0, (rect.size.height - 17)/2, rect.size.width, 17);
    [self.placeholder drawInRect:frame
                  withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14],
                                    NSForegroundColorAttributeName:[UIColor formTextFieldPlaceholderColor],
                                    NSParagraphStyleAttributeName:style
                                    }];
}

- (NSRange)selectedRange:(BOOL)isAdd
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    //获取当前光标
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    if (isAdd) {
        //增加
        return NSMakeRange(location, length);
    }
    
    //删减
    if (location == 0) {
        return NSMakeRange(0, 1);
    }
    return NSMakeRange(location-1, 1);
}

- (void)clickTheKeyboards:(NSString *)text isInput:(BOOL)isInput
{
    NSRange range = [self selectedRange:isInput];
    BOOL enable = [self textField:self shouldChangeCharactersInRange:range replacementString:text];
    
    if (enable) {
        if (isInput) {
            //添加字符
            [self.textInputDelegate insertText:text];
        } else {
            //删除字符
            [self.textInputDelegate deleteBackward];
        }
    }
}

#pragma mark - 
#pragma mark - 点击完成键位
- (void)clickFinishKey
{
    [self textFieldShouldReturn:self];
}

#pragma mark - 
#pragma mark - UITextField delegate
//是否允许编辑 点击编辑框时触发
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL enable = YES;
    
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(CTTextFieldShouldBeginEditing:)]) {
        enable = [self.textFieldDelegate CTTextFieldShouldBeginEditing:self];
    }

    if (enable) {
        //设置键盘属性
        ShareKeyboard.customTextField = self;
        ShareKeyboard.charsLayoutType = self.charsLayoutType;
        //设置这个属性后 键盘会重新布局
        ShareKeyboard.keyboardType = self.keyboardtype;
    }
    return enable;
}

//开始编辑 点击编辑框 并且被允许编辑时触发
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(CTTextFieldDidBeginEditing:)] ) {
        [self.textFieldDelegate CTTextFieldDidBeginEditing:self];
    }
}

//是否结束编辑  焦点将要从当前编辑框离开时 即用户点击了另一个编辑框 或 结束编辑收起键盘时
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    BOOL enable = YES;
    
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(CTTextFieldShouldEndEditing:)]) {
        enable = [self.textFieldDelegate CTTextFieldShouldEndEditing:self];
    }
    return enable;
}

//焦点已离开编辑框 结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(CTTextFieldDidEndEditing:)] ) {
        [self.textFieldDelegate CTTextFieldDidEndEditing:self];
    }
}

//是否允许改变编辑框内的内容 从指定的位置增加或删减一个字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL enable = YES;

    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(CTTextField:shouldChangeCharactersInRange:replacementString:)]) {
        enable = [self.textFieldDelegate CTTextField:self shouldChangeCharactersInRange:range replacementString:string];
    }
    return enable;
}


//是否允许删除编辑框上的全部内容  点击编辑框上的删除按钮时
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    BOOL enable = YES;
    
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(CTTextFieldShouldClear:)]) {
        enable = [self.textFieldDelegate CTTextFieldShouldClear:self];
    }
    return enable;
}

//键盘上的确认键按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL enable = YES;
    
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(CTTextFieldShouldReturn:)]) {
        enable = [self.textFieldDelegate CTTextFieldShouldReturn:self];
    }
    return enable;
}



@end
