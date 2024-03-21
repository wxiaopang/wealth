//
//  GesturePasswordController.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>
#import "LoginViewController.h"

#import "CYRippleTransitionAnimator.h"
#import "GesturePasswordController.h"
//#import "LogonViewController.h"

#define kMaxErrorCount  5

static BOOL __g_hasGesturePasswordControllerShowned__ = NO;

@interface GesturePasswordController ()<UIAlertViewDelegate>

@property (nonatomic, weak) UIViewController *presentViewController;
@property (nonatomic, strong) GesturePasswordView * gesturePasswordView;
@property (nonatomic, strong) CYRippleTransitionAnimator *ripple;

@end

@implementation GesturePasswordController {
    NSString * previousString;
    NSString * password;
    NSInteger errorCount;
}

@synthesize gesturePasswordView;

+ (BOOL)hasGesturePasswordControllerShowned {
    return __g_hasGesturePasswordControllerShowned__;
}

+ (GesturePasswordController *)presentGesturePasswordController:(UIViewController *)parentViewController
                                                     fromTheSet:(BOOL)isset
                                                       complete:(dispatch_block_t)completion
{
    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
    [parentViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *blurBackgroudImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    GesturePasswordController *c;
    if ([parentViewController isKindOfClass:[self class]]) {
        c.presentViewController = parentViewController;
        c.blurBackgroudImage = blurBackgroudImage;
        return c;
    }
    
    c = [[GesturePasswordController alloc] init];
    c.presentViewController = parentViewController;
    c.blurBackgroudImage = blurBackgroudImage;
    //    c.ripple = [[CYRippleTransitionAnimator alloc] initWithTouchRect:CGRectMake(ScreenWidth/2 - SINGLE_LINE_WIDTH,
    //                                                                                ScreenHeight/2 - SINGLE_LINE_WIDTH,
    //                                                                                SINGLE_LINE_ADJUST_OFFSET,
    //                                                                                SINGLE_LINE_ADJUST_OFFSET)];
    UIAlertView *alertView = [UIAlertView isExistAlertView];
    if ( alertView ) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [c.presentViewController presentViewController:c animated:YES completion:completion];
        });
    } else {
        [c.presentViewController presentViewController:c animated:YES completion:completion];
    }
    c.isChange = isset;
    return c;
}


+ (GesturePasswordController *)presentGesturePasswordController:(UIViewController *)parentViewController
                                                       complete:(dispatch_block_t)completion
{
    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
    [parentViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *blurBackgroudImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    GesturePasswordController *c;
    if ([parentViewController isKindOfClass:[self class]]) {
        c.presentViewController = parentViewController;
        c.blurBackgroudImage = blurBackgroudImage;
        return c;
    }

    c = [[GesturePasswordController alloc] init];
    c.presentViewController = parentViewController;
    c.blurBackgroudImage = blurBackgroudImage;
//    c.ripple = [[CYRippleTransitionAnimator alloc] initWithTouchRect:CGRectMake(ScreenWidth/2 - SINGLE_LINE_WIDTH,
//                                                                                ScreenHeight/2 - SINGLE_LINE_WIDTH,
//                                                                                SINGLE_LINE_ADJUST_OFFSET,
//                                                                                SINGLE_LINE_ADJUST_OFFSET)];
    UIAlertView *alertView = [UIAlertView isExistAlertView];
    if ( alertView ) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [c.presentViewController presentViewController:c animated:YES completion:completion];
        });
    } else {
        [c.presentViewController presentViewController:c animated:YES completion:completion];
    }
    return c;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isChange = NO;
        password = GET_CLIENT_MANAGER.loginManager.accountInformation.gesturePassword;
        __g_hasGesturePasswordControllerShowned__ = YES;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    __g_hasGesturePasswordControllerShowned__ = NO;
    NSLog(@"GesturePasswordController dealloc");
}

- (void)setRipple:(CYRippleTransitionAnimator *)ripple {
    _ripple = ripple;
    self.transitioningDelegate = ripple;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor blackColor];
//    [GET_UM_ANALYTICS beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

