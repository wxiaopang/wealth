//
//  LoginViewController.m
//  wealth
//
//  Created by wangyingjie on 16/3/18.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "SetChangePwdViewController.h"
#import "MainViewController.h"



@interface LoginViewController ()<LARTextFeildDelegate>

@property (nonatomic, strong) LoginScrollView *allView;
@property (nonatomic, strong) LARTextFeildView *fristTextFeild;   /**<*/
@property (nonatomic, strong) LARTextFeildView *secondTextFeild;   /**<*/
@property (nonatomic, copy) NSString *topStr;   /**<*/
@property (nonatomic, copy) NSString *botStr;   /**<*/


@end

@implementation LoginViewController


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
        
        self.topStr = @"";
        self.botStr = @"";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self leftBarButtomItemWithNormalName:@"black_back" highName:@"nav_icon_back_click" selector:@selector(closeVC) target:self];
    self.navigationBarView.backgroundColor = [UIColor clearColor];
    self.navigationBarView.bottomLine.backgroundColor = [UIColor clearColor];
    
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
    ENDEDITING
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark- InitSubViews
- (void)setUpViews {
    UIImageView *bgImageView = [[UIImageView alloc] initImageViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) image:[UIImage imageNamed:@"background_image"] backgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgImageView];
    
    
    self.allView = [[LoginScrollView alloc] initViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) backgroundColor:[UIColor clearColor]];
    [self.view addSubview:_allView];
    [self.view sendSubviewToBack:_allView];
    [self.view sendSubviewToBack:bgImageView];
    
    
    @weakify(self);
    _allView.backBlock = ^{
        @strongify(self);
        [self back];
    };
    
    _allView.messageBlock = ^{
        @strongify(self);
        SetChangePwdViewController *vc = [[SetChangePwdViewController alloc] init];
        vc.isfromLogin = YES;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    _allView.topButtonBlock = ^{
        @strongify(self);
        [self userLogin];
    };
    
    _allView.botButtonBlock = ^{
        @strongify(self);
        RegistViewController *vc = [[RegistViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    
    self.fristTextFeild = _allView.fristTextFeild;
    self.secondTextFeild = _allView.secondTextFeild;
    self.fristTextFeild.LARDelegate = self;
    self.secondTextFeild.LARDelegate = self;
    
    
    
}

#pragma mark- NetWorking
- (void)netGetData {
    
}

- (void)userLogin{
    ENDEDITING
//    _topStr = @"13240103243";
//    _botStr = @"q123456";
    
    if ([self changeTheTextInput]) {
        return;
    }
    @weakify(self);
    [GET_CLIENT_MANAGER.loginManager customerLoginMethod:_topStr password:_botStr complete:^(id JSONResponse, NSError *error) {
        @strongify(self);
        if (error) {
             NSString *errMsg = ([JSONResponse objectForKey:@"msg"] ? [JSONResponse objectForKey:@"msg"] : kNetWorkError);
            [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:errMsg complete:^{ }];
        }
        else {
            NSInteger code = [[JSONResponse objectForKey:@"code"] integerValue];
            NSString *errMsg = ([JSONResponse objectForKey:@"msg"] ? [JSONResponse objectForKey:@"msg"] : kNetWorkError);
            if (code == ResponseErrorCode_OK) {
                if (self.fromType == LoginType_Gesture) {
                    kTrurnToRootViewController([MainViewController class]);
                }else{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
            else {
                [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:errMsg complete:^{ }];
            }
        }
    }];
    
    
}

#pragma mark- PublibMethod


#pragma mark- PrivateMethod
-(void)refresh {
    
}

- (void)closeVC{
    switch (_fromType) {
        case LoginType_Gesture:{
            kTrurnToRootViewController([MainViewController class]);
        }break;
        case LoginType_UserCenter:
        case LoginType_WebView:
        case LoginType_Other:
        case LoginType_Normal:
        default:{
            [self back];
        }break;
    }
}

- (BOOL)changeTheTextInput{
    if (_topStr) {
        if (_topStr.length != 11) {
            [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"请输入手机号" complete:^{
                [_allView.fristTextFeild.contentTextField becomeFirstResponder];
            }];
            return YES;
        }
    }else{
        [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"请输入手机号" complete:^{
            [_allView.fristTextFeild.contentTextField becomeFirstResponder];
        }];
        return YES;
    }
    if (_botStr.length<6) {
        [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"请输入密码" complete:^{
            [_allView.secondTextFeild clearTheTextField];
            [_allView.secondTextFeild.contentTextField becomeFirstResponder];
        }];
        return YES;
    }
    return NO;
}

#pragma mark -LARDelegate

- (BOOL)LARTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (!_isLogin && textField.tag == 1010) {
//        if (![self checkTheStringIsNumber:string]) {
//            return NO;
//        }
//    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString length] > 30) { //如果输入框内容大于20则弹出警告
        textField.text = [toBeString substringToIndex:30];
        if (textField.tag == 1010) {
            self.topStr = toBeString;
        }else if (textField.tag == 1011) {
            self.botStr = toBeString;
        }
        return NO;
    }
    
    if (textField.tag == 1010) {
        if (toBeString.length > 12) {
            textField.text = [toBeString substringToIndex:11];
            self.topStr = toBeString;
            return NO;
        }
        self.topStr = toBeString;
    }else if (textField.tag == 1011) {
        self.botStr = toBeString;
        if (toBeString.length > 20) {
            textField.text = [toBeString substringToIndex:20];
            self.botStr = toBeString;
            return NO;
        }
    }
    
    return YES;
}
- (void)LARTextFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1010) {
        self.topStr = textField.text;
    }else if (textField.tag == 1011) {
        self.botStr = textField.text;
    }
    
}
- (BOOL)LARTextFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}
- (BOOL)LARTextFieldShouldClear:(UITextField *)textField{
    
    return YES;
}




@end
