//
//  GesturePasswordController.h
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "TentacleView.h"
#import "GesturePasswordView.h"

typedef void(^completeCallBack)(BOOL isSuccessed);

@interface GesturePasswordController : UIViewController <VerificationDelegate,ResetDelegate,GesturePasswordDelegate>

+ (GesturePasswordController *)presentGesturePasswordController:(UIViewController *)parentViewController
                                                       complete:(dispatch_block_t)completion;
+ (GesturePasswordController *)presentGesturePasswordController:(UIViewController *)parentViewController
                                                     fromTheSet:(BOOL)isset
                                                       complete:(dispatch_block_t)completion;

+ (BOOL)hasGesturePasswordControllerShowned;

@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, assign) BOOL isChange;


@property (nonatomic, strong) UIImage *blurBackgroudImage;

@property (nonatomic, copy) dispatch_block_t completion;

- (void)clear;

@end
