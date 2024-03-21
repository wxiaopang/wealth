//
//  UCAddBankmsgViewController.m
//  wealth
//
//  Created by wangyingjie on 16/4/19.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UCAddBankmsgViewController.h"
#import "UCMyBankMsgView.h"
#import "UCAddBankViewController.h"




@interface UCAddBankmsgViewController ()<selectBankDelegate>

@property (nonatomic, strong) UCMyBankMsgView *mainView;
@property (nonatomic, strong) BankMessageModel *model;

@property (nonatomic, assign) BOOL isenTouch;


@end

@implementation UCAddBankmsgViewController

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
        
        self.isenTouch = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self leftBarButtomItemWithNormalName:@"back_white" highName:@"back_white" selector:@selector(back) target:self];
//    [self rightBarButtomItemWithNormalName:@"black_phone" highName:@"black_phone" selector:@selector(callPhone) target:self];
    self.navigationBarView.title = @"填写鉴权信息";
    
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
    self.mainView = [[UCMyBankMsgView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight-kNavigationBarHeight)];
    [self.view addSubview:_mainView];
    
    @weakify(self);
    _mainView.bankSelectBlock = ^{
        @strongify(self)
        NSLog(@"bankSelectBlock\n");
        UCAddBankViewController *addBankVC = [[UCAddBankViewController alloc] init];
        addBankVC.delegate = self;
        [self.navigationController pushViewController:addBankVC animated:YES];
    };
    _mainView.nextBlock = ^{
        @strongify(self)
        NSLog(@"nextBlock\n");
        [self submitTheMessage];
    };
}

#pragma mark- NetWorking
- (void)netGetData {
    
}
- (void)submitTheMessage{
    if ([self checkTheInput]) {
        return;
    }
    NSDictionary *messageDic = @{@"idCard":[EncryptEngine encryptRSA:_mainView.idcard publicKey:@""],
                                 @"mobile":[EncryptEngine encryptRSA:_mainView.phone publicKey:@""],
                                 @"bankCode":[EncryptEngine encryptRSA:_model.code publicKey:@""],
                                 @"accountNo":[EncryptEngine encryptRSA:_mainView.bankNo publicKey:@""],
                                 @"accountName":[EncryptEngine encryptRSA:_mainView.name publicKey:@""],
                                 @"bankName":[EncryptEngine encryptRSA:_model.value publicKey:@""]};
    if (!_isenTouch) {
        return;
    }
    self.isenTouch = NO;
    @weakify(self)
    [GET_CLIENT_MANAGER.userCenterManager submitTheBankMessageWithDic:messageDic Complete:^(NSString *errMsg) {
        @strongify(self)
        self.isenTouch = YES;
        if (errMsg) {
            UIAlertView *ale = [[UIAlertView alloc] initWithTitle:errMsg message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [ale showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        }
        else {
            UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"鉴权成功" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            @weakify(self);
            [ale showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                @strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}


#pragma mark- PublibMethod


#pragma mark- PrivateMethod
-(void)refresh {
    
}

- (void)showErrorMsgAle{
    UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"" message:@"信息有误，申请鉴权失败，请重新输入相关信息" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    ale.tag = 1010;
    [ale show];
}

- (BOOL)checkTheInput{
    if (_mainView.name.length < 1) {
        [self showErrorMsgAle];
        [_mainView.nameView.inputTextField becomeFirstResponder];
        return YES;
    }
    if (_mainView.idcard.length < 1) {
        [self showErrorMsgAle];
        [_mainView.idView.inputTextField becomeFirstResponder];
        return YES;
    }
    if (_mainView.bankNo.length < 1) {
        [self showErrorMsgAle];
        [_mainView.bankNoView.inputTextField becomeFirstResponder];
        return YES;
    }
    if (_mainView.phone.length < 1) {
        [self showErrorMsgAle];
        [_mainView.phoneView.inputTextField becomeFirstResponder];
        return YES;
    }
    if (_mainView.bankid.length < 1) {
        [self showErrorMsgAle];
        return YES;
    }
    return NO;
}

- (void)selectBankWith:(NSUInteger)index{
    if (self.model) {
        self.model = nil;
    }
    self.model = [[BankMessageModel alloc] init];
    self.model = [GET_CLIENT_MANAGER.userCenterManager.bankList objectAtIndex:index];
    _mainView.bankView.inputTextField.text = _model.value;
    _mainView.bankid = _model.code;
    _mainView.bankView.inputTextField.frame = CGRectMake(_mainView.bankView.inputTextField.left, (49.0 - 21.0f)/2.0f, _mainView.bankView.inputTextField.width, _mainView.bankView.inputTextField.height);
}


@end
