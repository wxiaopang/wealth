//
//  TextFieldCell.m
//  wealth
//
//  Created by wangyingjie on 15/2/11.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "TextFieldCell.h"

#define kLeftLableMinLength     90.0f

#pragma mark UIInsetTextField

@implementation UIInsetTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, _inset);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, _inset);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, _inset);
}

@end

#pragma mark - TextFieldCell

@interface TextFieldCell () <TimerLableDelegate>

@end

@implementation TextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.expandView        = [[UIView alloc] initWithFrame:CGRectZero];
        self.expandView.hidden = YES;
        [self addSubview:_expandView];

        self.leftLabel                 = [[UITimerLable alloc] initWithFrame:CGRectZero];
        self.leftLabel.backgroundColor = [UIColor clearColor];
        self.leftLabel.textColor       = [UIColor formLeftTitleNormalColor];
        self.leftLabel.textAlignment   = NSTextAlignmentLeft;
        self.leftLabel.font            = [UIFont systemFontOfSize:15.0f];
        self.leftLabel.hidden          = YES;
        [self addSubview:_leftLabel];

        self.rightTextField                          = [[UIRegExTextField alloc] initWithFrame:CGRectZero];
        self.rightTextField.backgroundColor          = [UIColor clearColor];
        self.rightTextField.textColor                = [UIColor formLeftTitleNormalColor];
        self.rightTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.rightTextField.clearButtonMode          = UITextFieldViewModeWhileEditing;
        self.rightTextField.delegate                 = self;

        //Use Done for all of them.
        self.rightTextField.returnKeyType = UIReturnKeyDone;
        [self addSubview:_rightTextField];

        self.line                 = [[UIView alloc] init];
        self.line.backgroundColor = [UIColor getColorWithR209G209B209];
        [self addSubview:_line];

        self.rightLabel                        = [[UITimerLable alloc] initWithFrame:CGRectZero];
        self.rightLabel.delegate               = self;
        self.rightLabel.backgroundColor        = [UIColor clearColor];
        self.rightLabel.textAlignment          = NSTextAlignmentCenter;
        self.rightLabel.userInteractionEnabled = YES;
        self.rightLabel.hidden                 = YES;
        [self addSubview:_rightLabel];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)];
        [self.rightLabel addGestureRecognizer:tap];

        //Try to mimic the style of UITableViewCellStyleValue2 if inited with that style
        if (style == UITableViewCellStyleValue2) {
            //If iOS 7 and set up as UITableViewCellStyleValue2
            if ([self respondsToSelector:@selector(tintColor)]) {
                self.leftLabel.font      = self.rightLabel.font = self.textLabel.font;
                self.leftLabel.textColor = self.rightLabel.textColor = [UIColor formLeftTitleNormalColor];
                self.rightTextField.font = self.detailTextLabel.font;

                //iOS 6 and below returns a 0 font size for the detailTextLabel.font
                //So Revert to hard coding in the font and color in iOS 6 and below
            }
            else {
                self.leftLabel.font      = self.rightLabel.font = [UIFont boldSystemFontOfSize:12];
                self.leftLabel.textColor = self.rightLabel.textColor = [UIColor formLeftTitleNormalColor];
                self.rightTextField.font = [UIFont boldSystemFontOfSize:15];
            }
            //Otherwise have a sane default
        }
        else {
            self.leftLabel.font      = self.rightLabel.font = [UIFont systemFontOfSize:15.0f];
            self.leftLabel.textColor = self.rightLabel.textColor = [UIColor formLeftTitleNormalColor];
            self.rightTextField.font = [UIFont systemFontOfSize:15.0f];
        }

        @weakify(self);
        [[self.rightTextField.rac_textSignal distinctUntilChanged] subscribeNext:^(id x) {
            @strongify(self);
            if (self.rightTextField.text.length > 0) {
                self.leftLabel.textColor = [UIColor formLeftTitleEditingColor];
                if (!self.enableTapRightLabel && !self.rightLabel.valid) {
                    self.rightLabel.textColor = [UIColor formLeftTitleEditingColor];
                }
            }
            else {
                self.leftLabel.textColor = [UIColor formLeftTitleNormalColor];
                if (!self.enableTapRightLabel && !self.rightLabel.valid) {
                    self.rightLabel.textColor = [UIColor formLeftTitleNormalColor];
                }
            }
        }];
    }

    return self;
}

- (void)dealloc {
    [_rightTextField resignFirstResponder];
}

- (void)setEnableTapRightLabel:(BOOL)enableTapRightLabel {
    _enableTapRightLabel = enableTapRightLabel;
    [self setNeedsLayout];
}

//Layout our fields in case of a layoutchange (fix for iPad doing strange things with margins if width is > 400)
- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.expandView.hidden) {
        // 扩展view隐藏状态
        [self layoutWithoutExpandView];
    }
    else {
        // 扩展view显示状态
        [self layoutWithExpandView];
    }
}

