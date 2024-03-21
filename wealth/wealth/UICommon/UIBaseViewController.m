//
//  UIBaseViewController.m
//  wealth
//
//  Created by wangyingjie on 15/2/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UIBaseViewController.h"
#import "AppDelegate.h"

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "MainViewController.h"



#define kLogonConflictTag 9000

@interface UIBaseViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *notificationView;

@property (nonatomic, assign) BOOL isShowLoginStatusFailed;

@end

@implementation UIBaseViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

//- (ViewControllerType)viewControllerType {
//    return ViewControllerType_0;
//}

- (UITableView *)mainTableView {
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [GET_UM_ANALYTICS beginLogPageView:NSStringFromClass([self class])];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusConflit:) name:kLoginStatusConflit object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusFailed:) name:kLoginStatusFailed object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [GET_UM_ANALYTICS endLogPageView:NSStringFromClass([self class])];

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [self.navigationBarView.activityIndicatorView stopAnimating];
    ENDEDITING
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isShowLoginStatusFailed = NO;
//    self.view.tag = self.viewControllerType;
    self.isUserInterfaceEnable = YES;
    
    [self customInitSubviews];
    [self customLayoutSubviews];
    [self customRAC];
}

- (void)customInitSubviews {
    _navigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kNavigationBarHeight)];
    _navigationBarView.backgroundColor = [UIColor get_9_Color];
    self.view.backgroundColor = [UIColor viewControllerBackgroundColor];
    [self.view addSubview:_navigationBarView];
    
    //初始化没网页面
    self.nonetWorkView=[[UINoNetWorkView alloc]initWithFrame:CGRectMake(0,kNavigationBarHeight,ScreenWidth,ScreenHeight-kNavigationBarHeight)];
    [self.view addSubview:self.nonetWorkView];
    self.nonetWorkView.delegate=self;
    self.nonetWorkView.hidden=YES;
    
    
    //初始化空白页
    self.blankView=[[UIBlankView alloc]initWithFrame:CGRectMake(0,kNavigationBarHeight,ScreenWidth,ScreenHeight-kNavigationBarHeight)];
    [self.view addSubview:self.blankView];
    self.blankView.hidden=YES;
    
    
    //初始化网络繁忙页面
//    self.serverBusyView=[[UIServerBusyView alloc]initWithFrame:CGRectMake(0,kNavigationBarHeight,ScreenWidth,ScreenHeight-kNavigationBarHeight)];
//    [self.view addSubview:self.serverBusyView];
//    self.serverBusyView.hidden=YES;

}

- (void)customLayoutSubviews {
    @weakify(self);
    [_navigationBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(kNavigationBarHeight));
    }];
}

- (void)customRAC {
//    self.keyboardPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                              action:@selector(panGestureDidChange:)];
//    [self.keyboardPanRecognizer setMinimumNumberOfTouches:1];
//    [self.keyboardPanRecognizer setDelegate:self];
//    [self.keyboardPanRecognizer setCancelsTouchesInView:NO];
//    [self addGestureRecognizer:self.keyboardPanRecognizer];

    UITapGestureRecognizer *keyboardTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                     action:@selector(tapGestureDidChange:)];
    keyboardTapGestureRecognizer.cancelsTouchesInView = NO;
    keyboardTapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:keyboardTapGestureRecognizer];
}

- (UIButton *)notificationView {
    if ( _notificationView == nil ) {
        _notificationView = [UIButton buttonWithType:UIButtonTypeCustom];
        _notificationView.enabled = NO;
        _notificationView.frame = CGRectMake(0, 0, self.view.width, kNavigationBarHeight);
        _notificationView.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 16.0f, 0, 16.0f);
        _notificationView.hidden = YES;
        _notificationView.backgroundColor = [UIColor getColorWithR229G232B239];
        [_notificationView setTitleColor:[UIColor messageBubbleColor] forState:UIControlStateDisabled];
        _notificationView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _notificationView.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _notificationView.titleLabel.numberOfLines = 0;
        _notificationView.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.view insertSubview:_notificationView belowSubview:_navigationBarView];
    }
    return _notificationView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"%@ didReceiveMemoryWarning", NSStringFromClass([self class]));
}

