//
//  MainViewController.m
//  wealth
//
//  Created by wangyingjie on 16/3/14.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "MainViewController.h"
#import "MessageListViewController.h"

static __weak MainViewController *__g__mainViewController__ = nil;

@interface MainViewController ()

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic, strong) NSMutableArray           *viewControllers; //存放子控制器


@end

@implementation MainViewController

+ (MainViewController *)mainViewController {
    return __g__mainViewController__;
}

+ (void)setMessageCount:(NSInteger)messageCount {
    [__g__mainViewController__.tabView setMessageCount:messageCount];
}

+ (NSInteger)messageCount {
    return [__g__mainViewController__.tabView messageCount];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        __g__mainViewController__ = self;
        SEL swipeLeftAction = _allowSwipeCycling ? @selector(handleSwipeLeftWithCycling:) : @selector(handleSwipeLeft:);
        
        UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:swipeLeftAction];
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:leftSwipeGestureRecognizer];
        
        SEL swipeRightAction = _allowSwipeCycling ? @selector(handleSwipeRightWithCycling:) : @selector(handleSwipeRight:);
        
        UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:swipeRightAction];
        rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"====是大家的");
}

- (void)setEnableSwipeGestureRecognizers:(BOOL)enableSwipeGestureRecognizers {
    _enableSwipeGestureRecognizers = enableSwipeGestureRecognizers;
    if (_enableSwipeGestureRecognizers) {
        if (_leftSwipeGestureRecognizer == nil) {
            SEL swipeLeftAction = _allowSwipeCycling ? @selector(handleSwipeLeftWithCycling:) : @selector(handleSwipeLeft:);
            _leftSwipeGestureRecognizer           = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:swipeLeftAction];
            _leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
            [self.view addGestureRecognizer:_leftSwipeGestureRecognizer];
        }
        if (_rightSwipeGestureRecognizer == nil) {
            SEL swipeRightAction = _allowSwipeCycling ? @selector(handleSwipeRightWithCycling:) : @selector(handleSwipeRight:);
            _rightSwipeGestureRecognizer           = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:swipeRightAction];
            _rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
            [self.view addGestureRecognizer:_rightSwipeGestureRecognizer];
        }
    }
    else {
        if (_leftSwipeGestureRecognizer) {
            [self.view removeGestureRecognizer:_leftSwipeGestureRecognizer];
            _leftSwipeGestureRecognizer = nil;
        }
        if (_rightSwipeGestureRecognizer) {
            [self.view removeGestureRecognizer:_rightSwipeGestureRecognizer];
            _rightSwipeGestureRecognizer = nil;
        }
    }
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)swipe {
    if (self.enableSwipeGestureRecognizers && _selectedIndex - 1 >= 0) {
        _selectedIndex -= 1;
        [self.tabView tabBarButtonAction:(UIButton *)[self.tabView viewWithTag:_selectedIndex + TAG]];
    }
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)swipe {
    if (self.enableSwipeGestureRecognizers && _selectedIndex + 1 < _viewControllers.count) {
        _selectedIndex += 1;
        [self.tabView tabBarButtonAction:(UIButton *)[self.tabView viewWithTag:_selectedIndex + TAG]];
    }
}

- (void)handleSwipeLeftWithCycling:(UISwipeGestureRecognizer *)swipe {
    NSInteger nextIndex = self.selectedIndex - 1;
    _selectedIndex = nextIndex >= 0 ? nextIndex : self.viewControllers.count - 1;
    [self.tabView tabBarButtonAction:(UIButton *)[self.tabView viewWithTag:_selectedIndex + TAG]];
}

