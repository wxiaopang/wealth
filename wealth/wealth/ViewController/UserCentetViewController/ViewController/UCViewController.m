//
//  UCViewController.m
//  wealth
//
//  Created by wangyingjie on 16/3/14.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UCViewController.h"
#import "UserCenterMainView.h"
#import "UCBankListViewController.h"
#import "MessageListViewController.h"



@interface UCViewController ()


@property (nonatomic, strong) UserCenterMainView *mainView;

@end

@implementation UCViewController

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
    
    self.navigationBarView.backgroundColor = [UIColor clearColor];
    self.navigationBarView.bottomLine.backgroundColor = [UIColor clearColor];
//    self.navigationBarView.title = @"UserCenter";
    
    [self setUpViews];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    @weakify(self);
    [GET_CLIENT_MANAGER.userCenterManager getUserCenterMainMessageComplete:^(NSString *errMsg) {
        @strongify(self);
        NSLog(@"%@",GET_CLIENT_MANAGER.userCenterManager.ucMainModel.uri);
        long long msgCount = [[UserDefaultsWrapper userDefaultsObject:@"massageTotalCount"] longLongValue];
        if (msgCount < GET_CLIENT_MANAGER.userCenterManager.ucMainModel.massageTotalCount) {
            self.mainView.pointView.hidden = NO;
        }else{
            self.mainView.pointView.hidden = YES;
        }
    }];
    
    [_mainView refurbishTheData];
    
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
    self.mainView = [[UserCenterMainView alloc] initViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) backgroundColor:[UIColor clearColor]];
    [self.view addSubview:_mainView];
    @weakify(self);
    _mainView.moneyView.rechargeBlock = ^{
//        @strongify(self);
        NSLog(@"rechargeBlock");
    };
    
    _mainView.moneyView.withdrawBlock = ^{
//        @strongify(self);
        NSLog(@"withdrawBlock");
    };
    
    _mainView.MessageBlock = ^{
        @strongify(self);
        MessageListViewController *messageListVC = [[MessageListViewController alloc] init];
        [self.navigationController pushViewController:messageListVC animated:YES];
    };
    
    _mainView.bankListBlock = ^{
        @strongify(self);
        NSLog(@"bankListBlock");
        UCBankListViewController *UCbankMsgVC = [[UCBankListViewController alloc] init];
        [self.navigationController pushViewController:UCbankMsgVC animated:YES];
    };
    
    _mainView.myListBlock = ^{
        if (GET_CLIENT_MANAGER.userCenterManager.ucMainModel.uri.length < 1) {
            return ;
        }
        @strongify(self);
        NSLog(@"myListBlock");
        WebMsgModel *webModel = [[WebMsgModel alloc] init];
        webModel.webTitle = @"";
        webModel.webUrl = GET_CLIENT_MANAGER.userCenterManager.ucMainModel.uri;
        webModel.webLoadingType = WebViewType_Url;
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.webMessageModel = webModel;
        [self.navigationController pushViewController:webVC animated:YES];
    };
}

#pragma mark- NetWorking
- (void)netGetData {
    
}

#pragma mark- PublibMethod


#pragma mark- PrivateMethod
-(void)refresh {
    
}

@end