//
//  MessageDetailViewController.m
//  wealth
//
//  Created by wangyingjie on 16/5/9.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()



@end

@implementation MessageDetailViewController



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
    self.navigationBarView.title = @"消息详情";
    
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
