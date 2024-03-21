//
//  CustomNavigationBar.h
//  wealth
//
//  Created by wangyingjie on 15/2/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#define kNavigationTitleFontSize          17

@interface CustomNavigationBar : UIView

@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;


@property (nonatomic, strong) UIImage *backImg;
@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIView   *titleBackView;
@property (nonatomic, strong) UIView     *bottomLine;
@property (nonatomic, copy) NSString   *title;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView   *titleView;
@property (nonatomic, strong) UIColor  *titleColor;

@end
