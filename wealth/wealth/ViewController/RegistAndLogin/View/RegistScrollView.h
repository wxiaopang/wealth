//
//  RegistScrollView.h
//  wealth
//
//  Created by wangyingjie on 16/3/21.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistTextFeildView.h"




@interface RegistScrollView : UIScrollView


@property (nonatomic, strong) RegistTextFeildView *phoneTextFeild;
@property (nonatomic, strong) RegistTextFeildView *codeTextFeild;
@property (nonatomic, strong) RegistTextFeildView *pwdEyeTextFeild;
@property (nonatomic, strong) RegistTextFeildView *pwdTextFeild;
@property (nonatomic, strong) UILabel *messageLabel;        /**<*/
@property (nonatomic, strong) UIButton *topButton;        /**<*/
@property (nonatomic, strong) UIButton *botButton;        /**<*/

@property (nonatomic, copy) VoidBlock messageBlock;
@property (nonatomic, copy) VoidBlock topButtonBlock;
@property (nonatomic, copy) VoidBlock botButtonBlock;


@property (nonatomic, strong) NSString *phoneString;
@property (nonatomic, strong) NSString *codeString;
@property (nonatomic, strong) NSString *pwd1String;
@property (nonatomic, strong) NSString *pwd2String;


@end
