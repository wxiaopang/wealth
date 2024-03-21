//
//  GesturePasswordView.h
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

@protocol GesturePasswordDelegate <NSObject>

- (void)forget;
- (void)change;
- (void)useOther;

@end

#import <UIKit/UIKit.h>
#import "TentacleView.h"

@interface GesturePasswordView : UIView<TouchBeginDelegate>

@property (nonatomic, assign) UIEdgeInsets tentacleInsets;
@property (nonatomic, strong) TentacleView * tentacleView;
@property (nonatomic, strong) UIImage *blurImage;

@property (nonatomic,strong) UILabel * state;

@property (nonatomic, weak) id<GesturePasswordDelegate> gesturePasswordDelegate;

@property (nonatomic,strong) UIImageView * imgView;
@property (nonatomic,strong) UIButton * forgetButton;
@property (nonatomic,strong) UIButton * changeButton;
@property (nonatomic,strong) UIButton * useOtherButton;

@end
