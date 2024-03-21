//
//  HomeViewController.m
//  wealth
//
//  Created by wangyingjie on 16/3/14.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "HomeViewController.h"


@interface HomeViewController ()





@end

@implementation HomeViewController

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
    
    
    [self setUpViews];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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






@end