- (void)leftBarButtomItemWithNormalName:(NSString*)normalName
                               highName:(NSString *)highName
                               selector:(SEL)selector
                                 target:(id)target {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImage = [UIImage imageNamed:normalName];
    if (IOS_VERSION >= 7.0f) {
        leftButton.frame = CGRectMake(-4, 20, 44, kNavigationBarHeight - 20);
    } else {
        leftButton.frame = CGRectMake(-4, 0, 44, kNavigationBarHeight);
    }
    [leftButton setImage:normalImage forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:highName] forState:UIControlStateHighlighted];
    [leftButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView setLeftBtn:leftButton];
}

- (void)rightBarButtomItemWithNormalName:(NSString*)normalName
                                highName:(NSString *)highName
                                selector:(SEL)selector
                                  target:(id)target {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImage = [UIImage imageNamed:normalName];
    if (IOS_VERSION >= 7.0f) {
        rightButton.frame = CGRectMake(ScreenWidth - 43, 20, 44, kNavigationBarHeight - 20);
    } else {
        rightButton.frame = CGRectMake(ScreenWidth - 43, 0, 44, kNavigationBarHeight);
    }
    [rightButton setImage:normalImage forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:highName] forState:UIControlStateHighlighted];
    [rightButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView setRightBtn:rightButton];
}

- (void)leftBarButtomItemWithTitle:(NSString*)title
                          selector:(SEL)selector
                            target:(id)target {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    leftButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    CGSize size = [title boundingRectWithSize:CGSizeMake(ScreenWidth, self.navigationBarView.frame.size.height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                   attributes:@{ NSFontAttributeName:leftButton.titleLabel.font }
                                      context:nil].size;
    [leftButton setTitle:title forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.frame = CGRectMake(16, 20, size.width, kNavigationBarHeight - 20);
    [leftButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView setLeftBtn:leftButton];
}

- (void)rightBarButtomItemWithTitle:(NSString*)title
                           selector:(SEL)selector
                             target:(id)target {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
   
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    CGSize size = [title boundingRectWithSize:CGSizeMake(ScreenWidth, self.navigationBarView.frame.size.height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                   attributes:@{ NSFontAttributeName:rightButton.titleLabel.font }
                                      context:nil].size;
    [rightButton setTitle:title forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor clearColor];
    rightButton.frame = CGRectMake(ScreenWidth-16-size.width, 20, size.width, kNavigationBarHeight - 20);
    [rightButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView setRightBtn:rightButton];
}

- (void)back {
    if ( self.isModalViewController ) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showNotificationView:(NSString *)title dismissAfter:(NSTimeInterval)duration {
//    [CSNotificationView showInViewController:self
//                                   tintColor:[UIColor getColorWithR229G232B239]
//                                contentColor:[UIColor messageBubbleColor]
//                                       image:nil
//                                     message:title
//                                    duration:duration];

    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(self.notificationView.titleLabel.width, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{ NSFontAttributeName:self.notificationView.titleLabel.font }
                                           context:nil].size;
    [self.notificationView setTitle:title forState:UIControlStateDisabled];
    self.notificationView.hidden = NO;
    if ( duration > 0.0f ) {
        @weakify(self);
        [UIView animateWithDuration:0.3f delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             @strongify(self);
                             self.notificationView.top = kNavigationBarHeight;
                             self.notificationView.height = titleSize.height + 32;
                         } completion:^(BOOL finished) {
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                 @strongify(self);
                                 [self hideNotificationView];
                             });
                         }];
    } else {
        self.notificationView.top = kNavigationBarHeight;
        self.notificationView.height = titleSize.height + 32;
    }
}

- (void)hideNotificationView {
    @weakify(self);
    [UIView animateWithDuration:0.3f delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         @strongify(self);
                         self.notificationView.top = 0;
                         self.notificationView.height = kNavigationBarHeight;
                     } completion:^(BOOL finished) {
                         self.notificationView.hidden = YES;
                     }];
}

/**
 *  视图顶部显示的提示信息 信息显示时当前页面视图下移
 *  msg         : 提示的文案
 *  bottomView  : 提示文案视图下部的视图
 *  space       : 提示视图与其下部视图的顶部之间的距离
 */
