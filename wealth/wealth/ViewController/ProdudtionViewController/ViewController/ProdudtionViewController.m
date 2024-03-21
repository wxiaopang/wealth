//
//  ProdudtionViewController.m
//  wealth
//
//  Created by wangyingjie on 16/3/14.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "ProdudtionViewController.h"
#import "ProductionBuyViewController.h"
#import "HomeHeaderView.h"
#import "ProductionTableViewCell.h"



@interface ProdudtionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) HomeHeaderView *headerView;

@property (nonatomic, assign) HeaderDisType headerType;

@property (nonatomic, assign) BOOL isCall;

@property (nonatomic, assign) BOOL isfrist;



@end

@implementation ProdudtionViewController

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
        
        self.isCall = NO;
        self.isfrist = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBarView.backgroundColor = [UIColor clearColor];
//    self.navigationBarView.bottomLine.backgroundColor = [UIColor clearColor];
    
    
    [self setUpViews];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isfrist) {
        [self performSelector:@selector(getProductionList) withObject:nil afterDelay:1];
        self.isfrist = NO;
    }else{
        [self getProductionList];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark- InitSubViews
- (void)setUpViews {
    
    self.headerView = [[HomeHeaderView alloc] initViewWithFrame:CGRectMake(0, 0, ScreenWidth, kProportion*145.0f) backgroundColor:[UIColor clearColor]];
    [self.view addSubview:_headerView];
    
    self.mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, _headerView.bottom,ScreenWidth,ScreenHeight-kStatusBarHeight - kProportion*145.0f) style:UITableViewStylePlain];
    [self.mainTableView setBackgroundColor:[UIColor clearColor]];
    [self.mainTableView setDataSource:self];
    [self.mainTableView setDelegate:self];
    _mainTableView.mj_header = [UIRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getProductionList)];
    _mainTableView.showsVerticalScrollIndicator = FALSE;
    _mainTableView.showsHorizontalScrollIndicator = FALSE;
    [self.mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.mainTableView];
    
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    footView.frame = CGRectMake(0, 0, ScreenWidth, 40.0f);
    UILabel *messageLabel = nil;
    GreateLabelf(messageLabel, CREATECOLOR(0, 190, 125, 1), [UIFont get_B26_CN_NOR_Font], NSTextAlignmentCenter, footView);
    [messageLabel setAdaptionWidthWithText:@"市场有风险，出借需谨慎"];
    messageLabel.frame = CGRectMake((ScreenWidth - messageLabel.width-30.0f)/2.0f+0.3f, 13.3f, messageLabel.width+30.0f, 15.0f);
    messageLabel.layer.cornerRadius = 15.0f/2.0f;
    messageLabel.layer.masksToBounds = YES;
    messageLabel.borderColor = CREATECOLOR(0, 190, 125, 1);
    messageLabel.borderWidth = 1.0f;
    _mainTableView.tableFooterView = footView;
    
    
    @weakify(self);
    _headerView.loginBlock = ^{
        @strongify(self);
        [self jumpToLoginViewWitheAnimated:YES];
    };
    _headerView.callBlock = ^{
        @strongify(self);
        UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"是否马上联系？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        ale.tag = 9999;
        [ale showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            @strongify(self);
            if (buttonIndex == 1) {
                [self callTheSalle];
            }
        }];
    };
    
}

#pragma mark- NetWorking
- (void)netGetData {
    
}

- (void)getProductionList{
    [self hideBlankView];
    [self hideNoNetWorkView];
    @weakify(self);
    [GET_CLIENT_MANAGER.productionManager getProductionListComplete:^(NSString *errMsg) {
        @strongify(self);
        CGFloat headerHight = kNavigationBarHeight;
        headerHight = kClientManagerUid > 0 ? headerHight: _headerView.bottom;
        headerHight = GET_CLIENT_MANAGER.loginManager.accountInformation.haveSales ? _headerView.bottom : headerHight;
        if (errMsg) {
            [self endRefreshHeaderFrom:_mainTableView.mj_header andCode:2];
            [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:errMsg complete:^{ }];
            [self showNoNetWorkView:CGRectMake(0, headerHight, ScreenWidth, ScreenHeight-(headerHight))];
            _mainTableView.hidden = YES;
        }
        else {
            [self endRefreshHeaderFrom:_mainTableView.mj_header andCode:1];
            if (GET_CLIENT_MANAGER.productionManager.productionList.count > 0) {
                _mainTableView.hidden = NO;
                [self refresh];
            }else{
                [self showBlankView:CGRectMake(0, headerHight, ScreenWidth, ScreenHeight-(headerHight))];
                _mainTableView.hidden = YES;
            }
        }
    }];
}

