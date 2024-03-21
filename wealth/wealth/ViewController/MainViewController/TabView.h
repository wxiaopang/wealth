//
//  TabView.h
//  wealth
//
//  Created by wangyingjie on 15/2/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//
//  tabBar视图
//

#import <UIKit/UIKit.h>

#define TAG 10000      //tabBar上button的tag基础值
#define TabBarCount 3  //tabBar上button的个数

typedef void (^TabViewClick)(void);

@interface TabView : UIView

@property (nonatomic, strong) UIButton   *lastButton;           //记录最后点击的按钮
@property (nonatomic, assign) NSInteger  lastIndex;             //记录上次点击的按钮的tag值
@property (nonatomic, assign) NSInteger  selectedIndex;         //记录当前点击的按钮的tag值
@property (nonatomic, copy) TabViewClick tabViewClick;          //点击回调block

- (void)tabBarButtonAction:(UIButton *)button;

- (void)setMessageCount:(NSInteger)messageCount;

- (NSInteger)messageCount;

@end
