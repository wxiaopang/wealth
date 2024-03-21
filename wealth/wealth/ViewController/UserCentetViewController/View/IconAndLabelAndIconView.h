//
//  IconAndLabelAndIconView.h
//  wealth
//
//  Created by wangyingjie on 16/3/22.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconAndLabelView.h"


@interface IconAndLabelAndIconView : UIView

@property (nonatomic, strong) IconAndLabelView *leftIconAndLabelView;
@property (nonatomic, strong) UIImageView *rightImageView;


- (void)setLeftIcon:(UIImage *)leftIcon AndTitle:(NSString *)title AndRight:(UIImage *)rightIcon;

@end
