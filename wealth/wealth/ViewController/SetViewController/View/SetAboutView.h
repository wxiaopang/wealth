//
//  SetAboutView.h
//  wealth
//
//  Created by wangyingjie on 16/3/23.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftAndRightLabelView.h"

@interface SetAboutView : UIView


@property (nonatomic, strong) LeftAndRightLabelView *versionView;

@property (nonatomic, strong) UIView *headerBGView;
@property (nonatomic, strong) UIImageView *headerView;


@property (nonatomic, strong) UILabel *messageLabel;


@end
