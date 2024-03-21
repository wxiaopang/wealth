//
//  ProductionBuyTextfeildView.m
//  wealth
//
//  Created by wangyingjie on 16/3/29.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "ProductionBuyTextfeildView.h"




@interface ProductionBuyTextfeildView ()

@end

@implementation ProductionBuyTextfeildView

- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}


#pragma mark- SetupViews
- (void)setUpViews {
    
    GreateLabelf(self.placeholderLabel, [UIColor get_3_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentCenter, self);
    GreateTextField(self.myTextField, 30, self);
    GreateUIView(self.botLine, [UIColor get_4_Color], self);
}

- (void)setFont:(UIFont *)textFont AndPlaceholderText:(NSString *)placeholderString {
    _myTextField.font = textFont;
    _placeholderLabel.font = textFont;
    _myTextField.textAlignment = NSTextAlignmentCenter;
    if (placeholderString && placeholderString.length > 0) {
        _placeholderLabel.text = placeholderString;
        _placeholderLabel.hidden = NO;
    }else{
        _placeholderLabel.hidden = YES;
    }
    _botLine.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5f);
    _myTextField.frame = CGRectMake(0, self.height - 40.0f, self.width, 35.0f);
    _placeholderLabel.frame = CGRectMake(0, self.height - 40.0f, self.width, 35.0f);
    
}


//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

@end
