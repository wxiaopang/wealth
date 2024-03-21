//
//  SetPWDViewController.m
//  wealth
//
//  Created by wangyingjie on 16/3/23.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "SetPWDViewController.h"
#import "SetPWDView.h"
#import "LoginViewController.h"




@interface SetPWDViewController ()

@property (nonatomic, strong) SetPWDView *mainView;
@property (nonatomic, assign) BOOL isGetCode;


@end

@implementation SetPWDViewController

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
        self.phoneString = @"";
        self.codeString = @"";
        self.isGetCode = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self leftBarButtomItemWithNormalName:@"back_white" highName:@"back_white" selector:@selector(closeVC) target:self];
    [self rightBarButtomItemWithNormalName:@"white_phone" highName:@"white_phone" selector:@selector(callPhone) target:self];
    self.navigationBarView.title = @"找回密码";
    
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
    [GET_CLIENT_MANAGER.loginManager loginModifyPasswordByPhoneMethod:_phoneString verifyCode:_codeString password:_mainView.pwdString complete:^(NSString *errMsg) {
        @strongify(self);
        if (errMsg) {
            [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:errMsg complete:^{ }];
        }
        else {
            
            if (!self.isfromLogin) {
                [GET_CLIENT_MANAGER.loginManager.accountInformation save];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                for (UIViewController *contrller in self.navigationController.viewControllers) {
                    if ([contrller isKindOfClass:[LoginViewController class]]) {
                        [self.navigationController popToViewController:contrller animated:YES];
                        return;
                    }
                }
            }
        }
    }];
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
