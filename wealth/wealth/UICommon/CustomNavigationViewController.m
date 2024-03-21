//
//  CustomNavigationViewController.m
//  DailyBuildDemo
//
//  Created by wangyingjie on 15/1/1.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import "CustomNavigationViewController.h"

@interface CustomNavigationViewController () {
    CALayer *animationLayer;
}

@end

@implementation CustomNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationBar.hidden = YES;
    }
    return self;
}


//-(void)loadLayerWithImage {
////    UIGraphicsBeginImageContext(self.visibleViewController.view.bounds.size);
////    [self.visibleViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
////    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
//    [animationLayer setContents: (id)[self capture].CGImage];
//    [animationLayer setHidden:NO];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    animationLayer = [CALayer layer] ;
//    CGRect layerFrame = self.view.frame;
//    if (!self.navigationBarHidden){
//        layerFrame.size.height = self.view.frame.size.height-self.navigationBar.frame.size.height;
//        layerFrame.origin.y = self.navigationBar.frame.size.height+20;
//    }
//    animationLayer.frame = layerFrame;
//    animationLayer.masksToBounds = YES;
//    [animationLayer setContentsGravity:kCAGravityBottomLeft];
//    [self.view.layer insertSublayer:animationLayer atIndex:0];
//    animationLayer.delegate = self;
//}
//
//- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
//    if(layer == animationLayer) {
//        id<CAAction> action = (id)[NSNull null];
//        return action;
//    } else {
//        return [layer.actions objectForKey:event];
//    }
//}
//
//-(void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//    CGRect layerFrame = self.view.bounds;
//    if (!self.navigationBarHidden){
//        layerFrame.size.height = self.view.bounds.size.height-self.navigationBar.frame.size.height;
//        layerFrame.origin.y = self.navigationBar.frame.size.height+20;
//    }
//    animationLayer.frame = layerFrame;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// override the push method
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    [super pushViewController:viewController animated:animated];
//}
//
//// override the pop method
//- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
//    return [super popViewControllerAnimated:NO];
//}
//
//- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    return [super popToViewController:viewController animated:NO];
//}
//
//- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
//    return [super popToRootViewControllerAnimated:NO];
//}

// get the current view screen shot
- (UIImage *)capture {
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (void)replaceViewController:(NSString *)replacedName withViewController:(UIViewController *)newViewController {
    __block UIViewController *replacedViewController = nil;
    __block NSUInteger index = -1;
    NSMutableArray *currentViewControllers = [self.viewControllers mutableCopy];
    [currentViewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        NSString *name = NSStringFromClass([obj class]);
        if ( [replacedName isEqualToString:name] ) {
            replacedViewController = obj;
            index = idx;
            *stop = YES;
        }
    }];
    
    if ( replacedViewController ) {
        [currentViewControllers removeObjectAtIndex:index];
        [currentViewControllers insertObject:newViewController atIndex:index];
        [self setViewControllers:currentViewControllers animated:YES];
    } else {
        [self pushViewController:newViewController animated:YES];
    }
}

- (void)replaceViewController:(UIViewController *)newViewController index:(NSInteger)index {
    NSUInteger count = self.viewControllers.count;
    if ( index >= 0 && index < count ) {
        NSMutableArray *currentViewControllers = [self.viewControllers mutableCopy];
        [currentViewControllers removeObjectAtIndex:index];
        [currentViewControllers insertObject:newViewController atIndex:index];
        [self setViewControllers:currentViewControllers animated:YES];
    }
}

- (void)replaceLastViewController:(UIViewController *)newViewController {
    NSMutableArray *currentViewControllers = [self.viewControllers mutableCopy];
    [currentViewControllers removeLastObject];
    [self setViewControllers:currentViewControllers animated:NO];
    [self pushViewController:newViewController animated:YES];
}

- (void)replaceViewControllers:(NSArray *)theNewViewControllers toNewViewController:(UIViewController *)newViewController {
    [self pushViewController:newViewController animated:YES];
    [self setViewControllers:theNewViewControllers animated:NO];
}

@end
