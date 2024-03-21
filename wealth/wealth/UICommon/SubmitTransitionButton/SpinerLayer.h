//
//  SpinerLayer.h
//  wealth
//
//  Created by wangyingjie on 16/1/7.
//  Copyright © 2016年 普惠金融. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface SpinerLayer : CAShapeLayer

- (instancetype)initWithFrame:(CGRect)frame;

- (void)animation;

- (void)stopAnimation;

@end
