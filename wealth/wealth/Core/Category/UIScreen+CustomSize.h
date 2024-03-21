//
//  UIScreen+CustomSize.h
//  wealth
//
//  Created by wangyingjie on 15/7/6.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (CustomSize)

- (CGRect)currentBounds;

- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation;

@property (nonatomic, readonly) CGSize sizeInPixel;

@property (nonatomic, readonly) CGFloat pixelsPerInch;

@end
