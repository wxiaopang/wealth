//
//  CustomNavigationBar.m
//  Main
//
//  Created by qxxw_a_n on 13-9-16.
//  Copyright (c) 2013年 wangyingjie. All rights reserved.
//

#import "CustomNavigationBar.h"

@interface CustomNavigationBar ()

@end

@implementation CustomNavigationBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor           = [UIColor get_9_Color];
        _titleBackView                 = [[UIView alloc] init];
        _titleBackView.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleBackView];

        //底部分割线
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor getColorWithR209G209B209];
        bottomLine.frame           = CGRectMake(0, self.height - SINGLE_LINE_ADJUST_OFFSET, self.width, SINGLE_LINE_WIDTH);
        [self addSubview:bottomLine];
        self.bottomLine = bottomLine;
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(ScreenWidth/2-120,10+(self.height-20)/2,20,20)];
        self.activityIndicatorView.color = [UIColor whiteColor];
//        _loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-120,10+(self.height-20)/2,20,20)];
//        _loadingImageView.image = [UIImage imageNamed:@"com_refresh_r.png"];
//        _loadingImageView.animationDuration = 0.5;
//        _loadingImageView.hidden = YES;
        [self addSubview:_activityIndicatorView];

        @weakify(self);
        [_titleBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.mas_top).offset(20);
            make.left.equalTo(self.mas_left).offset(70);
            make.right.equalTo(self.mas_right).offset(-70);
            make.height.equalTo(@(44));
        }];

        [[RACObserve([UIApplication sharedApplication], networkActivityIndicatorVisible) distinctUntilChanged] subscribeNext:^(id x) {
            @strongify(self);
            if ( [x boolValue] ) {
                [self.activityIndicatorView startAnimating];
                int direction = 1;  //-1为逆时针
                CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * direction];
                rotationAnimation.duration = 0.6f;
                rotationAnimation.repeatCount = FLT_MAX;
//                [self.loadingImageView.layer addAnimation:rotationAnimation forKey:@"rotateAnimation"];
//                self.loadingImageView.hidden = NO;
            } else {
                [self.activityIndicatorView stopAnimating];
//                [self.loadingImageView.layer removeAnimationForKey:@"rotateAnimation"];
//                self.loadingImageView.hidden = YES;
            }

//            if ( [x boolValue] ) {
//                [self.activityIndicatorView startAnimating];
//            } else {
//                [self.activityIndicatorView stopAnimating];
//            }
        }];
    }
    return self;
}

- (void)setBackImg:(UIImage *)backImg {
    _backImg = backImg;
    if (_backImgView == nil) {
            _backImgView = [[UIImageView alloc]init];
            _backImgView.backgroundColor = [UIColor clearColor];
            _backImgView.image = backImg;
            _backImgView.contentMode = UIViewContentModeScaleAspectFill;

            [self addSubview:_backImgView];
            [self insertSubview:_backImgView atIndex:0];
            @weakify(self);
            [_backImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.top.equalTo(self.mas_top).offset(0);
                make.left.equalTo(self.mas_left).offset(0);
                make.right.equalTo(self.mas_right).offset(0);
                make.height.equalTo(self.mas_height);
            }];
    }
    
}
    
- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = [title copy];
        if (_titleLabel == nil) {
            _titleLabel = [[UILabel alloc]init];
            [_titleLabel setBackgroundColor:[UIColor clearColor]];
            [_titleLabel setTextColor:[UIColor navigateBarTitleColor]];
            [_titleLabel setFont:[UIFont boldSystemFontOfSize:kNavigationTitleFontSize]];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            [_titleBackView addSubview:_titleLabel];

            @weakify(self);
            [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.top.equalTo(self.titleBackView.mas_top).offset(0);
                make.left.equalTo(self.titleBackView.mas_left).offset(0);
                make.right.equalTo(self.titleBackView.mas_right).offset(0);
                make.height.equalTo(self.titleBackView.mas_height);
            }];
        }
        _titleLabel.text = _title;
        
        CGSize size = [title boundingRectWithSize:CGSizeMake(_titleBackView.width, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName:_titleLabel.font }
                                          context:nil].size;
        self.activityIndicatorView.frame = CGRectMake((ScreenWidth-size.width)/2-20-20,
                                                 10+(self.height-20)/2,
                                                 self.activityIndicatorView.width,
                                                 self.activityIndicatorView.height);
//        self.activityIndicatorView.frame = CGRectMake((ScreenWidth-size.width)/2-20-20,
//                                                      self.activityIndicatorView.top,
//                                                      self.activityIndicatorView.width,
//                                                      self.activityIndicatorView.height);
    }
}

- (void)setTitleView:(UIView *)ltitleView {
    _titleView = ltitleView;
    [_titleBackView addSubview:_titleView];

    if (_titleView) {
        @weakify(self);
        [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(self.titleBackView.mas_centerX);
            make.centerY.equalTo(self.titleBackView.mas_centerY);
            make.width.equalTo(self.titleView.mas_width);
            make.height.equalTo(self.titleView.mas_height);
        }];
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    if (titleColor == _titleLabel.textColor) {
        return;
    }
    _titleLabel.textColor = titleColor;
}

- (void)setLeftBtn:(UIButton *)theLeftBtn {
    if (_leftBtn != theLeftBtn) {
        if (_leftBtn) {
            [_leftBtn removeFromSuperview];
            _leftBtn = nil;
        }
        _leftBtn = theLeftBtn;
        [self addSubview:_leftBtn];
    }
}

- (void)setRightBtn:(UIButton *)theRightBtn {
    if (_rightBtn != theRightBtn) {
        if (_rightBtn) {
            [_rightBtn removeFromSuperview];
            _rightBtn = nil;
        }
        _rightBtn = theRightBtn;
        [self addSubview:_rightBtn];
    }
}

@end
