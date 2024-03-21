//
//  UIView+BadgeView.h
//  wealth
//
//  Created by wangyingjie on 15/2/28.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleBadgeView : UIView

@end

@interface UIView (BadgeView)

@property (nonatomic, assign) CGRect badgeViewFrame;
@property (nonatomic, strong, readonly) LKBadgeView *badgeView;

- (CircleBadgeView *)setupCircleBadge;

@end
