//
//  UITableView+Wave.h
//  wealth
//
//  Created by wangyingjie on 15/5/21.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBOUNCE_DISTANCE  4.0f
#define kWAVE_DURATION   0.5f


typedef NS_ENUM(NSInteger,WaveAnimation) {
    LeftToRightWaveAnimation,
    RightToLeftWaveAnimation
};

@interface UITableView (Wave)

- (void)reloadDataAnimateWithWave:(WaveAnimation)animation;

@end
