//
//  UINoNetWorkView.m
//  wealth
//
//  Created by wangyingjie on 16/4/5.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UINoNetWorkView.h"

@interface UINoNetWorkView ()
@property (nonatomic, strong) UILabel *sheetLabel;   //提示文字
@property (nonatomic, strong) UIButton *btnLabel;    //刷新button
@end
@implementation UINoNetWorkView



@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        //图片
        UIImageView *blankView=[[UIImageView alloc]initWithFrame:CGRectMake((self.width - 154.0/2.0f)/2.0f, self.height/2.0f - 170.0f/1.50f, 154/2, 170/2)];
        blankView.image=[UIImage imageNamed:@"default_icon_wlan"];
        [self addSubview:blankView];
        
        GreateLabelf(self.sheetLabel, [UIColor get_2_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentCenter, self);
        [_sheetLabel setAdaptionWidthWithText:@"网络无法链接,请检查您的网络状态"];
        _sheetLabel.frame = CGRectMake((self.width - _sheetLabel.width-30.0f)/2.0f, blankView.bottom + 10.0f, _sheetLabel.width+30.0f, 16.0f);
        
        GreateButtonType(self.btnLabel, CGRectMake((self.width - _sheetLabel.width)/2.0f, _sheetLabel.bottom + 10.8f, _sheetLabel.width, 49.3f), @"刷新", NO, self);
        [_btnLabel addTapGestureRecognizerWithTarget:self action:@selector(reload)];
        
    }
    return self;
}

-(void)reload{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(reloadButtonClick)]) {
        [self.delegate reloadButtonClick];
    }
}

@end
