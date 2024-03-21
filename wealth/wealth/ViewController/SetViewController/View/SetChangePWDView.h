//
//  SetChangePWDView.h
//  wealth
//
//  Created by wangyingjie on 16/3/23.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistTextFeildView.h"

@interface SetChangePWDView : UIView

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) RegistTextFeildView *phoneTextField;
@property (nonatomic, strong) RegistTextFeildView *codeTextField;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, copy) NSString *phoneString;
@property (nonatomic, copy) NSString *codeString;

@property (nonatomic, copy) VoidBlock nextBlock;


- (void)setMessage:(NSString *)message AndPhone:(NSString *)phone;

@end
