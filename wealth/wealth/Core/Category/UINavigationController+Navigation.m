//
//  UINavigationController+Navigation.m
//  wealth
//
//  Created by wangyingjie on 15/2/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UINavigationController+Navigation.h"
#import <objc/runtime.h>

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end

@implementation UINavigationController (Navigation)

- (NSArray *)popToViewControllerClass:(Class)aClass animated:(BOOL)animated{
    UIViewController *controller;
    for (UIViewController *_controller in self.viewControllers) {
        if([_controller isKindOfClass:aClass]){
            controller =_controller;
        }
    }
    if(controller) {
        return [self popToViewController:controller animated:animated];
    } else {
        [self pushViewController:[[aClass alloc] init] animated:NO];
    }
    return nil;
}

-(UIViewController *)currentViewController{
    UIViewController *controller = [self.viewControllers lastObject];
    return controller;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return [[self currentViewController] shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotate {
    return [[self currentViewController] shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [[self currentViewController] supportedInterfaceOrientations];
}

@end
