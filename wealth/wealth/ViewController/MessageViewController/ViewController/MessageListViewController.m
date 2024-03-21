//
//  MessageListViewController.m
//  wealth
//
//  Created by wangyingjie on 16/5/9.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageListView.h"




@interface MessageListViewController ()

@property (nonatomic, strong) MessageListView *mainView;


@property (nonatomic, assign) NSInteger paper;
@property (nonatomic, assign) BOOL isGetMessage;


@end

@implementation MessageListViewController



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
    //    [self rightBarButtomItemWithNormalName:@"white_phone" highName:@"white_phone" selector:@selector(callPhone) target:self];
    self.navigationBarView.title = @"我的消息";
    
    [self setUpViews];
    
    [self performSelector:@selector(getFristMessageList) withObject:nil afterDelay:0.5];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)getFristMessageList{
    [self getMessageListWithPaper:1];
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
    
    self.mainView = [[MessageListView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight-kNavigationBarHeight)];
    [self.view addSubview:_mainView];
    
    @weakify(self);
    _mainView.messageCellClick = ^(NSUInteger index){
        @strongify(self);
        
        WebMsgModel *webModel = [[WebMsgModel alloc] init];
        webModel.webTitle = @"消息详情";
        webModel.messageId = index;
        webModel.webLoadingType = WebViewType_Html_NoTitle;
        WebViewController *webVC = [[WebViewController alloc] init];
        [self.navigationController pushViewController:webVC animated:YES];
        webVC.webMessageModel = webModel;
    };
    
    _mainView.getListClick = ^(NSUInteger index){
        @strongify(self);
        if (index == 1) {
            [self getMessageListWithPaper:1];
        }else{
            [self getMessageListWithPaper:self.paper];
        }
    };
    
}

#pragma mark- NetWorking
- (void)netGetData {
    
}

- (void)getMessageListWithPaper:(NSInteger)paper{

    if (paper== 1) {
        self.paper = 1;
        _mainView.messageLabel.text = @"加载更多";
    }else if (paper > GET_CLIENT_MANAGER.messageManager.totalPage){
        _mainView.messageLabel.text = @"没有更多了";
        return ;
    }else{
        _mainView.messageLabel.text = @"正在加载";
    }
    @weakify(self);
    [GET_CLIENT_MANAGER.messageManager getMessageListWithNumber:10 range:paper Complete:^(NSString *errMsg) {
        @strongify(self);
        _mainView.messageLabel.text = @"加载更多";
        [self hideBlankView];
        [self hideNoNetWorkView];
        [self endRefreshHeaderFrom:_mainView.mainTableView.mj_header andCode:(int)GET_CLIENT_MANAGER.messageManager.code];
        if (errMsg) {
            [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:errMsg complete:^{ }];
            [self showNoNetWorkView:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight-(kNavigationBarHeight))];
            _mainView.hidden = YES;
        }
        else {
            if (GET_CLIENT_MANAGER.messageManager.code == ResponseErrorCode_OK) {
                _mainView.isgetData = YES;
                [UserDefaultsWrapper setUserDefaultsObject:[NSString stringWithFormat:@"%lld",GET_CLIENT_MANAGER.userCenterManager.ucMainModel.massageTotalCount] forKey:@"massageTotalCount"];
                if (self.paper <= GET_CLIENT_MANAGER.messageManager.totalPage) {
                    self.paper++ ;
                }
                if (GET_CLIENT_MANAGER.messageManager.messageList.count > 0) {
                    _mainView.hidden = NO;
                    [self.mainView.mainTableView reloadData];
                }else{
                    [self showBlankView:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight-(kNavigationBarHeight))];
                    _mainView.hidden = YES;
                }
            }
            else{
                [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:errMsg complete:^{ }];
                [self showNoNetWorkView:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight-(kNavigationBarHeight))];
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