+ (void)showAlertMsg:(NSString *)msg
          bottomView:(UIView *)bottomView
               space:(CGFloat)space
{
    //提示视图将当前视图下推
    CustomNavigationViewController *navigationViewController = (CustomNavigationViewController *)ROOT_NAVIGATECONTROLLER;
    UIViewController *viewController = navigationViewController.visibleViewController;
    if ( [viewController isKindOfClass:NSClassFromString(@"MainViewController")] ) {
        viewController = viewController.childViewControllers.firstObject;
    }
    if ( bottomView == nil ) {
        bottomView = viewController.view;
        if ( [viewController isKindOfClass:NSClassFromString(@"UIBaseViewController")] ) {
            bottomView = ((UIBaseViewController *)viewController).mainTableView;
        }
    }
    UIMsgDialogView * dialog = [[UIMsgDialogView alloc] initWithText:msg
                                                       withSuperView:viewController.view
                                                          bottomView:bottomView
                                                               space:space];
    [dialog show];
}

+ (void)showLoadingToast:(NSString *)title {
//    [[UIToastView sharedToast] setOverlayMode:UIToastWindowOverlayModeGradient];
//    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:12];
//    for (NSInteger i = 0; i < 12; i++) {
//        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"com_pop_refresh%@", @(i)]]];
//    }
//    [UIToastView showWithTitle:nil status:title images:images];
//    [[UIToastView sharedToast] setOverlayMode:UIToastWindowOverlayModeNone];
//    [UIToastView setPresentationStyle:UIToastPresentationStyleFade];
}

+ (void)showTextToastWithTitle:(NSString *)title dismissAnimationCompletion:(dispatch_block_t)block {
//    [UIToastView setPresentationStyle:UIToastPresentationStyleFade];
//    [[UIToastView sharedToast] setOverlayMode:UIToastWindowOverlayModeGradient];
//    [UIToastView sharedToast].dismissAnimationCompletion = block;
//    [UIToastView showWithTitle:nil status:title images:nil];
//    [UIToastView dismissWithStatus:title title:nil afterDelay:1];
    
}

+ (void)disMissLoadingToast {
//    [UIToastView dismiss];
}

+ (void)configProgressSetting:(dispatch_block_t)progressCompletion cancelBlock:(dispatch_block_t)cancelBlock {
//    [UIToastView setPresentationStyle:UIToastPresentationStyleFade];
//    [[UIToastView sharedToast] setOverlayMode:UIToastWindowOverlayModeGradient];
//    [[UIToastView sharedToast] setProgressStyle:UIToastProgressStyleRadial];
//    [UIToastView sharedToast].progressCompletion = progressCompletion;
//    [UIToastView sharedToast].cancelBlock = cancelBlock;
}

+ (void)updateProgress:(CGFloat)progress withStatus:(NSString *)status title:(NSString *)title {
//    [UIToastView updateProgress:progress withStatus:status title:title];
}


//+ (EjectSelectView *)showEjectSelectView:(NSArray *)dataArray viewType:(EjectSelectViewType)viewType {
//    EjectSelectView * view = [[EjectSelectView alloc]initWithData:dataArray andViewType:viewType];
//    return view;
//}

#pragma mark - UINoNetWorkViewDelegate delegate
- (void)reloadButtonClick {
}

#pragma mark -显示没网页面
-(void)showNoNetWorkView:(CGRect)frame{
    if (self.nonetWorkView!=nil) {
        self.nonetWorkView.frame=frame;
        self.nonetWorkView.hidden=NO;
        self.blankView.hidden=YES;
//        self.serverBusyView.hidden=YES;
        [self.view bringSubviewToFront:self.nonetWorkView];
    }
}

-(void)showNoNetWorkView:(CGRect)frame onView:(UIView *)view {
    if (self.nonetWorkView!=nil) {
        self.nonetWorkView.frame=frame;
        self.nonetWorkView.hidden=NO;
        self.blankView.hidden=YES;
//        self.serverBusyView.hidden=YES;
        [view addSubview:self.nonetWorkView];
    }
}

#pragma mark -隐藏没网页面
-(void)hideNoNetWorkView{
    if (self.nonetWorkView!=nil) {
        self.nonetWorkView.hidden=YES;
    }
}
#pragma mark -显示空白页面
-(void)showBlankView:(CGRect)frame{
    if (self.blankView!=nil) {
        self.blankView.frame=frame;
        self.blankView.hidden=NO;
        self.nonetWorkView.hidden=YES;
//        self.serverBusyView.hidden=YES;
        [self.view bringSubviewToFront:self.blankView];
    }
}