- (void)callTheSalle{
    if (_isCall) {
        return;
    }
    self.isCall = YES;
    @weakify(self);
    [GET_CLIENT_MANAGER.productionManager callTheManagerComplete:^(NSString *errMsg) {
        @strongify(self);
        self.isCall = NO;
        if (errMsg) {
            [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:errMsg complete:^{ }];
        }
        else {
            UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"" message:@"通知成功，您的理财师将尽快和您联系" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [ale show];
        }
    }];
}

#pragma mark- PublibMethod


#pragma mark- PrivateMethod
-(void)refresh {
    if (kClientManagerUid > 0) {
        if (GET_CLIENT_MANAGER.loginManager.accountInformation.haveSales) {
            self.navigationBarView.backgroundColor = [UIColor clearColor];
            self.navigationBarView.bottomLine.backgroundColor = [UIColor clearColor];
            self.navigationBarView.title = @"";
            _headerView.hidden = NO;
            _headerView.isLogin = YES;
            _mainTableView.frame = CGRectMake(0, _headerView.bottom,ScreenWidth,self.view.height-kStatusBarHeight - kProportion*145.0f);
        }else{
            _headerView.hidden = YES;
            self.navigationBarView.backgroundColor = [UIColor whiteColor];
            self.navigationBarView.bottomLine.backgroundColor = [UIColor get_4_Color];
            self.navigationBarView.title = @"产品";
            self.navigationBarView.titleLabel.textColor = [UIColor get_1_Color];
            _mainTableView.frame = CGRectMake(0, kNavigationBarHeight,ScreenWidth,self.view.height-kNavigationBarHeight);
        }
    }else{
        self.navigationBarView.backgroundColor = [UIColor clearColor];
        self.navigationBarView.bottomLine.backgroundColor = [UIColor clearColor];
        self.navigationBarView.title = @"";
        _headerView.hidden = NO;
        _headerView.isLogin = NO;
        _mainTableView.frame = CGRectMake(0, _headerView.bottom,ScreenWidth,self.view.height-kStatusBarHeight - kProportion*145.0f);
    }
    [_mainTableView reloadData];
}

- (void)reloadButtonClick{
    [self getProductionList];
}

#pragma mark UITableViewDataSource & UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 20.0f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *footView = [[UIView alloc] init];
//    footView.backgroundColor = [UIColor redColor];
//    return footView;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return GET_CLIENT_MANAGER.productionManager.productionList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    ProductionTableViewCell *cell = (ProductionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ProductionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (GET_CLIENT_MANAGER.productionManager.productionList.count > indexPath.row) {
        cell.dataModel = [GET_CLIENT_MANAGER.productionManager.productionList objectAtIndex:indexPath.row];
    }
    
    cell.buyClick = ^{
        [self gotoBuyViewWtihId:indexPath.row];
    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    [self gotoBuyViewWtihId:indexPath.row];
}

- (void)gotoBuyViewWtihId:(long long)productionIndex{
    ProductionListMode *model = [GET_CLIENT_MANAGER.productionManager.productionList objectAtIndex:(unsigned)productionIndex];
//    if (kClientManagerUid > 0) {
    ProductionBuyViewController *vc = [[ProductionBuyViewController alloc] init];
    vc.productionId = model.listId;
    vc.productionName = model.productName;
    [self.navigationController pushViewController:vc animated:YES];
//    }else{
//      [self jumpToLoginViewWitheAnimated:YES];
//    }
}

- (void)logoutTheUser{
    [super logoutTheUser];
    [self refresh];
}


@end