- (void)handleSwipeRightWithCycling:(UISwipeGestureRecognizer *)swipe {
    NSInteger nextIndex = self.selectedIndex + 1;
    _selectedIndex = nextIndex < self.viewControllers.count ? nextIndex : 0;
    [self.tabView tabBarButtonAction:(UIButton *)[self.tabView viewWithTag:_selectedIndex + TAG]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [GET_CLIENT_MANAGER.messageManager registThePushDeviceToken];
//    [GET_UM_ANALYTICS beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [GET_CLIENT_MANAGER.loginManager checkVersion];
    if (self.isInitializeOK) {
        if (kClientManagerUid > 0 && GET_CLIENT_MANAGER.loginManager.accountInformation.gesturePassword.length < 1) {
            self.isInitializeOK = NO;
        }
    }
    if (!self.isInitializeOK) {
        self.isInitializeOK = YES;
    
//        if (!GET_CLIENT_MANAGER.loginManager.isHiddeShowGesturePasswordController
//            && ![GesturePasswordController hasGesturePasswordControllerShowned]) {
            if (kClientManagerUid > 0 && GET_CLIENT_MANAGER.loginManager.accountInformation) {
                GET_CLIENT_MANAGER.loginManager.isHiddeShowGesturePasswordController = NO;
                
                // 手势密码
                CustomNavigationViewController *navigationViewController = (CustomNavigationViewController *)ROOT_NAVIGATECONTROLLER;
                [GesturePasswordController presentGesturePasswordController:navigationViewController.visibleViewController complete:^{
                    GET_CLIENT_MANAGER.pushManager.handleNotificationBlock = ^(NSDictionary *userInfo) {
                        NSLog(@"pushpushpush&&&&&&&&&&&&& %@",userInfo);
                        if (GET_CLIENT_MANAGER.pushManager.pushmodel) {
                            switch (GET_CLIENT_MANAGER.pushManager.pushmodel.pushtype) {
                                case 1:{
                                    WebMsgModel *webModel = [[WebMsgModel alloc] init];
                                    webModel.webTitle = @"消息详情";
                                    webModel.messageId = GET_CLIENT_MANAGER.pushManager.pushmodel.pushId;
                                    webModel.webLoadingType = WebViewType_Html_NoTitle;
                                    WebViewController *webVC = [[WebViewController alloc] init];
                                    [self.navigationController pushViewController:webVC animated:YES];
                                    webVC.webMessageModel = webModel;
                                }break;
                                
                                default:{
                                    
                                }break;
                            }
                        }
//                        MessageDetailViewController *vc = [[MessageDetailViewController alloc] init];
//                        vc.messageInformation = [[MessageInformation alloc] initWithDictionary:userInfo];
//                        ROOT_NAVIGATECONTROLLER_PUSH(vc);
                    };
                }];
            } else {
                [GET_CLIENT_MANAGER.loginManager userLogout];
                GET_CLIENT_MANAGER.pushManager.handleNotificationBlock = ^(NSDictionary *userInfo) {
                    NSLog(@"pushpushpush&&&&&&&&&&&&& %@",userInfo);
                    if (GET_CLIENT_MANAGER.pushManager.pushmodel) {
                        switch (GET_CLIENT_MANAGER.pushManager.pushmodel.pushtype) {
                            case 1:{
                                WebMsgModel *webModel = [[WebMsgModel alloc] init];
                                webModel.webTitle = @"消息详情";
                                webModel.messageId = GET_CLIENT_MANAGER.pushManager.pushmodel.pushId;
                                webModel.webLoadingType = WebViewType_Html_NoTitle;
                                WebViewController *webVC = [[WebViewController alloc] init];
                                [self.navigationController pushViewController:webVC animated:YES];
                                webVC.webMessageModel = webModel;
                            }break;
                            
                            default:{
                                
                            }break;
                        }
                    }
//                    MessageDetailViewController *vc = [[MessageDetailViewController alloc] init];
//                    vc.messageInformation = [[MessageInformation alloc] initWithDictionary:userInfo];
//                    ROOT_NAVIGATECONTROLLER_PUSH(vc);
                };
            }
//        }
//        else {
//            GET_CLIENT_MANAGER.pushManager.handleNotificationBlock = ^(NSDictionary *userInfo) {
//                MessageDetailViewController *vc = [[MessageDetailViewController alloc] init];
//                vc.messageInformation = [[MessageInformation alloc] initWithDictionary:userInfo];
//                ROOT_NAVIGATECONTROLLER_PUSH(vc);
//            };
//        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [GET_UM_ANALYTICS endLogPageView:NSStringFromClass([self class])];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewControllers = [[NSMutableArray alloc] initWithCapacity:4];
    
    //创建tabBar
    [self initTabBar];
    
    //初始化子视图控制器
    [self initViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - 自定义tabBar样式
- (void)initTabBar {
    self.tabView                  = [[TabView alloc] initWithFrame:CGRectMake(0, self.view.height - kTabBarHeight, self.view.width, kTabBarHeight)];
    self.tabView.bottom           = self.view.bottom;
    self.tabView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin;
    self.tabView.backgroundColor  = [UIColor whiteColor];
    [self.view addSubview:self.tabView];
    
    //tabBar点击回调事件
    @weakify(self);
    self.tabView.tabViewClick = ^(void){
        @strongify(self);
        
        if ( self.tabView.lastIndex != self.tabView.selectedIndex ) {
            if (self.tabView.selectedIndex == 1 && kClientManagerUid<=0) {
                [self jumpToLoginViewWitheAnimated:YES];
                return ;
            }
            
            ((AppDelegate *)GET_APP_DELEGATE).visitedPageNumber++;
            //先移除上次显示的视图
            [self removeLastView:self.tabView.lastIndex];
            //添加当前选中的视图
            [self showSeletcedView:self.tabView.selectedIndex];
        }
    };
}

#pragma mark -
#pragma mark - 加载控制器
- (void)initViewController {
//    [self.viewControllers addObject:[[HomeViewController alloc] init]];
    [self.viewControllers addObject:[[ProdudtionViewController alloc] init]];
    [self.viewControllers addObject:[[UCViewController alloc] init]];
    [self.viewControllers addObject:[[SetViewController alloc] init]];
    //默认显示第一个视图
    [self showSeletcedView:0];
}

#pragma mark -
#pragma mark - 移除上次点击tabBar对应的视图
- (void)removeLastView:(NSInteger)index {
    [self.viewControllers[index] removeFromParentViewController];
    [[self.viewControllers[index] view] removeFromSuperview];
}

+ (void)setSeletcedView:(NSInteger)index {
    if (index >= 0 && index < __g__mainViewController__.viewControllers.count) {
        [__g__mainViewController__ showSeletcedView:index];
        [__g__mainViewController__.tabView tabBarButtonAction:(UIButton *)[__g__mainViewController__.tabView viewWithTag:index + TAG]];
    }
}

//+ (void)setSeletcedSegment:(NSInteger)index {
//    [__g__mainViewController__.viewControllers.firstObject setSelectIndex:index];
//}

#pragma mark -
#pragma mark - 显示当前点击tabBar对应的视图
- (void)showSeletcedView:(NSInteger)index {
    LOG_BUTTON_ACTION(ActionType_34+index, nil);
    
    UIViewController *currentController = self.viewControllers[index];
    currentController.view.frame = CGRectMake(0, 0, self.view.width, self.view.height - 49);
    [self addChildViewController:currentController];
    [self.view insertSubview:currentController.view belowSubview:self.tabView];
    if (index == 0) {
        ProdudtionViewController *vc = (ProdudtionViewController *)currentController;
        [vc refresh];
    }
}

- (void)replaceViewController:(UIBaseViewController *)controller index:(NSInteger)index {
    if (controller == nil || index >= self.viewControllers.count) {
        return;
    }
    
    [self removeLastView:index];
    [self.viewControllers replaceObjectAtIndex:index withObject:controller];
    [UIView animateWithDuration:0.3f delay:0.0f
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                         [self showSeletcedView:index];
                     }
                     completion:nil];
}



@end
