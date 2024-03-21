//
//  MagnifierView.h
//  wealth
//
//  Created by wangyingjie on 15/2/11.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagnifierView : UIView

@property (nonatomic, strong) UIView *viewToMagnify;
@property (nonatomic, assign) CGPoint touchPoint;

@end
