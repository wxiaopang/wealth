//
//  SetChangePwdViewController.m
//  wealth
//
//  Created by wangyingjie on 16/3/23.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "SetChangePwdViewController.h"
#import "SetChangePWDView.h"

#import "SetPWDViewController.h"




@interface SetChangePwdViewController ()


@property (nonatomic, strong) SetChangePWDView *mainView;
@property (nonatomic, assign) BOOL isGetCode;


@end

@implementation SetChangePwdViewController

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
        self.isGetCode = YES;
        self.isfromLogin = NO;
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
    self.mainView = [[SetChangePWDView alloc] init];
    _mainView.frame = CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight-kNavigationBarHeight);
    [self.view addSubview:_mainView];
    
    [_mainView setMessage:@"请输入您注册时使用的手机号" AndPhone:@""];
    
    @weakify(self);
    _mainView.codeTextField.getCodeBlock = ^{
        @strongify(self);
        [self getCode];
    };
    
    _mainView.nextBlock = ^{
        @strongify(self);
        [self nextChangeThePwd];
    };
}

#pragma mark- NetWorking
- (void)netGetData {
    
}

-(void)getCode{
    ENDEDITING
    if ([self chickThePhoneInputText]) {
        return;
    }
    if (!self.isGetCode) {
        return;
    }
    self.isGetCode = NO;
    @weakify(self);
    [GET_CLIENT_MANAGER.loginManager getVerifyCodeMethod:_mainView.phoneString type:VerifyCodeType_Modify_PassWord complete:^(NSString *errMsg) {
        @strongify(self);
        self.isGetCode = YES;
        if (errMsg) {
            [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:errMsg complete:^{ }];
        }
        else {
//            [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"发送成功" complete:^{ }];
            [self.mainView.codeTextField startCountdown];
            
            [self.mainView setMessage:@"验证码已发送到手机" AndPhone:[Utility getHidePhoneNumber:_mainView.phoneString]];
        }
    }];
}

- (void)nextChangeThePwd{
    if ([self chickTheCodeInputText]) {
        return;
    }
    @weakify(self);
    [GET_CLIENT_MANAGER.loginManager loginModifyPasswordByPhoneMethod:_mainView.phoneString verifyCode:_mainView.codeString complete:^(NSString *errMsg) {
        @strongify(self);
        if (errMsg) {
            [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:errMsg complete:^{ }];
        }
        else {
            SetPWDViewController *vc = [[SetPWDViewController alloc] init];
            vc.phoneString = _mainView.phoneString;
            vc.codeString = _mainView.codeString;
            vc.isfromLogin = self.isfromLogin;
            [self.navigationController pushViewController:vc animated:YES];
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

- (BOOL)chickThePhoneInputText{
    if (_mainView.phoneString.length != 11) {
        [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"请输入正确手机号" complete:^{
            [_mainView.phoneTextField.myTextField becomeFirstResponder];
        }];
        return YES;
    }
    return NO;
}

- (BOOL)chickTheCodeInputText{
    if ([self chickThePhoneInputText]) {
        return YES;
    }
    if (_mainView.codeString.length < 1) {
        [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"请输入验证码" complete:^{
            [_mainView.codeTextField.myTextField becomeFirstResponder];
        }];
        return YES;
    }
    return NO;
}


@end
