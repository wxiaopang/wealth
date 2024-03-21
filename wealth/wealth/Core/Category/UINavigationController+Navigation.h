//
//  UINavigationController+Navigation.h
//  wealth
//
//  Created by wangyingjie on 15/2/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINavigationController(Navigation)

- (NSArray *)popToViewControllerClass:(Class)aClass animated:(BOOL)animated;

- (UIViewController *)currentViewController;

@end
