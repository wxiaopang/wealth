//
//  UICustomSwitch.h
//  CinCommon
//
//  Created by aimy on 13-10-23.
//  Copyright (c) 2013年 p. All rights reserved.
//

@class UICustomSwitch;

typedef void(^UICustomSwitchCompelete)(UICustomSwitch *btn);

@interface UICustomSwitch : UIControl

@property (nonatomic, assign) BOOL on;

@property (nonatomic, strong) UIColor *inactiveColor;

@property (nonatomic, strong) UIColor *activeColor;

@property (nonatomic, strong) UIColor *onColor;

@property (nonatomic, strong) UIColor *knobColor;

@property (nonatomic, assign) BOOL isRounded;

@property (nonatomic, copy) UICustomSwitchCompelete compelete;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
