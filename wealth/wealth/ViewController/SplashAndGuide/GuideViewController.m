//
//  GuideViewController.m
//  wealth
//
//  Created by wangyingjie on 15/2/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "GuideViewController.h"
#import "CustomNavigationViewController.h"
//#import "LogonViewController.h"
#import "MainViewController.h"
#import "UINavigationController+PortalTransition.h"
#import "CYRippleTransitionAnimator.h"

#define kGuideViewsCount   3

@interface GuideViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView      *guideScrollView;
@property (nonatomic, strong) CustomPageControl *pageController;
@property (nonatomic, assign) NSInteger         currentPageIndex;
@property (nonatomic, strong) UIView            *moveView;
@property (nonatomic, strong) UIButton          *enterBtn;
@property (nonatomic, assign) BOOL              initlizedOK;

@end

@implementation GuideViewController

//- (ViewControllerType)viewControllerType {
//    return ViewControllerType_1;
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [UIApplication sharedApplication].statusBarHidden = YES;
    [GET_UM_ANALYTICS beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [UIApplication sharedApplication].statusBarHidden = NO;
    [GET_UM_ANALYTICS endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.view.tag = ViewControllerType_1;

    // 标记非首次启动app
    [UserDefaultsWrapper setUserDefaultsObject:@(YES) forKey:kFirstLaunchApp];

    self.view.backgroundColor = [UIColor getColorWithR236G231B227];

    [self initSubViews];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSubViews {
    _guideScrollView                                = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _guideScrollView.alwaysBounceHorizontal         = NO;
    _guideScrollView.alwaysBounceVertical           = NO;
    _guideScrollView.showsHorizontalScrollIndicator = NO;
    _guideScrollView.showsVerticalScrollIndicator   = NO;
    _guideScrollView.pagingEnabled                  = YES;
    _guideScrollView.delegate                       = self;
    [self.view addSubview:_guideScrollView];

    for (NSUInteger i = 0; i < kGuideViewsCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*_guideScrollView.width, 0, _guideScrollView.width, _guideScrollView.height)];
        NSString    *imageName = [NSString stringWithFormat:@"star_page%@_%@", @(i+1), @(_guideScrollView.height)];
        imageView.image = [UIImage imageNamed:imageName];
        [_guideScrollView addSubview:imageView];
    }
    _guideScrollView.contentSize = CGSizeMake(_guideScrollView.width*kGuideViewsCount, _guideScrollView.height);

    _pageController                           = [[CustomPageControl alloc] initWithFrame:CGRectMake(0, self.view.height - kStatusBarHeight - kNavigationBarHeight+20, self.view.width, 20)];
    _pageController.alignment                 = CustomPageControlAlignmentCenter;
    _pageController.verticalAlignment         = CustomPageControlVerticalAlignmentMiddle;
    _pageController.numberOfPages             = kGuideViewsCount;
    _pageController.currentPage               = 0;
    _pageController.pageIndicatorImage        = [UIImage imageNamed:@"screen_other"];
    _pageController.currentPageIndicatorImage = [UIImage imageNamed:@"screen_present"];
    [self.view addSubview:_pageController];

    _enterBtn = [Utility configCommoButton:CGRectMake((self.view.width - 115.0f) / 2, _pageController.top-16.0f, 115.0f, 39.0f)
                                      text:@"立即体验"
                                 textColor:[UIColor button2TitleNormalColor]
                                    normal:[UIColor button2BackgroundNormalColor]
                                 highlight:[UIColor button2BackgroundHighlightColor]
                                   disable:[UIColor button2BackgroundDisableColor]];
    _enterBtn.btnFunctionId = ActionType_1;
    _enterBtn.hidden          = YES;
    _enterBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.view addSubview:_enterBtn];

    @weakify(self);
    [[self.enterBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        LOG_BUTTON_ACTION(ActionType_1, nil);
        if (self.enterBtn.alpha == 1.0f) {
            if (GET_CLIENT_MANAGER.loginManager.status == LoginStatus_Success) {
                ROOT_NAVIGATECONTROLLER_POPTOROOT;
            }
            else {
                kTrurnToRootViewController([MainViewController class]);
            }
        }
    }];

    [[RACObserve(_pageController, currentPage) distinctUntilChanged] subscribeNext:^(id x) {
        @strongify(self);
        if ([x integerValue] == 2 && !self.initlizedOK) {
            self.enterBtn.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
            [UIView animateWithDuration:0.3f delay:1.0f options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.enterBtn.hidden = NO;
                                 self.enterBtn.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                             } completion:^(BOOL finished) {
                                 self.initlizedOK = YES;
                             }];
        }
    }];
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.initlizedOK) {
        self.enterBtn.alpha = (scrollView.contentOffset.x - self.view.width) / self.view.width;
    }

    NSInteger page = floor((scrollView.contentOffset.x - scrollView.width / 2) / scrollView.width) + 1;
    if (page != _pageController.currentPage) {
        _pageController.currentPage = page;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //    if ( scrollView.contentOffset.x > (self.view.width*(kGuideViewsCount-1) + 20) ) {
    //        if ( GET_CLIENT_MANAGER.loginManager.status == LoginStatus_Success ) {
    //            ROOT_NAVIGATECONTROLLER_POPTOROOT;
    //        } else {
    //            kTrurnToRootViewController([LogonViewController class]);
    //        }
    //    }
}

//引导页滑动到最后一页显示进入爱钱进的动画
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //    if (_pageController.currentPage == 2
    //        && _moveView.hidden == YES
    //        && _moveView.alpha == 0 ) {
    //        [self startAnimation];
    //    }
}

@end
