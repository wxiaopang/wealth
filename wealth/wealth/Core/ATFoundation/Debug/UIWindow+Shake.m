//
//  UIWindow+Shake.m
//  wealth
//
//  Created by wangyingjie on 15/11/3.
//  Copyright © 2015年 普惠金融. All rights reserved.
//

#import "UIWindow+Shake.h"

static BOOL __g_UIWindowShake__ = NO;

@implementation UIWindow (Shake)

- (void)shakeWindow:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake && !__g_UIWindowShake__) {
        __g_UIWindowShake__ = YES;
        //弹窗视图 修改服务器的IP地址
        NSString * currentIP = [NSString stringWithFormat:@"当前IP为:\n%@", GET_HTTP_BASEURL];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:currentIP
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"确定", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alertView textFieldAtIndex:0];
        textField.delegate = self;
        textField.placeholder = @"如:172.16.7.57:8999";
        [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                NSString *text = [alertView textFieldAtIndex:0].text;
                NSString *url = text;
//                if ( ![text customContainsString:@"https"] ) {
//                    url = [[NSString alloc] initWithFormat:@"http://%@", text];
//                }
                if (url.length > 0) {
                    GET_HTTP_BASEURL = [NSString stringWithFormat:@"http://%@/puhui-wealth-app",url];
                    NSLog(@"%@",GET_HTTP_BASEURL);
                    GET_CLIENT_MANAGER.loginManager.status = LoginStatus_conflit;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusConflit
                                                                        object:nil
                                                                      userInfo:@{ @"message":@"登录已失效，请重新登录" }];
                }
            }
            __g_UIWindowShake__ = NO;
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789.:"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


@end
