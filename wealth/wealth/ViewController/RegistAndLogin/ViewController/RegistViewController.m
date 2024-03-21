//
//  RegistViewController.m
//  wealth
//
//  Created by wangyingjie on 16/3/18.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "RegistViewController.h"
#import "RegistScrollView.h"
#import "RegistFinshView.h"



@interface RegistViewController ()

@property (nonatomic, strong) RegistScrollView *allView;
@property (nonatomic, strong) RegistFinshView *finshView;

@property (nonatomic, assign) BOOL isGetCode;
@property (nonatomic, assign) BOOL isRegist;



@end

@implementation RegistViewController

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
        self.isRegist = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarView.backgroundColor = [UIColor clearColor];
    self.navigationBarView.bottomLine.backgroundColor = [UIColor clearColor];
    self.navigationBarView.title = @"注册";
    self.navigationBarView.titleColor = [UIColor get_2_Color];
    
    [self leftBarButtomItemWithNormalName:@"black_back" highName:@"nav_icon_back_click" selector:@selector(closeVC) target:self];
    [self rightBarButtomItemWithNormalName:@"black_phone" highName:@"black_phone" selector:@selector(callPhone) target:self];
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
    
    self.finshView = [[RegistFinshView alloc] initWithFrame:CGRectMake(0, -ScreenHeight, ScreenWidth, ScreenHeight )];
    [self.view addSubview:_finshView];
    [self.view sendSubviewToBack:_finshView];
    
    UIImageView *bgImageView = [[UIImageView alloc] initImageViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) image:[UIImage imageNamed:@"background_image"] backgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgImageView];
    
    
    self.allView = [[RegistScrollView alloc] initViewWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight-kNavigationBarHeight) backgroundColor:[UIColor clearColor]];
    [self.view addSubview:_allView];
    [self.view sendSubviewToBack:_allView];
    [self.view sendSubviewToBack:bgImageView];
    
    @weakify(self);
    _allView.topButtonBlock = ^{
        @strongify(self);
        [self userRegister];
    };
    _allView.botButtonBlock = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    _allView.codeTextFeild.getCodeBlock = ^(){
        @strongify(self);
        [self getCode];
    };
    _allView.messageBlock = ^{
        @strongify(self);
        [self seeTheTreaty];
    };
    _finshView.gotoHomepage = ^{
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    _finshView.bankBlock = ^{
        
    };
    
}

#pragma mark- NetWorking
- (void)netGetData {
    
}

- (void)getCode{
    ENDEDITING
    if (!_allView.phoneString || _allView.phoneString.length != 11) {
        [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"请输入手机号" complete:^{
            [_allView.phoneTextFeild.myTextField becomeFirstResponder];
        }];
        return ;
    }
    if (!self.isGetCode) {
        return;
    }
    self.isGetCode = NO;
    @weakify(self);
    [GET_CLIENT_MANAGER.loginManager getVerifyCodeMethod:_allView.phoneString type:VerifyCodeType_Regist complete:^(NSString *errMsg) {
        @strongify(self);
        self.isGetCode = YES;
        if (errMsg) {
            [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:errMsg complete:^{ }];
        }
        else {
            [self.allView.codeTextFeild startCountdown];
        }
    }];
    
}

- (void)userRegister{
    ENDEDITING
    if ([self changeTheTextInput]) {
        return;
    }
    if (!self.isRegist) {
        return;
    }
    self.isRegist = NO;
    @weakify(self);
    [GET_CLIENT_MANAGER.loginManager checkRegisterVerifyMethod:_allView.phoneString verifyCode:_allView.codeString passWord:_allView.pwd1String complete:^(NSString *errMsg) {
        @strongify(self);
        
        if (errMsg) {
            [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:errMsg complete:^{ }];
            self.isRegist = YES;
        }
        else {
            [UIView animateWithDuration:0.2 animations:^{
                _finshView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            } completion:^(BOOL finished) {
                [self.allView removeFromSuperview];
                self.allView.hidden = YES;
                [self leftBarButtomItemWithNormalName:@"" highName:@"" selector:@selector(click) target:self];
                self.isRegist = YES;
            }];
        }
    }];
}

#pragma mark- PublibMethod


#pragma mark- PrivateMethod
-(void)refresh {
    
}


- (BOOL)changeTheTextInput{
    if (!_allView.phoneString || _allView.phoneString.length != 11) {
        [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"请输入正确手机号" complete:^{
            [_allView.phoneTextFeild.myTextField becomeFirstResponder];
        }];
        return YES;
    }
    if (!_allView.codeString || _allView.codeString.length < 2) {
        [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"请输入验证码" complete:^{
            [_allView.codeTextFeild.myTextField becomeFirstResponder];
        }];
        return YES;
    }
    if (!_allView.pwd1String || _allView.pwd1String.length < 1) {
        [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"请输入密码" complete:^{
            [_allView.pwdEyeTextFeild.myTextField becomeFirstResponder];
        }];
        return YES;
    }else if (!_allView.pwd1String || _allView.pwd1String.length < 6){
        [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"密码错误" complete:^{
            [_allView.pwdEyeTextFeild.myTextField becomeFirstResponder];
        }];
        return YES;
    }
//    if (!_allView.pwd2String || _allView.pwd2String.length != 11) {
//        [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"请再次输入密码" complete:^{
//            [_allView.pwdTextFeild.myTextField becomeFirstResponder];
//        }];
//        return YES;
//    }
//    if (![_allView.pwd1String isEqualToString:_allView.pwd2String]) {
//        [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"两次密码输入不一致" complete:^{
//            [_allView.pwdTextFeild.myTextField becomeFirstResponder];
//        }];
//        return YES;
//    }
    return NO;
}

- (void)closeVC{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)callPhone{
    [Utility telephoneCall:kPhoneNumber];
}

- (void)click{
    return;
}

- (void)seeTheTreaty{
    WebMsgModel *webModel = [[WebMsgModel alloc] init];
    webModel.webTitle = @"";
    webModel.webUrl = [NSString stringWithFormat:@"%@/regAgreement.jsp",HTML5_URL];
    webModel.webLoadingType = WebViewType_Url;
    WebViewController *webVC = [[WebViewController alloc] init];
    [self.navigationController pushViewController:webVC animated:YES];
    webVC.webMessageModel = webModel;
}

@end

