//
//  SetCheckPWDViewController.m
//  wealth
//
//  Created by wangyingjie on 16/4/20.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "SetCheckPWDViewController.h"
#import "SetPWDView.h"


@interface SetCheckPWDViewController ()

@property (nonatomic, strong) SetPWDView *mainView;

@end

@implementation SetCheckPWDViewController

#pragma mark- UIViewControllerLifeCycle
- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self leftBarButtomItemWithNormalName:@"back_white" highName:@"back_white" selector:@selector(closeVC) target:self];
//    [self rightBarButtomItemWithNormalName:@"white_phone" highName:@"white_phone" selector:@selector(callPhone) target:self];
    self.navigationBarView.title = @"验证登录密码";
    
    [self setUpViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark- InitSubViews
- (void)setUpViews {
    self.mainView = [[SetPWDView alloc] init];
    _mainView.frame = CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight-kNavigationBarHeight);
    [self.view addSubview:_mainView];
    [_mainView setMessage:@"请输入您的登录密码"];
    
    @weakify(self);
    _mainView.nextBlock = ^{
        @strongify(self);
        [self changeThePwd];
        
    };
    
    
}

#pragma mark- NetWorking
- (void)netGetData {
    
}

- (void)changeThePwd{
    if (_mainView.pwdString.length < 5) {
        [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"请输入新密码" complete:^{
            [_mainView.pwdTextField.myTextField becomeFirstResponder];
        }];
        return;
    }
    @weakify(self);
    [GET_CLIENT_MANAGER.loginManager checkThePassWord:_mainView.pwdString complete:^(NSString *errMsg) {
        @strongify(self);
        if (errMsg) {
            [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:errMsg complete:^{ }];
        }
        else {
            GET_CLIENT_MANAGER.loginManager.accountInformation.gesturePassword = @"";
            // 手势密码
            CustomNavigationViewController *navigationViewController = (CustomNavigationViewController *)ROOT_NAVIGATECONTROLLER;
            [GesturePasswordController presentGesturePasswordController:navigationViewController.visibleViewController complete:^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            }];
        }
    } ];
}

#pragma mark- PublibMethod


#pragma mark- PrivateMethod
-(void)refresh {
    
}

- (void)closeVC{
    [self back];
}

- (void)callPhone{
    [Utility telephoneCall:kPhoneNumber];
}

@end
