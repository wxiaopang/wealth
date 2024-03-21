//
//  UCAddBankViewController.m
//  wealth
//
//  Created by wangyingjie on 16/4/19.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UCAddBankViewController.h"
#import "UCBankView.h"



@interface UCAddBankViewController ()

@property (nonatomic, strong) UCBankView *mainView;


@end

@implementation UCAddBankViewController

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
    self.navigationBarView.title = @"选择银行";
    
    [self setUpViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getBankList];
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
    
    self.mainView = [[UCBankView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight-kNavigationBarHeight)];
    _mainView.hidden = YES;
    [self.view addSubview:_mainView];
    @weakify(self)
    _mainView.selectBankBlock = ^(NSUInteger index){
        @strongify(self)
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectBankWith:)] ) {
            [self.delegate selectBankWith:index];
        }
        [self back];
    };
    
}

#pragma mark- NetWorking
- (void)netGetData {
    
}

- (void)getBankList{
    @weakify(self)
    [GET_CLIENT_MANAGER.userCenterManager getBankListComplete:^(NSString *errMsg) {
        @strongify(self)
        if (errMsg) {
            [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:errMsg complete:^{ }];
            [self showNoNetWorkView:CGRectMake(0, kNavigationBarHeight, ScreenWidth, self.mainView.height)];
            _mainView.hidden = YES;
        }
        else {
            if (GET_CLIENT_MANAGER.userCenterManager.bankList.count > 0) {
                _mainView.hidden = NO;
                [self.mainView.mainTableView reloadData];
            }else{
                [self showBlankView:CGRectMake(0, kNavigationBarHeight, ScreenWidth, self.mainView.height)];
                _mainView.hidden = YES;
            }
        }
    }];
}

#pragma mark- PublibMethod


#pragma mark- PrivateMethod
-(void)refresh {
    
}


@end
