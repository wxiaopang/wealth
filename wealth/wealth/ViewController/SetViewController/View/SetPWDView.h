//
//  SetPWDView.h
//  wealth
//
//  Created by wangyingjie on 16/3/23.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistTextFeildView.h"


@interface SetPWDView : UIView

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) RegistTextFeildView *pwdTextField;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, copy) NSString *pwdString;

@property (nonatomic, copy) VoidBlock nextBlock;

- (void)setMessage:(NSString *)message;


@end
