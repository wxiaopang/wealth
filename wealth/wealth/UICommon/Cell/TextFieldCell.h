//
//  TextFieldCell.h
//  wealth
//
//  Created by wangyingjie on 15/2/11.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIRegExTextField.h"
#import "CustomDrawTableViewCell.h"

#define kTextFieldCellHeight    49.0f

@class TextFieldCell;

@interface UIInsetTextField : UIRegExTextField

@property (nonatomic, assign) UIEdgeInsets inset;

@end

@protocol TextFieldDelegate <NSObject>

@optional
//Called to the delegate whenever return is hit when a user is typing into the rightTextField of an TextFieldCell
- (BOOL)       textFieldCell:(TextFieldCell *)inCell
    shouldReturnForIndexPath:(NSIndexPath *)inIndexPath
                   withValue:(NSString *)inValue;

//Called to the delegate whenever the text in the rightTextField is changed
- (BOOL)         textFieldCell:(TextFieldCell *)inCell
    updateTextLabelAtIndexPath:(NSIndexPath *)inIndexPath
                         range:(NSRange)range
                        string:(NSString *)inValue;

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;

- (void)textFieldLabelTapGestureRecognizer:(TextFieldCell *)textFieldCell;
- (void)timeOut:(TextFieldCell *)textFieldCell;

@end

@interface TextFieldCell : CustomDrawTableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) id<TextFieldDelegate> delegate;
@property (nonatomic, assign) CGFloat             leftLabelMargin;
@property (nonatomic, strong) UITimerLable        *leftLabel;
@property (nonatomic, strong) UITimerLable        *rightLabel;
@property (nonatomic, strong) UIRegExTextField    *rightTextField;
@property (nonatomic, strong) UIView              *line;
@property (nonatomic, strong) NSIndexPath         *indexPath;
@property (nonatomic, assign) BOOL                enableTapRightLabel;

@property (nonatomic, strong) UIView *expandView;

@end
