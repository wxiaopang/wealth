//
//  HomeHeaderView.h
//  wealth
//
//  Created by wangyingjie on 16/3/22.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeHeaderView : UIView

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIView *headerWriteView;
@property (nonatomic, strong) UILabel *messageLabe;
@property (nonatomic, strong) UIButton *loginBut;
@property (nonatomic, strong) UIButton *callBut;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, assign) BOOL isLogin;


@property (nonatomic, copy) VoidBlock loginBlock;
@property (nonatomic, copy) VoidBlock callBlock;



@end