//    [GET_UM_ANALYTICS endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.tag = ViewControllerType_52;

    if ( password == nil || [password isEqualToString:@""]) {
        [self reset];
    }else if (self.isChange){
        [self reset];
    }else {
        [self verify];
        
        if ( GET_CLIENT_MANAGER.loginManager.accountInformation.enableTouchID ) {
            @weakify(self);
            [TouchIDEngine AuthenticationWithTouchId:^(BOOL success, NSError *err) {
                @strongify(self);
                if ( success ) {
                    if ( self.presentViewController ) {
                        [self.presentViewController dismissViewControllerAnimated:YES completion:self.completion];
                    } else {
                        @weakify(self);
                        [self dismissViewControllerAnimated:YES completion:^{
                            @strongify(self);
                            if ( self.completion ) {
                                self.completion();
                            }
                            [self removeFromParentViewController];
                        }];
                    }
                } else {
                    TouchIDErrorCode code = err.code;
                    switch ( code ) {
                        case TouchIDErrorCode_Notsuport:
                            
                            break;
                            
                        case TouchIDErrorCode_Notset:
                            
                            break;
                            
                        case TouchIDErrorCode_ChangeDigtal:
                            
                            break;
                            
                        case TouchIDErrorCode_Cancel:
                            
                            break;
                            
                        case TouchIDErrorCode_Failed:
                            
                            break;
                            
                        default:
                            break;
                    }
                }
            }];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 验证手势密码
- (void)verify {
    gesturePasswordView = [[GesturePasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    gesturePasswordView.blurImage = [UIImage imageNamed:@"bg_locker"];
    gesturePasswordView.backgroundColor = [UIColor clearColor];
    [gesturePasswordView.tentacleView setRerificationDelegate:self];
    [gesturePasswordView.tentacleView setStyle:1];
    [gesturePasswordView setGesturePasswordDelegate:self];
    [gesturePasswordView.state setTextColor:[UIColor whiteColor]];
    [gesturePasswordView.state setText:@"请输入手势密码"];
    gesturePasswordView.forgetButton.frame = CGRectMake((ScreenWidth-240.0f)/3.0f, gesturePasswordView.forgetButton.frame.origin.y, gesturePasswordView.forgetButton.frame.size.width, gesturePasswordView.forgetButton.frame.size.height);
    gesturePasswordView.useOtherButton.frame = CGRectMake(ScreenWidth - (ScreenWidth - 240.0f)/3.0f-120.0f, gesturePasswordView.useOtherButton.frame.origin.y, gesturePasswordView.useOtherButton.frame.size.width, gesturePasswordView.useOtherButton.frame.size.height);
    gesturePasswordView.useOtherButton.hidden = NO;
    [self.view addSubview:gesturePasswordView];
}

#pragma mark - 重置手势密码
- (void)reset {
    if (gesturePasswordView) {
        [gesturePasswordView removeFromSuperview];
    }
        gesturePasswordView = [[GesturePasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        gesturePasswordView.blurImage = [UIImage imageNamed:@"bg_locker"];
        [gesturePasswordView.tentacleView setResetDelegate:self];
        [gesturePasswordView.tentacleView setStyle:2];
        [gesturePasswordView setGesturePasswordDelegate:nil];
        [gesturePasswordView.forgetButton setHidden:YES];
        [gesturePasswordView.changeButton setHidden:YES];
        [gesturePasswordView.state setTextColor:[UIColor whiteColor]];
        [gesturePasswordView.state setText:@"请输入手势密码(至少4个点)"];
        [self.view addSubview:gesturePasswordView];
}

#pragma mark - 清空记录
- (void)clear {
    errorCount = 0;
    password = @"";
    previousString = @"";
}

#pragma mark - 改变手势密码
- (void)change {
    
}

- (void)useOther{
    kManualRelogonWith(LoginType_Gesture);
}

#pragma mark - 忘记手势密码
- (void)forget {
    if ( [gesturePasswordView.forgetButton.currentTitle isEqualToString:@"重置手势密码"] ) {
        previousString = nil;
        [self reset];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"重新设置手势密码需要重新登录？"
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
//        @weakify(self);
        [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            @strongify(self);
            if ( buttonIndex == 1 ) {
                GET_CLIENT_MANAGER.loginManager.accountInformation.gesturePassword = kNullStr;
                [GET_CLIENT_MANAGER.loginManager.accountInformation save];
                kManualRelogonWith(LoginType_Gesture);
//                if ( self.presentViewController ) {
//                    [self.presentViewController dismissViewControllerAnimated:YES completion:^{
//                        kManualRelogon;
//                    }];
//                } else {
//                    [self dismissViewControllerAnimated:YES completion:^{
//                        @strongify(self);
//                        if ( self.completion ) {
//                            self.completion();
//                        }
//                        [self removeFromParentViewController];
//
//                        kManualRelogon;
//                    }];
//                }
            }
        }];
    }
}

- (BOOL)verification:(NSString *)result {
    if ( [result isEqualToString:password] ) {
        if ( self.presentViewController ) {
            [gesturePasswordView.state setTextColor:[UIColor whiteColor]];
            [gesturePasswordView.state setText:@"输入正确"];
            if ( self.presentViewController ) {
                [self.presentViewController dismissViewControllerAnimated:YES completion:self.completion];
            }
            else {
                @weakify(self);
                [self dismissViewControllerAnimated:YES completion:^{
                    @strongify(self);
                    if ( self.completion ) {
                        self.completion();
                    }
                    [self removeFromParentViewController];
                }];
            }
            return YES;
        } else {
            [self reset];
            return NO;
        }
    }
    errorCount++;
    if ( errorCount >= kMaxErrorCount ) {
        UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"" message:@"很抱歉，您的手势密码连续五次输入错误，请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        ale.tag = 1011;
        [ale show];
    } else {
        [gesturePasswordView.tentacleView enterErrorArgin];
        [gesturePasswordView.state setTextColor:CREATECOLOR(255, 77, 77, 1.0f)];
        [gesturePasswordView.state setText:[NSString stringWithFormat:@"密码错误，还可以再输入%@次", @(kMaxErrorCount - errorCount)]];
    }
    return NO;
}

- (BOOL)resetPassword:(NSString *)result {
    if ( result.length < 4 ) {
        [gesturePasswordView.tentacleView enterArgin];
        [gesturePasswordView.state setTextColor:CREATECOLOR(255, 77, 77, 1.0f)];
        [gesturePasswordView.state setText:@"请输入手势密码(至少4个点)"];
        return NO;
    }
    
    if ( previousString == nil ) {
        previousString = result;
        [gesturePasswordView.tentacleView enterArgin];
        [gesturePasswordView.state setTextColor:[UIColor whiteColor]];
        [gesturePasswordView.state setText:@"请再次输入手势密码"];
        gesturePasswordView.gesturePasswordDelegate = self;
        [gesturePasswordView.forgetButton setTitle:@"重置手势密码" forState:UIControlStateNormal];
        [gesturePasswordView.forgetButton setHidden:NO];
        return YES;
    }
    
    if ( [previousString isEqualToString:result] ) {
        GET_CLIENT_MANAGER.loginManager.accountInformation.gesturePassword = result;
        [GET_CLIENT_MANAGER.loginManager.accountInformation save];
       
        [gesturePasswordView.state setTextColor:[UIColor whiteColor]];
        [gesturePasswordView.state setText:@"已保存手势密码"];
        if ( self.presentViewController ) {
            [self.presentViewController dismissViewControllerAnimated:YES completion:self.completion];
        }else if (self.isChange){
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            @weakify(self);
            [self dismissViewControllerAnimated:YES completion:^{
                @strongify(self);
                if ( self.completion ) {
                    self.completion();
                }
                [self removeFromParentViewController];
            }];
        }
        return YES;
    } else {
        [gesturePasswordView.tentacleView enterErrorArgin];
        [gesturePasswordView.state setTextColor:CREATECOLOR(255, 77, 77, 1.0f)];
        [gesturePasswordView.state setText:@"两次密码不一致，请重新输入"];
        return NO;
    }
    return NO;
}

- (UIImage *)capture {
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions(screenWindow.bounds.size, NO, [[UIScreen mainScreen]scale]);//这句可以让截图更清晰
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

#pragma mark -- UIViewControllerRotation

-(BOOL)shouldAutorotate {
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ) {
        
    } else {

    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if ( UIInterfaceOrientationIsPortrait(fromInterfaceOrientation) ) {
        
    } else {
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1011) {
        GET_CLIENT_MANAGER.loginManager.accountInformation.gesturePassword = @"";
        [GET_CLIENT_MANAGER.loginManager.accountInformation save];
        kManualRelogonWith(LoginType_Gesture);
    }
}


@end
