//
//  UITwoDropListFormView.h
//  wealth
//
//  Created by yangzhaofeng on 15/3/2.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDropListFormView.h"

@interface UITwoDropListFormView : UIView

@property (nonatomic, strong) UIDropListFormView *leftDropListView;
@property (nonatomic, retain) UIDropListFormView *rightDropListView;
@property (nonatomic, assign) CGFloat spaceX;
@property (nonatomic, strong) NSMutableArray *leftDataArray;
@property (nonatomic, strong) NSMutableArray *rightDataArray;

- (instancetype)initWithTheSuperView:(UIView *)theSuperView leftDataArray:(NSArray *)leftDataArray leftPlaceholders:(NSArray *)leftPlaceholders rightDataArray:(NSArray *)rightDataArray rightPlaceholders:(NSArray *)rightPlaceholders;

- (instancetype)initWithFrame:(CGRect)frame theSuperView:(UIView *)theSuperView leftDataArray:(NSArray *)leftDataArray leftPlaceholders:(NSArray *)leftPlaceholders rightDataArray:(NSArray *)rightDataArray rightPlaceholders:(NSArray *)rightPlaceholders;

- (void)didSelectedLeftItemWithLeftBlock:(StringBlock)leftBlock rightBlock:(StringBlock)rightBlock;
@end
