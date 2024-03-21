//
//  RegistFinshView.m
//  wealth
//
//  Created by wangyingjie on 16/3/21.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "RegistFinshView.h"

@interface RegistFinshView ()

@property (nonatomic, strong) UIButton *topButton;        /**<*/
@property (nonatomic, strong) UIButton *botButton;        /**<*/


@end

@implementation RegistFinshView

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
    
    UIImageView *bgImageView = [[UIImageView alloc] initImageViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) image:[UIImage imageNamed:@"background_image"] backgroundColor:[UIColor whiteColor]];
    [self addSubview:bgImageView];
    
    UIImageView *imageView = [[UIImageView alloc] initImageViewWithFrame:CGRectMake((ScreenWidth - 75)/2.0f, 150.0f, 75.0f, 91.0f) image:[UIImage imageNamed:@"login_right"] backgroundColor:[UIColor clearColor]];
    [self addSubview:imageView];
    
    UILabel *messageLabel = nil;
    GreateLabel(messageLabel, [UIColor get_9_Color], 20.0f, NSTextAlignmentCenter, self);
    messageLabel.text = @"注册成功";
    messageLabel.frame = CGRectMake(0, imageView.bottom + 15.0f, ScreenWidth, 25.0f);
    
    UIImage *normalImage = [[UIImage imageNamed:@"big_button"] stretchableImageWithLeftCapWidth:50 topCapHeight:45];
    UIImage *highlightedImage = [[UIImage imageNamed:@"big_button_click"] stretchableImageWithLeftCapWidth:50 topCapHeight:45];
    
    self.topButton = [[UIButton alloc] initButtonWithFrame:CGRectMake(45.0f, ScreenHeight - 200, ScreenWidth-90.0f, 45.0f) backgroundColor:[UIColor clearColor] font:FONT_CN_NORMAL(34) titleColor:[UIColor whiteColor] title:@"开通民生存管账户，开始赚钱"];
    [_topButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [_topButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [_topButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_topButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_topButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _topButton.layer.masksToBounds = YES;
    _topButton.layer.cornerRadius = 3.0f;
    [_topButton addTapGestureRecognizerWithTarget:self action:@selector(topButtonClick)];
    [self addSubview:_topButton];
    _topButton.hidden = YES;
    
    
    normalImage = [[UIImage imageNamed:@"big_ghost_button"] stretchableImageWithLeftCapWidth:50 topCapHeight:45];
    highlightedImage = [[UIImage imageNamed:@"big_ghost_button_click"] stretchableImageWithLeftCapWidth:50 topCapHeight:45];
    
    self.botButton = [[UIButton alloc] initButtonWithFrame:CGRectMake(45.0f, _topButton.bottom + (20.0f)*0.6, ScreenWidth-90.0f, 45.0f) backgroundColor:[UIColor clearColor] font:FONT_CN_NORMAL(34) titleColor:[UIColor get_9_Color] title:@"去首页"];
    [_botButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [_botButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [_botButton setTitleColor:[UIColor get_9_Color] forState:UIControlStateNormal];
    [_botButton setTitleColor:[UIColor get_9_Color] forState:UIControlStateNormal];
    [_botButton setTitleColor:[UIColor get_9_Color] forState:UIControlStateNormal];
    [_botButton addTapGestureRecognizerWithTarget:self action:@selector(botButtonClick)];
    [self addSubview:_botButton];
    
    
}


- (void)topButtonClick{
    NSLog(@"topButtonClick");
    if (self.bankBlock) {
        self.bankBlock();
    }
}

- (void)botButtonClick{
    NSLog(@"botButtonClick");
    if (self.gotoHomepage) {
        self.gotoHomepage();
    }
}


//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

@end
