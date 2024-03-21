//
//  UIBaseViewController.h
//  wealth
//
//  Created by wangyingjie on 15/2/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "CustomNavigationBar.h"
//#import "EjectSelectView.h"
#import "UIBlankView.h"
#import "UINoNetWorkView.h"


@class UIInsetsLabel;

@interface UIBaseViewController : UIViewController<UINoNetWorkViewDelegate>

@property (nonatomic, assign) BOOL initlizedOK;
@property (nonatomic, assign) BOOL isRefresh;//判断数据提交成功后 刷新数据 ApplyTabViewController 界面
@property (nonatomic, assign) BOOL isModalViewController;
@property (nonatomic, assign) BOOL isShowingKeyboard;
@property (nonatomic, assign) BOOL isUserInterfaceEnable;
@property (nonatomic, strong) CustomNavigationBar *navigationBarView;
@property (nonatomic, readonly) UIButton *notificationView;
//@property (nonatomic, assign) ViewControllerType viewControllerType;

//默认没网页
@property (nonatomic, strong) UINoNetWorkView *nonetWorkView;
//默认空白页
@property (nonatomic, strong) UIBlankView *blankView;
//默认网络繁忙页面
//@property (nonatomic, strong) UIServerBusyView *serverBusyView;


//绑定按钮信号使用
@property (nonatomic, assign) BOOL isTextSignal;//文本类型
@property (nonatomic, assign) BOOL isIntegerSignal;//数字类型

- (UITableView *)mainTableView;

- (void)customInitSubviews;

- (void)customLayoutSubviews;

- (void)customRAC;

//添加导航条左边按钮
- (void)leftBarButtomItemWithNormalName:(NSString*)normalName
                               highName:(NSString *)highName
                               selector:(SEL)selector
                                 target:(id)target;

//添加导航条右边按钮
- (void)rightBarButtomItemWithNormalName:(NSString*)normalName
                                highName:(NSString *)highName
                                selector:(SEL)selector
                                  target:(id)target;

// 添加导航栏左边标题
- (void)leftBarButtomItemWithTitle:(NSString*)title
                          selector:(SEL)selector
                            target:(id)target;

// 添加导航栏右边标题
- (void)rightBarButtomItemWithTitle:(NSString*)title
                           selector:(SEL)selector
                             target:(id)target;

- (void)back;

- (void)showNotificationView:(NSString *)title dismissAfter:(NSTimeInterval)duration;
- (void)hideNotificationView;

+ (void)showAlertMsg:(NSString *)msg
          bottomView:(UIView *)bottomView
               space:(CGFloat)space;

+ (void)showLoadingToast:(NSString *)title;
+ (void)showTextToastWithTitle:(NSString *)title dismissAnimationCompletion:(dispatch_block_t)block;
+ (void)disMissLoadingToast;

//+ (EjectSelectView *)showEjectSelectView:(NSArray *)dataArray viewType:(EjectSelectViewType)viewType;

//显示没网页面
-(void)showNoNetWorkView:(CGRect)frame;
//隐藏没网页面
-(void)hideNoNetWorkView;
//显示空白页面
-(void)showBlankView:(CGRect)frame;
//隐藏空白页面
-(void)hideBlankView;
////显示网络繁忙页面
//-(void)showServerBusyView:(CGRect)frame;
////隐藏网络繁忙页面
//-(void)hideServerBusyView;


- (void)logoutTheUser;

- (void)jumpToLoginViewWitheAnimated:(BOOL)animated;


// 每次调用updateProgress之前都需要配置configProgress
+ (void)configProgressSetting:(dispatch_block_t)progressCompletion cancelBlock:(dispatch_block_t)cancelBlock;
+ (void)updateProgress:(CGFloat)progress withStatus:(NSString *)status title:(NSString *)title;

@end


#pragma mark- 下拉刷新UIRefreshHeader类目
@interface UIBaseViewController (refreshHeader)
-(void)endRefreshHeaderFrom:(MJRefreshHeader *)header andCode:(int)code;
@end


