//
//  SplashViewController.m
//  wealth
//
//  Created by wangyingjie on 15/2/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "SplashViewController.h"
#import "CustomNavigationViewController.h"
//#import "LogonViewController.h"
//#import "GuideViewController.h"
#import "MainViewController.h"
#import "LoginViewController.h"

@interface SplashViewController ()

@property (nonatomic, strong) UIImageView *splashImageView;

@end

@implementation SplashViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 设置 状态栏文字颜色
    [UIApplication sharedApplication].statusBarHidden = YES;
//    [GET_UM_ANALYTICS beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // 设置 状态栏文字颜色
    [UIApplication sharedApplication].statusBarHidden = NO;
//    [GET_UM_ANALYTICS endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.tag = ViewControllerType_0;

    _splashImageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIImage *image = [UIImage imageWithContentsOfFile:[PathEngine pathForResource:@"Default-736h@3x" ofType:@"png"]];
    if (iPhone4 || iPhone4s) {
        image = [UIImage imageWithContentsOfFile:[PathEngine pathForResource:@"Default@2x" ofType:@"png"]];
    }
    else if (iPhone5) {
        image = [UIImage imageWithContentsOfFile:[PathEngine pathForResource:@"Default-568h@2x" ofType:@"png"]];
    }
    else if (iPhone6) {
        image = [UIImage imageWithContentsOfFile:[PathEngine pathForResource:@"Default-667h@2x" ofType:@"png"]];
    }
    else if (iPhone6Plus) {
        image = [UIImage imageWithContentsOfFile:[PathEngine pathForResource:@"Default-736h@3x" ofType:@"png"]];
    }
    _splashImageView.image = image;
    [self.view addSubview:_splashImageView];

    [self customRAC];
}

- (void)customRAC {
//    @weakify(self);
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        @strongify(self);
    [GET_CLIENT_MANAGER initInformation];
    if ([UserDefaultsWrapper userDefaultsObject:kFirstLaunchApp]) {
        if (kClientManagerUid > 0) {
            NSString *viewControllerClass = @"MainViewController";
            kTrurnToRootViewController(NSClassFromString(viewControllerClass));
            
        }else {
            kTrurnToRootViewController([MainViewController class]);
        }
    }
    else {
        [UserDefaultsWrapper setUserDefaultsObject:@(YES) forKey:kFirstLaunchApp];
        kTrurnToRootViewController([MainViewController class]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 默认不支持横竖屏
// 特殊页面需要支持横竖屏的，自行重写这些方法
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait);
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
