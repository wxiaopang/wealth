//
//  UILoadDialogView.m
//  AiShiDai
//
//  Created by wangyingjie on 15/4/29.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UILoadDialogView.h"

@interface UILoadDialogView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIView                  *loadView;  //主要显示视图
@property (nonatomic, strong) UIImageView             *statusImageView; //状态图片视图
@property (nonatomic, strong) UILabel                 *statusLabel; //状态文字Label
@property (nonatomic, assign) BOOL                    isAnimating; //是否需要动画

@end

@implementation UILoadDialogView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _isAnimating         = YES;

        //设置黑色背景
        _loadView                     = [[UIView alloc] init];
        _loadView.backgroundColor     = [UIColor colorWithWhite:0 alpha:0.8];
        _loadView.layer.masksToBounds = YES;
        _loadView.layer.cornerRadius  = 4;
        [self addSubview:_loadView];

        //设置
        _statusImageView                  = [[UIImageView alloc] init];
        _statusImageView.clipsToBounds    = YES;
        _statusImageView.backgroundColor  = [UIColor clearColor];
        _statusImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [_loadView addSubview:_statusImageView];

        //
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_loadView addSubview:_activityView];

        //设置文字
        _statusLabel                  = [[UILabel alloc] init];
        _statusLabel.lineBreakMode    = NSLineBreakByCharWrapping;
        _statusLabel.textColor        = [UIColor whiteColor];
        _statusLabel.backgroundColor  = [UIColor clearColor];
        _statusLabel.textAlignment    = NSTextAlignmentCenter;
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _statusLabel.font             = [UIFont systemFontOfSize:16.0];
        _statusLabel.numberOfLines    = 0;
        [_loadView addSubview:_statusLabel];


        //设置frame
        [self adjustFrame:0];
    }
    return self;
}

//设置frame
- (void)adjustFrame:(NSTimeInterval)time {
    //子视图的上下间距
    CGFloat space = 18;

    //信息文本的最大宽度
    CGFloat maxWidth = self.width - 50*2-5*2;
    //计算文本的尺寸
    CGSize  size          = [_msg boundingRectWithSize:CGSizeMake(maxWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16.0], NSFontAttributeName, nil] context:nil].size;
    CGFloat loadViewWidth = size.width + space*2;

    //限制黑色背景视图的最小宽度
    if (loadViewWidth < 150) {
        loadViewWidth = 150;
    }

    //改变frame时需要动画效果则使用time 不需要则设置成0
    [UIView animateWithDuration:time animations:^{
        self.loadView.frame = CGRectMake((self.width-loadViewWidth)/2, (self.height-(36+size.height+space*3))/2, loadViewWidth, 36+size.height+space*3);
        self.statusImageView.frame = CGRectMake((self.loadView.width-36)/2, space, 36, 36);
        self.activityView.frame = self.statusImageView.frame;
        float loadLableX = (self.loadView.width-size.width)/2;
        self.statusLabel.frame = CGRectMake(loadLableX > 18 ? loadLableX : 18, self.statusImageView.bottom+space-2, size.width, size.height);
    }];
}

//设置图片
- (void)setImageName:(NSString *)imageName {
    _imageName = [imageName copy];
    if (imageName) {
        _statusImageView.image = [UIImage imageNamed:_imageName];
        _statusImageView.alpha = 1.0f;
    }
    else {
        _statusImageView.image = nil;
        _statusImageView.alpha = 0.0f;
    }
}

//开始动画
- (void)startAnimating {
    //方法1：通过无限调用startAnimating 实现无限循环旋转
    //    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    //        _statusImageView.transform = CGAffineTransformRotate(_statusImageView.transform, M_PI/2);
    //    } completion:^(BOOL finished) {
    //        if (self.isAnimating) {
    //            [self startAnimating];
    //        } else {
    //            _statusImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);
    //            _statusImageView.hidden = NO;
    //        }
    //    }];

    //方法2
    //    CABasicAnimation* rotationAnimation;
    //    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    //    rotationAnimation.duration = 1;
    //    rotationAnimation.cumulative = YES;
    //    rotationAnimation.repeatCount = 10;       //可以设置无限大得数值 实现无限循环旋转
    //    [_statusImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

    //方法3
    [_activityView startAnimating];
}

//停止动画
- (void)stopAnimating {
    _isAnimating = NO;
    [_activityView stopAnimating];

    //方法2
    //    _statusImageView.hidden = YES;
    //    [_statusImageView.layer removeAllAnimations];
}

#pragma mark -
#pragma mark - 设置状态
- (void)setLoadStatus:(UILoadStatus)loadStatus {
    _loadStatus = loadStatus;

    [self changeLoadStatus];
}

//根据状态显示对应的UI
- (void)changeLoadStatus {
    if (self.statusConfine == NO) {

        //设置提示文案 调整frame
        _statusLabel.text = _msg;
        [self adjustFrame:0.1];

        //根据状态改变图标及动画状态
        switch (_loadStatus) {
            case UILoadStart: {
                _statusConfine = YES;
                self.imageName = nil;    //@"Loading_icon";
                [self startAnimating];
                //开始加载到结束的最短时间间隔
                [self performSelector:@selector(theStatusConfine) withObject:self afterDelay:0.5];
                break;
            }

            case UILoadFail: {
                [self stopAnimating];
                self.imageName = @"com_pop_default";
                [self performSelector:@selector(hiddenLoadView) withObject:self afterDelay:1.0];
                break;
            }
            case UILoadSuccess: {
                [self stopAnimating];
                self.imageName = @"com_pop_finish";
                [self performSelector:@selector(hiddenLoadView) withObject:self afterDelay:9.0];
                break;
            }
            case UILoadHide:
            default: {
                [self stopAnimating];
                [self hiddenLoadView];
                break;
            }
        }
    }
}

//加载结束后回调
- (void)hiddenLoadView {
    if (self.finishBlock) {
        self.finishBlock();
    }
}

#pragma mark -
#pragma mark - 加载开始到结束之间的最短时间限制
- (void)theStatusConfine {
    _statusConfine = NO;

    //超过最短时间限制后 如果状态已不是开始加载状态 则进行状态切换
    if (self.loadStatus != UILoadStart) {
        [self changeLoadStatus];
    }
}

@end
