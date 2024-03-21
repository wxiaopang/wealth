//
//  IconAndLabelView.m
//  wealth
//
//  Created by wangyingjie on 16/3/22.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "IconAndLabelView.h"

@interface IconAndLabelView ()

@end

@implementation IconAndLabelView

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
    GreateImageView(self.iconView, @"", @"", self);
    GreateLabelf(self.titleLabel, [UIColor get_1_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentLeft, self);
}

- (void)setIconView:(UIImage *)icon AndTitle:(NSString *)title{
    _iconView.image = icon;
    [_titleLabel setAdaptionHeightWithText:title];
    _iconView.frame = CGRectMake(kLeftCommonMargin, (self.height - icon.size.height)/2.0f, icon.size.width, icon.size.height);
    _titleLabel.frame = CGRectMake(_iconView.right + 10.0f, (self.height - _titleLabel.size.height)/2.0f, (self.width - kLeftCommonMargin - _iconView.size.width - 10.0f), _titleLabel.height);
    
}

- (void)setTitle:(NSString *)title AndIconView:(UIImage *)icon{
    if (!title) {
        title = @"";
    }
    _iconView.image = icon;
    [_titleLabel setAdaptionWidthWithText:title];
    
    _titleLabel.frame = CGRectMake(kLeftCommonMargin, (self.height - 16.0)/2.0f, _titleLabel.width, 16.0f);
    _iconView.frame = CGRectMake(_titleLabel.right + 5.0f, (self.height - icon.size.height)/2.0f, icon.size.width, icon.size.height);
    
}


//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

@end


