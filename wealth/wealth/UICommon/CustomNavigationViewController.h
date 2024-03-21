//
//  CustomNavigationViewController.h
//  DailyBuildDemo
//
//  Created by wangyingjie on 15/1/1.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavigationViewController : UINavigationController <UIGestureRecognizerDelegate>

- (void)replaceViewController:(NSString *)replacedName withViewController:(UIViewController *)newViewController;

- (void)replaceViewController:(UIViewController *)newViewController index:(NSInteger)index;

- (void)replaceLastViewController:(UIViewController *)newViewController;

//刷新ViewControllers数组并跳转至新页面
- (void)replaceViewControllers:(NSArray *)theNewViewControllers toNewViewController:(UIViewController *)newViewController;

@end
