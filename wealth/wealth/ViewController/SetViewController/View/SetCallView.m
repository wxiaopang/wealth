//
//  SetCallView.m
//  wealth
//
//  Created by wangyingjie on 16/3/23.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "SetCallView.h"

@implementation SetCallView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
        
    }
    return self;
}


- (void)createUI{
    
    UIImageView *callImageView = [[UIImageView alloc] init];
    callImageView.frame = CGRectMake(0, 0, 76/2, 68/2);
    callImageView.backgroundColor = [UIColor clearColor];
//    callImageView.layer.masksToBounds = YES;
//    callImageView.layer.cornerRadius = 98/4;
    callImageView.image = [UIImage imageNamed:@"settings_icon_service"];
//    callImageView.backgroundColor = [UIColor grayColor];
    [self addSubview:callImageView];
    
    UILabel *callPhoneLabel = [[UILabel alloc] init];
    callPhoneLabel.backgroundColor = [UIColor clearColor];
    callPhoneLabel.frame = CGRectMake((98+16)/2, 12/2, 150, 20);
    callPhoneLabel.textColor = [UIColor get_1_Color];
    callPhoneLabel.text = kPhoneNumberDis;
    callPhoneLabel.font = [UIFont get_E36_CN_NOR_Font];
    [self addSubview:callPhoneLabel];
    
    UILabel *callTimeLabel = [[UILabel alloc] init];
    callTimeLabel.backgroundColor = [UIColor clearColor];
    callTimeLabel.textColor = [UIColor get_1_Color];
    [callTimeLabel setAdaptionWidthWithText:kMessageWorkTime];
    callTimeLabel.frame = CGRectMake((98+16)/2, (20+14+24)/2, callTimeLabel.width, 15);
    callTimeLabel.font = [UIFont get_B26_CN_NOR_Font];
    [self addSubview:callTimeLabel];
    
    callImageView.frame = CGRectMake((ScreenWidth - 38.0f - callTimeLabel.width - 8.0f)/2.0f, 99/2.0f - 68.0f/4.0f, 76.0f/2.0f, 68.0f/2.0f);
    callPhoneLabel.frame = CGRectMake(callImageView.right +8.0f, callImageView.top -3.0f, 150, 20);
    callTimeLabel.frame = CGRectMake(callImageView.right + 8.0f, callPhoneLabel.bottom + 5.0f, callTimeLabel.width, 15);
    
}


@end