- (void)layoutWithoutExpandView {
    CGRect origFrame = self.contentView.frame;
    if (_leftLabel.text != nil) {
        CGSize leftSize = [_leftLabel.text boundingRectWithSize:self.frame.size
                                                        options:(NSStringDrawingUsesLineFragmentOrigin
                                                                 | NSStringDrawingUsesFontLeading)
                                                     attributes:@{ NSFontAttributeName:_leftLabel.font }
                                                        context:nil].size;
        _leftLabel.hidden = NO;
        _leftLabel.frame  = CGRectMake(origFrame.origin.x + 16, origFrame.origin.y,
                                       MAX(self.leftLabelMargin, leftSize.width + 12),
                                       origFrame.size.height-1);

        if (_rightLabel.text != nil) {
            CGSize rightSize = [_rightLabel.text boundingRectWithSize:self.frame.size
                                                              options:(NSStringDrawingUsesLineFragmentOrigin
                                                                       | NSStringDrawingUsesFontLeading)
                                                           attributes:@{ NSFontAttributeName:_rightLabel.font }
                                                              context:nil].size;
            _rightLabel.hidden = NO;
            _line.hidden       = NO;
            _rightLabel.frame  = CGRectMake(origFrame.size.width - rightSize.width - 16,
                                            origFrame.origin.y,
                                            rightSize.width + 5,
                                            origFrame.size.height);
            _line.frame = CGRectMake(_rightLabel.left - 16, origFrame.origin.y + 10, 1, origFrame.size.height - 20);

            _rightTextField.frame = CGRectMake(_leftLabel.right + 8,
                                               origFrame.origin.y,
                                               origFrame.size.width - _leftLabel.width - _rightLabel.width - 52,
                                               origFrame.size.height);
        }
        else {
            _rightTextField.frame = CGRectMake(_leftLabel.right + 8,
                                               origFrame.origin.y,
                                               origFrame.size.width - _leftLabel.width - 36,
                                               origFrame.size.height);
        }
    }
    else {
        _leftLabel.hidden = YES;
        NSInteger imageWidth = 0;
        if (self.imageView.image != nil) {
            imageWidth = self.imageView.image.size.width + 5;
        }
        if (_rightLabel.text != nil) {
            CGSize rightSize = [_rightLabel.text boundingRectWithSize:self.frame.size
                                                              options:(NSStringDrawingUsesLineFragmentOrigin
                                                                       | NSStringDrawingUsesFontLeading)
                                                           attributes:@{ NSFontAttributeName:_rightLabel.font }
                                                              context:nil].size;
            _rightLabel.hidden = NO;
            _line.hidden       = NO;
            _rightLabel.frame  = CGRectMake(origFrame.size.width - imageWidth - rightSize.width - 16,
                                            origFrame.origin.y,
                                            rightSize.width + 5,
                                            origFrame.size.height);
            _line.frame = CGRectMake(_rightLabel.left - 16, origFrame.origin.y + 10, 1, origFrame.size.height - 20);

            _rightTextField.frame = CGRectMake(origFrame.origin.x+imageWidth+20 + 8,
                                               origFrame.origin.y,
                                               origFrame.size.width - imageWidth - rightSize.width - 52,
                                               origFrame.size.height);
        }
        else {
            _rightTextField.frame = CGRectMake(origFrame.origin.x+imageWidth+20 + 8, origFrame.origin.y, origFrame.size.width-imageWidth-30, origFrame.size.height-1);
        }
    }

    [self setNeedsDisplay];
}

