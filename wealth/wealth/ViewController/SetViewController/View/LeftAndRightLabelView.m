//
//  LeftAndRightLabelView.m
//  wealth
//
//  Created by wangyingjie on 16/3/23.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "LeftAndRightLabelView.h"

@interface LeftAndRightLabelView ()

@end

@implementation LeftAndRightLabelView

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
    GreateEmptyLabel(self.lineView, [UIColor get_6_Color], self);
    GreateLabelf(self.leftLabel, [UIColor get_1_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentLeft, self);
    GreateLabelf(self.RightLabel, [UIColor get_1_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentRight, self);
}


- (void)setleftText:(NSString *)lText AndRightText:(NSString *)rText{
    if (lText && lText.length > 0) {
        [_leftLabel setAdaptionWidthWithText:lText];
        _leftLabel.frame = CGRectMake(kLeftCommonMargin, (self.height - 16.0f)/2.0f, _leftLabel.width, 16.0f);
    }
    if (rText && rText.length > 0) {
        [_RightLabel setAdaptionWidthWithText:rText];
        _RightLabel.frame = CGRectMake((self.width - _RightLabel.width-kLeftCommonMargin), (self.height - 16.0f)/2.0f, _RightLabel.width, 16.0f);
    }
    _lineView.frame = CGRectMake(kLeftCommonMargin, self.height - 0.5f, self.width-kLeftCommonMargin, 0.5f);
    
}


//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

@end
