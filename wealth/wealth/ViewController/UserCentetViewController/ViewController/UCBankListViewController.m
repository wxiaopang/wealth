//
//  UCBankListViewController.m
//  wealth
//
//  Created by wangyingjie on 16/4/19.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UCBankListViewController.h"
#import "UCAddBankmsgViewController.h"

#import "UCAddBankView.h"
#import "UCMyBankListView.h"



@interface UCBankListViewController ()

@property (nonatomic, strong) UCAddBankView *addBankView;
@property (nonatomic, strong) UCMyBankListView *listView;


@end

@implementation UCBankListViewController

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
    [self leftBarButtomItemWithNormalName:@"back_white" highName:@"back_white" selector:@selector(back) target:self];
    [self rightBarButtomItemWithNormalName:@"mine_authorize_add" highName:@"mine_authorize_add" selector:@selector(addBankmsg) target:self];
    self.navigationBarView.title = @"我的鉴权";
    
    [self setUpViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getMyBankMessageList];
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
    self.addBankView = [[UCAddBankView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight-kNavigationBarHeight)];
    _addBankView.hidden = YES;
    [self.view addSubview:_addBankView];
    
    self.listView = [[UCMyBankListView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight)];
    _listView.hidden = YES;
    [self.view addSubview:_listView];
    
    @weakify(self)
    _addBankView.addBankClickBlock = ^{
        @strongify(self)
        [self addBankmsg];
    };
}

#pragma mark- NetWorking
- (void)netGetData {
    
}

- (void)getMyBankMessageList{
    @weakify(self)
    [GET_CLIENT_MANAGER.userCenterManager getMyBankMessageListComplete:^(NSString *errMsg) {
        @strongify(self)
        if (errMsg) {
            [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:errMsg complete:^{ }];
            [self showNoNetWorkView:CGRectMake(0, kNavigationBarHeight, ScreenWidth, self.addBankView.height)];
            _addBankView.hidden = YES;
            _listView.hidden = YES;
        }
        else {
            if (GET_CLIENT_MANAGER.userCenterManager.bankMessageList.count > 0) {
                _addBankView.hidden = YES;
                _listView.hidden = NO;
                [self.listView.mainTableView reloadData];
            }else{
                _addBankView.hidden = NO;
                _listView.hidden = YES;
            }
        }
    }];
}

#pragma mark- PublibMethod


#pragma mark- PrivateMethod
-(void)refresh {
    
}

- (void)addBankmsg{
    UCAddBankmsgViewController *UCbankMsgVC = [[UCAddBankmsgViewController alloc] init];
    [self.navigationController pushViewController:UCbankMsgVC animated:YES];
}


@end
