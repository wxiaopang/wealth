//
//  UIDropListFormView.h
//  wealth
//
//  Created by wangyingjie on 15/2/28.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropListView.h"

@interface UIDropListFormView : UIView

@property (nonatomic, readonly) UILabel *leftLable;
@property (nonatomic, readonly) DropListView *dropListView;
@property (nonatomic, readonly) UILabel *rightLable;

@property (nonatomic, assign) CGFloat spaceX;

@property (nonatomic, strong) NSMutableArray *dataArray;
//若默认显示第一个,则不需要给这个属性赋值;
//需要显示数据源之外的文字作为默认内容时需要给这个数组传值;
@property (nonatomic, strong) NSMutableArray *placeholders;


- (instancetype)initWithTheSuperView:(UIView *)theSuperView;
- (instancetype)initWithFrame:(CGRect)frame theSuperView:(UIView *)theSuperView;
- (void)didSelectedItemWithBlock:(StringBlock)selectedBlock;

@end
