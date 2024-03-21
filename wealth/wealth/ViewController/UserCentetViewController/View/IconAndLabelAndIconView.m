//
//  IconAndLabelAndIconView.m
//  wealth
//
//  Created by wangyingjie on 16/3/22.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "IconAndLabelAndIconView.h"




@interface IconAndLabelAndIconView ()

@end

@implementation IconAndLabelAndIconView

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
    self.leftIconAndLabelView = [[IconAndLabelView alloc] initViewWithFrame:CGRectMake(0, (self.height - 30.0f)/2.0f, ScreenWidth, 30.0f) backgroundColor:[UIColor clearColor]];
    [self addSubview:_leftIconAndLabelView];
    
    GreateImageView(self.rightImageView, @"", @"", self);
    
}

- (void)setLeftIcon:(UIImage *)leftIcon AndTitle:(NSString *)title AndRight:(UIImage *)rightIcon{
    [_leftIconAndLabelView setIconView:leftIcon AndTitle:title];
    _rightImageView.image = rightIcon;
    _rightImageView.frame = CGRectMake((self.width - kLeftCommonMargin - rightIcon.size.width), (self.height - rightIcon.size.height)/2.0f, rightIcon.size.width, rightIcon.size.height);
}


//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

@end
