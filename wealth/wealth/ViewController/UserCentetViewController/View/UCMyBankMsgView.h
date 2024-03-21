//
//  UCMyBankMsgView.h
//  wealth
//
//  Created by wangyingjie on 16/4/19.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCBankMsgInputView.h"

@interface UCMyBankMsgView : UIScrollView

@property (nonatomic, strong) UCBankMsgInputView *nameView;
@property (nonatomic, strong) UCBankMsgInputView *idView;
@property (nonatomic, strong) UCBankMsgInputView *bankView;
@property (nonatomic, strong) UCBankMsgInputView *bankNoView;
@property (nonatomic, strong) UCBankMsgInputView *phoneView;

@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, copy) VoidBlock bankSelectBlock;
@property (nonatomic, copy) VoidBlock nextBlock;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *idcard;
@property (nonatomic, strong) NSString *bankid;
@property (nonatomic, strong) NSString *bankNo;
@property (nonatomic, strong) NSString *phone;

@end