- (void)layoutWithExpandView {
    CGRect origFrame = CGRectMake(self.contentView.left, self.contentView.top, self.contentView.width, self.contentView.height/2);
    if (_leftLabel.text != nil) {
        CGSize leftSize = [_leftLabel.text boundingRectWithSize:self.frame.size
                                                        options:(NSStringDrawingUsesLineFragmentOrigin
                                                                 | NSStringDrawingUsesFontLeading)
                                                     attributes:@{ NSFontAttributeName:_leftLabel.font }
                                                        context:nil].size;
        _leftLabel.hidden = NO;
        _leftLabel.frame  = CGRectMake(origFrame.origin.x + 16, origFrame.origin.y, leftSize.width + 12, origFrame.size.height-1);

        if (_rightLabel.text != nil) {
            CGSize rightSize = [_rightLabel.text boundingRectWithSize:self.frame.size
                                                              options:(NSStringDrawingUsesLineFragmentOrigin
                                                                       | NSStringDrawingUsesFontLeading)
                                                           attributes:@{ NSFontAttributeName:_rightLabel.font }
                                                              context:nil].size;
            _rightLabel.hidden = NO;
            _line.hidden       = NO;
            _rightLabel.frame  = CGRectMake(origFrame.size.width - rightSize.width - 16,
                                            origFrame.origin.y,
                                            rightSize.width + 5,
                                            origFrame.size.height);
            _line.frame = CGRectMake(_rightLabel.left - 16, origFrame.origin.y + 10, 1, origFrame.size.height - 20);

            _rightTextField.frame = CGRectMake(_leftLabel.left + _leftLabel.width + 8,
                                               origFrame.origin.y,
                                               origFrame.size.width - _leftLabel.width - _rightLabel.width - 52,
                                               origFrame.size.height);
        }
        else {
            _rightTextField.frame = CGRectMake(_leftLabel.right + 8,
                                               origFrame.origin.y,
                                               origFrame.size.width - _leftLabel.width - 36,
                                               origFrame.size.height);
        }
    }
    else {
        _leftLabel.hidden = YES;
        NSInteger imageWidth = 0;
        if (self.imageView.image != nil) {
            imageWidth = self.imageView.image.size.width + 5;
        }
        if (_rightLabel.text != nil) {
            CGSize rightSize = [_rightLabel.text boundingRectWithSize:self.frame.size
                                                              options:(NSStringDrawingUsesLineFragmentOrigin
                                                                       | NSStringDrawingUsesFontLeading)
                                                           attributes:@{ NSFontAttributeName:_rightLabel.font }
                                                              context:nil].size;
            _rightLabel.hidden = NO;
            _line.hidden       = NO;
            _rightLabel.frame  = CGRectMake(origFrame.size.width - imageWidth - rightSize.width - 16,
                                            origFrame.origin.y,
                                            rightSize.width + 5,
                                            origFrame.size.height);
            _line.frame = CGRectMake(_rightLabel.left - 16, origFrame.origin.y + 10, 1, origFrame.size.height - 20);

            _rightTextField.frame = CGRectMake(origFrame.origin.x+imageWidth+20 + 8,
                                               origFrame.origin.y,
                                               origFrame.size.width - imageWidth - rightSize.width - 52,
                                               origFrame.size.height);
        }
        else {
            _rightTextField.frame = CGRectMake(origFrame.origin.x+imageWidth+20 + 8,
                                               origFrame.origin.y,
                                               origFrame.size.width-imageWidth-30,
                                               origFrame.size.height-1);
        }
    }

    CGRect expandFrame = CGRectMake(self.contentView.left, self.contentView.top + self.contentView.height/2,
                                    self.contentView.width, self.contentView.height/2);
    self.expandView.frame = expandFrame;

    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)tapGestureRecognizer {
    if (_enableTapRightLabel
        && _delegate
        && [_delegate respondsToSelector:@selector(textFieldLabelTapGestureRecognizer:)]) {
        [_delegate textFieldLabelTapGestureRecognizer:self];
    }
}

#pragma mark -- UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL ret = YES;
    if ([_delegate respondsToSelector:@selector(textFieldCell:shouldReturnForIndexPath:withValue:)]) {
        ret = [_delegate textFieldCell:self shouldReturnForIndexPath:_indexPath withValue:self.rightTextField.text];
    }
    if (ret) {
        [textField resignFirstResponder];
    }
    return ret;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([_delegate respondsToSelector:@selector(textFieldCell:updateTextLabelAtIndexPath:range:string:)]) {
        return [_delegate textFieldCell:self updateTextLabelAtIndexPath:_indexPath range:range string:string];
    }
    else {
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(textFieldCell:updateTextLabelAtIndexPath:range:string:)]) {
        return [_delegate textFieldCell:self updateTextLabelAtIndexPath:_indexPath range:NSMakeRange(0, 0) string:nil];
    }
    else {
        return YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.leftLabel.textColor = [UIColor formLeftTitleEditingColor];
    if (!self.enableTapRightLabel && !self.rightLabel.valid) {
        self.rightLabel.textColor = [UIColor formLeftTitleEditingColor];
    }
    if ([_delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [_delegate textFieldShouldBeginEditing:(UITextField *)textField];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [_delegate textFieldShouldEndEditing:(UITextField *)textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        return [_delegate textFieldDidBeginEditing:(UITextField *)textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length > 0) {
        self.leftLabel.textColor = [UIColor formLeftTitleEditingColor];
        if (!self.enableTapRightLabel && !self.rightLabel.valid) {
            self.rightLabel.textColor = [UIColor formLeftTitleEditingColor];
        }
    }
    else {
        self.leftLabel.textColor = [UIColor formLeftTitleNormalColor];
        if (!self.enableTapRightLabel && !self.rightLabel.valid) {
            self.rightLabel.textColor = [UIColor formLeftTitleNormalColor];
        }
    }
    if ([_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_delegate textFieldDidEndEditing:(UITextField *)textField];
    }
}

#pragma mark -- TimerLableDelegate

- (void)timeOut:(UITimerLable *)lable {
    if (_delegate && [_delegate respondsToSelector:@selector(timeOut:)]) {
        [_delegate timeOut:self];
    }
}

@end
