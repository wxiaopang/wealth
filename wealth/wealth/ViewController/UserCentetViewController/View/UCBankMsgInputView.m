//
//  UCBankMsgInputView.m
//  wealth
//
//  Created by wangyingjie on 16/4/19.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UCBankMsgInputView.h"

@interface UCBankMsgInputView ()

@end

@implementation UCBankMsgInputView

- (void)dealloc {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


#pragma mark- SetupViews
- (void)setUpViews {
    GreateLabelf(self.nameLabel, [UIColor get_1_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentLeft, self);
    
    self.inputTextField  = [[LARTextField alloc] initTextFieldWithFrame:CGRectMake(kLeftCommonMargin, 15.0f, ScreenWidth - kLeftCommonMargin * 2, 18.0f)
                                                                text:@""
                                                                font:[UIFont get_C30_CN_NOR_Font]
                                                           textColor:[UIColor get_3_Color]
                                                             enabled:YES
                                                       textAlignment:NSTextAlignmentCenter
                                                         placeholder:@""];
    _inputTextField.returnKeyType = UIReturnKeyDone;
    _inputTextField.textColor = [UIColor get_1_Color];
    _inputTextField.tintColor = [UIColor get_9_Color];
    [_inputTextField setValue:[UIColor get_3_Color] forKeyPath:@"_placeholderLabel.textColor"];
    _inputTextField.textAlignment = NSTextAlignmentRight;
//    _inputTextField.delegate = self;
    [self addSubview:_inputTextField];
    
    GreateImageView(self.nextView, @"icon_select", @"icon_select", self);
    _nextView.hidden = YES;
    
    GreateEmptyLabel(self.upLine, [UIColor get_5_Color], self);
    _upLine.frame = CGRectMake(0, 0, self.width, 0.5f);
    
    GreateEmptyLabel(self.bottomLine, [UIColor get_5_Color], self);
    _bottomLine.frame = CGRectMake(0, self.height-0.5f, self.width, 0.5f);
    
    
}

- (void)setNameKey:(NSString *)name AndValue:(NSString *)value{
    [_nameLabel setAdaptionHeightWithText:name?name:@" "];
    _inputTextField.placeholder = value;
    _nameLabel.frame = CGRectMake(kLeftCommonMargin, (self.height - 16.0f)/2.0f, 100.0f, _nameLabel.height);
    _inputTextField.frame = CGRectMake(self.width-200-kLeftCommonMargin, _nameLabel.top-6.0f, 200, _nameLabel.height+4);
}

- (void)setNameKey:(NSString *)name AndValue:(NSString *)value UseNext:(BOOL)next{
    if (next) {
        _nextView.hidden = NO;
        _nextView.frame = CGRectMake(self.width-kLeftCommonMargin-6.0f, (self.height - 11.0f)/2.0f, 6.0f, 11.0f);
        [_nameLabel setAdaptionHeightWithText:name?name:@" "];
        _inputTextField.placeholder = value;
        _nameLabel.frame = CGRectMake(kLeftCommonMargin, (self.height - 16.0f)/2.0f, 100.0f, _nameLabel.height);
        _inputTextField.frame = CGRectMake(self.width-210-kLeftCommonMargin, _nameLabel.top-6.0f, 200, _nameLabel.height+4);
        _inputTextField.enabled = NO;
    }else{
        [_nameLabel setAdaptionHeightWithText:name?name:@" "];
        _inputTextField.placeholder = value;
        _nameLabel.frame = CGRectMake(kLeftCommonMargin, (self.height - 16.0f)/2.0f, 100.0f, _nameLabel.height);
        _inputTextField.frame = CGRectMake(self.width-200-kLeftCommonMargin, _nameLabel.top-6.0f, 200, _nameLabel.height+4);
        _inputTextField.enabled = YES;
        _nextView.hidden = YES;
    }
}


//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ENDEDITING
}


@end
