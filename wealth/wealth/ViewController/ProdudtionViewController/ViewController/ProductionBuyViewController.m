//
//  ProductionBuyViewController.m
//  wealth
//
//  Created by wangyingjie on 16/3/29.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "ProductionBuyViewController.h"
#import "ProductionBuyMainView.h"




@interface ProductionBuyViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) ProductionBuyMainView *mainView;
@property (nonatomic, assign) BOOL isButEn;


@property (nonatomic, assign) double userBuyamount;
@property (nonatomic, strong) NSString *saleId;


@end

@implementation ProductionBuyViewController

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
        self.isButEn = YES;
        self.productionName = @"确认出借";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self leftBarButtomItemWithNormalName:@"black_back" highName:@"nav_icon_back_click" selector:@selector(back) target:self];
    [self rightBarButtomItemWithNormalName:@"black_phone" highName:@"black_phone" selector:@selector(callPhone) target:self];
    self.navigationBarView.title = _productionName;
    self.navigationBarView.titleLabel.textColor = [UIColor get_1_Color];
    self.navigationBarView.backgroundColor = [UIColor whiteColor];
    
    [self setUpViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getProductionBuyDetail];
    
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
    if (!self.mainView) {
        self.mainView = [[ProductionBuyMainView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight-kNavigationBarHeight)];
        [self.view addSubview:_mainView];
    }
    _mainView.hidden = YES;
    @weakify(self);
    _mainView.nextButBlock = ^(double buyamount,NSString *saleid){
        @strongify(self);
        if (kClientManagerUid < 1) {
            [self jumpToLoginViewWitheAnimated:YES];
            return;
        }
        
        self.userBuyamount = buyamount;
        self.saleId = saleid;
        [self submitTheProduction];
    };
    
    
    _mainView.treatyBlock = ^{
        @strongify(self);
        [self seeTheTreaty];
    };
    
}

#pragma mark- NetWorking
- (void)netGetData {
    
}

- (void)getProductionBuyDetail{
    @weakify(self);
    [GET_CLIENT_MANAGER.productionManager getProductionBuyDetailWithProductionId:_productionId Complete:^(NSString *errMsg) {
        @strongify(self);
        if (errMsg) {
            [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:errMsg complete:^{ }];
            self.mainView.hidden = YES;
            [self showNoNetWorkView:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight-kNavigationBarHeight)];
        }
        else {
            self.mainView.hidden = NO;
            self.mainView.isOK = YES;
        }
    }];
}

- (void)submitTheBuyProduction{
    if (!_isButEn) {
        return;
    }
    _isButEn = NO;
    @weakify(self);
    [GET_CLIENT_MANAGER.productionManager submitProductionBuyMessageWithProductionId:_productionId AndAmount:_userBuyamount AndEmployeeNo:_saleId Complete:^(NSString *errMsg) {
        @strongify(self);
        _isButEn = YES;
        if (errMsg) {
            [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:errMsg complete:^{ }];
        }
        else {
            [GET_CLIENT_MANAGER.productionManager getSalesMessage];
            UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"" message:@"您的出借申请已成功提交，正在审核中！请等待客户经理与您联系。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
            ale.tag = 1010;
            [ale show];
        }
    }];
}

- (void)submitTheProduction{

    if ((long long)_userBuyamount < GET_CLIENT_MANAGER.productionManager.productionBuyModel.startAmount) {
        [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"不能低于最低出借金额，请重新输入" complete:^{ }];
        _mainView.inputView.inputView.myTextField.text = [NSString stringWithFormat:@"%0.f",GET_CLIENT_MANAGER.productionManager.productionBuyModel.startAmount];
        _mainView.inputMoney = GET_CLIENT_MANAGER.productionManager.productionBuyModel.startAmount;
        return;
    }
    if ((long long)_userBuyamount%10000 != 0) {
        [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"您输入的出借金额应为10000的倍数，请重新输入" complete:^{ }];
        return;
    }
    if ((long long)_userBuyamount > GET_CLIENT_MANAGER.productionManager.productionBuyModel.maxAmount) {
        [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"已超过当前可出借限额" complete:^{ }];
        double max = GET_CLIENT_MANAGER.productionManager.productionBuyModel.maxAmount;
        _mainView.inputView.inputView.myTextField.text = [NSString stringWithFormat:@"%lld",((long long)max- (long long)max%10000)];
        _mainView.inputMoney = ((long long)max- (long long)max%10000);
        return;
    }
    if (!GET_CLIENT_MANAGER.productionManager.productionBuyModel.haveSales && _saleId.length < 1 && _mainView.managerView.isHaveManager) {
        [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"必须输入客户经理员工编号" complete:^{ }];
        return;
    }
    
    UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"立即出借?" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    ale.tag = 1011;
    [ale show];
    
}

#pragma mark- PublibMethod


#pragma mark- PrivateMethod
-(void)refresh {
    
}

- (void)callPhone{
    [Utility telephoneCall:kPhoneNumber];
}

- (void)reloadButtonClick{
    [self getProductionBuyDetail];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1010) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if (alertView.tag == 1011){
        if (buttonIndex == 1) {
            [self submitTheBuyProduction];
        }
    }
    
}

- (void)seeTheTreaty{
    WebMsgModel *webModel = [[WebMsgModel alloc] init];
    webModel.webTitle = @"";
    webModel.webUrl = [NSString stringWithFormat:@"%@/loanAgreement.jsp",HTML5_URL];
    webModel.webLoadingType = WebViewType_Url;
    WebViewController *webVC = [[WebViewController alloc] init];
    [self.navigationController pushViewController:webVC animated:YES];
    webVC.webMessageModel = webModel;
}
- (void)logoutTheUser{
    [super logoutTheUser];
    [self viewWillDisappear:YES];
}


@end
