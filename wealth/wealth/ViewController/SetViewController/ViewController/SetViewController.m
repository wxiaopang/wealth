//
//  SetViewController.m
//  wealth
//
//  Created by wangyingjie on 16/3/14.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "SetViewController.h"

#import "RegistViewController.h"

#import "SetCallTableViewCell.h"

#import "SetChangePwdViewController.h"
#import "SetAboutViewController.h"
#import "SetCheckPWDViewController.h"






@interface SetViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong) UIImageView *footView;



@end

@implementation SetViewController

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
    self.navigationBarView.title = @"设置";
//    NSLog(@"%@",[EncryptEngine encryptRSA:@"123456" publicKey:kPublicKey]);
//    NSLog(@"%@",[EncryptEngine encryptRSA:@"wangyingjie123" publicKey:kPublicKey]);
//    NSLog(@"%@",[EncryptEngine encryptRSA:@"王yingjie123" publicKey:kPublicKey]);
//    NSLog(@"%@",[EncryptEngine encryptRSA:@"王yingjie123@#……*&%%@%！" publicKey:kPublicKey]);
//    NSLog(@"%@",[EncryptEngine encryptRSA:@"爱钱进V3.3.0       爱钱进app在经过一年多的风风雨雨，有大家喜欢的，也有您不喜欢的地方，我们也走过弯路，见过喜悦，在支付的过程中，我们想尽一切方法简化流程，希望能让您的使用更加便捷、账户更安全，每走一步我们都会竭尽付出，爱钱进app团队坚信，在我们经验的积累中，它会更好，谢谢大家的支持。" publicKey:kPublicKey]);
    
    self.mainTableView = [[UITableView alloc] init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor whiteColor];
    self.mainTableView.frame = CGRectMake(0,kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight);
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.footView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, 0)];
    [self.footView setBackgroundColor:[UIColor get_6_Color]];
    [self.mainTableView setTableFooterView:self.footView];
    self.mainTableView.tableFooterView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight*2);
    [self.view addSubview:self.mainTableView];
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mainTableView reloadData];
    
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
    
}

#pragma mark- NetWorking
- (void)netGetData {
    
}

#pragma mark- PublibMethod


#pragma mark- PrivateMethod
-(void)refresh {
    
}


- (void)login{
    [self jumpToLoginViewWitheAnimated:YES];
}

- (void)gotoChangePwd{
    if (kClientManagerUid > 0) {
        SetChangePwdViewController *vc = [[SetChangePwdViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self login];
    }
}

- (void)gotoChangeGest{
    if (kClientManagerUid > 0) {
        SetCheckPWDViewController *vc = [[SetCheckPWDViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self login];
    }
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kClientManagerUid > 0 ? SetMainCellType_logout+1 : SetMainCellType_logout;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case SetMainCellType_call:{
            return 99.0f;
        }break;
        case SetMainCellType_section1:{
           return 10.0f;
        }break;
        case SetMainCellType_pwd:{
            return 49.0f;
        }break;
        case SetMainCellType_gest:{
            return 49.0f;
        }break;
        case SetMainCellType_wetchat:{
            return 49.0f;
        }break;
        case SetMainCellType_about:{
            return 49.0f;
        }break;
        case SetMainCellType_section2:{
            return 10.0f;
        }break;
        case SetMainCellType_logout:{
            return 49.0f;
        }break;
        default:
            break;
    }
    return 44.0f;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [NSArray array];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    SetBaseTableViewCell *cell = (SetBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        switch (indexPath.row) {
            case SetMainCellType_call:{
                cell = [[SetCallTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }break;
            case SetMainCellType_section1:{
                cell = [[SetBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }break;
            case SetMainCellType_pwd:{
                cell = [[SetBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }break;
            case SetMainCellType_gest:{
                cell = [[SetBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }break;
            case SetMainCellType_wetchat:{
                cell = [[SetBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }break;
            case SetMainCellType_about:{
                cell = [[SetBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }break;
            case SetMainCellType_section2:{
                cell = [[SetBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }break;
            case SetMainCellType_logout:{
                cell = [[SetBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }break;
            default:
                break;
        }
    }
    
    cell.cellType = indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case SetMainCellType_call:{
            [Utility telephoneCall:kPhoneNumber];
        }break;
        case SetMainCellType_section1:{
            
        }break;
        case SetMainCellType_pwd:{
            [self gotoChangePwd];
        }break;
        case SetMainCellType_gest:{
            [self gotoChangeGest];
        }break;
        case SetMainCellType_wetchat:{
            UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"已复制公众号，打开微信-搜索”放大镜“-粘贴-搜一搜puhui-caifu公众号-关注" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [ale show];
        }break;
        case SetMainCellType_about:{
            SetAboutViewController *vc = [[SetAboutViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }break;
        case SetMainCellType_section2:{
            
        }break;
        case SetMainCellType_logout:{
            UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"确定退出登录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [ale show];
            
        }break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [GET_CLIENT_MANAGER.loginManager userLogout];
        [_mainTableView reloadData];
        [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:@"退出登录成功" complete:^{ }];
    }
}




@end