-(void)showBlankView:(CGRect)frame onView:(UIView *)view {
    if (self.blankView!=nil) {
        self.blankView.frame=frame;
        self.blankView.hidden=NO;
        self.nonetWorkView.hidden=YES;
//        self.serverBusyView.hidden=YES;
        [view addSubview:self.blankView];
    }
    
}

#pragma mark -隐藏空白页面
-(void)hideBlankView{
    if (self.blankView!=nil) {
        self.blankView.hidden=YES;
    }
}
//#pragma mark -显示网络繁忙页面
//-(void)showServerBusyView:(CGRect)frame{
//    if (self.serverBusyView!=nil) {
//        self.serverBusyView.frame=frame;
//        self.serverBusyView.hidden=NO;
//        self.nonetWorkView.hidden=YES;
//        self.blankView.hidden = YES;
//        [self.view bringSubviewToFront:self.serverBusyView];
//    }
//    
//}
//-(void)showServerBusyView:(CGRect)frame onView:(UIView *)view {
//    if (self.serverBusyView!=nil) {
//        self.serverBusyView.frame=frame;
//        self.serverBusyView.hidden=NO;
//        self.nonetWorkView.hidden=YES;
//        self.blankView.hidden = YES;
//        [view addSubview:self.serverBusyView];
//    }
//    
//}
//#pragma mark -隐藏网络繁忙页面
//-(void)hideServerBusyView{
//    if (self.serverBusyView!=nil) {
//        self.serverBusyView.hidden=YES;
//    }
//}






#pragma mark -- 键盘手势相关的

- (void)tapGestureDidChange:(UITapGestureRecognizer *)tap {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark -gestures
//优先响应button事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}


- (void)logoutTheUser{
    [GET_CLIENT_MANAGER.loginManager userLogout];
}


- (void)jumpToLoginViewWitheAnimated:(BOOL)animated{
    LoginViewController *viewController=[[LoginViewController alloc]init];
    UINavigationController *rootcontroller = (UINavigationController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    CATransition *animation = [CATransition animation];
    [animation setDuration:kPushAnimationTime];
    [animation setType: kCATransitionMoveIn];
    [animation setSubtype: kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [rootcontroller pushViewController:viewController animated:animated];
    [rootcontroller.view.layer addAnimation:animation forKey:nil];
}



- (void)loginStatusConflit:(NSNotification *)notification {
    @synchronized(self) {
        
        if ( !self.isShowLoginStatusFailed && GET_CLIENT_MANAGER.loginManager.status == LoginStatus_Success) {
            self.isShowLoginStatusFailed = YES;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:notification.userInfo[@"message"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"重新登录",nil];
            @weakify(self);
            [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                [self.navigationController popToRootViewControllerAnimated:NO];
                [MainViewController setSeletcedView:0];
                @strongify(self);
                self.isShowLoginStatusFailed = NO;
                buttonIndex == 1 ? [self jumpToLoginViewWitheAnimated:YES] : nil;
            }];
        }
        [self logoutTheUser];
    }
}

- (void)loginStatusFailed:(NSNotification *)notification {
    @synchronized(self) {
        if (  !self.isShowLoginStatusFailed && GET_CLIENT_MANAGER.loginManager.status == LoginStatus_Success) {
            self.isShowLoginStatusFailed = YES;
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"登录已失效，请重新登录"
                                                               delegate:nil
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"重新登录",nil];
            @weakify(self);
            [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                @strongify(self);
                [self.navigationController popToRootViewControllerAnimated:NO];
                [MainViewController setSeletcedView:0];
                self.isShowLoginStatusFailed = NO;
                buttonIndex == 1 ? [self jumpToLoginViewWitheAnimated:YES] : nil;
            }];
        }
        [self logoutTheUser];
    }
}






@end

#pragma mark- 下拉刷新UIRefreshHeader类目
@implementation UIBaseViewController (refreshHeader)
-(void)endRefreshHeaderFrom:(MJRefreshHeader *)header andCode:(int)code {
    if (code != 999) {
        header.refreshCode = code;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [header endRefreshing];
        });
    }
}

@end
