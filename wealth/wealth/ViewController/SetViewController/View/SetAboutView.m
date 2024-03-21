//
//  SetAboutView.m
//  wealth
//
//  Created by wangyingjie on 16/3/23.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "SetAboutView.h"

@interface SetAboutView ()

@end

@implementation SetAboutView

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
    self.headerBGView = [[UIView alloc] initViewWithFrame:CGRectMake(0, 0, ScreenWidth, kProportion*189.0f) backgroundColor:[UIColor whiteColor]];
    [self addSubview:_headerBGView];
    
    GreateImageView(self.headerView,@"about_logo", @"", self);
    _headerView.frame = CGRectMake((self.width - _headerView.image.size.width*kProportion)/2.0f, (_headerBGView.height - _headerView.image.size.height*kProportion)/2.0f, _headerView.image.size.width*kProportion, _headerView.image.size.height*kProportion);
    _headerView.contentMode = UIViewContentModeScaleToFill;
    
    
    
    self.versionView = [[LeftAndRightLabelView alloc] initViewWithFrame:CGRectMake(0, _headerBGView.bottom + 10.0f, ScreenWidth, 49.0f) backgroundColor:[UIColor whiteColor]];
    [self addSubview:_versionView];
    _versionView.lineView.hidden = YES;
    [_versionView setleftText:@"版本号" AndRightText:[NSString stringWithFormat:@"V%@",APP_SERVER_VERSION]];
    
    GreateLabelf(self.messageLabel, [UIColor get_1_Color], [UIFont get_A24_CN_NOR_Font], NSTextAlignmentCenter, self);
    _messageLabel.numberOfLines = 0;
    _messageLabel.frame = CGRectMake(0, self.height - 40.0f*kProportion - 30.0f, self.width, 30.0f);
    _messageLabel.text = [NSString stringWithFormat:@"普惠财富客户服务热线：%@\n%@",kPhoneNumberDis,kMessageWorkTime];
    
}


//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

@end
