//
//  IconAndLabelView.h
//  wealth
//
//  Created by wangyingjie on 16/3/22.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconAndLabelView : UIView


@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;


- (void)setIconView:(UIImage *)icon AndTitle:(NSString *)title;
- (void)setTitle:(NSString *)title AndIconView:(UIImage *)icon;


@end
