//
//  MainViewController.h
//  wealth
//
//  Created by wangyingjie on 16/3/14.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UIBaseViewController.h"
#import "TabView.h"
#import "ProdudtionViewController.h"
#import "UCViewController.h"
#import "SetViewController.h"
#import "HomeViewController.h"

@interface MainViewController : UIBaseViewController


@property (nonatomic, assign) BOOL      enableSwipeGestureRecognizers;
@property (nonatomic, assign) BOOL      allowSwipeCycling;
@property (nonatomic, strong) TabView   *tabView;              //自定义tabBar视图
@property (nonatomic, strong) UIButton  *lastButton;           //记录最后点击的按钮
@property (nonatomic, assign) NSInteger selectedIndex;         //标记当前显示控制器视图在数组中的索引
@property (nonatomic, assign) BOOL      isInitializeOK;

- (void)replaceViewController:(UIBaseViewController *)controller index:(NSInteger)index;

+ (MainViewController *)mainViewController;

+ (void)setMessageCount:(NSInteger)messageCount;

+ (NSInteger)messageCount;

+ (void)setSeletcedView:(NSInteger)index;

//+ (void)setSeletcedSegment:(NSInteger)index;


@end
