//
//  UIThreeDropListFormView.h
//  wealth
//
//  Created by yangzhaofeng on 15/3/3.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDropListFormView.h"

@interface UIThreeDropListFormView : UIView

@property (nonatomic, strong) UIDropListFormView *leftDropListView;
@property (nonatomic, strong) UIDropListFormView *middleDropListView;
@property (nonatomic, retain) UIDropListFormView *rightDropListView;
@property (nonatomic, strong) NSMutableArray *leftDataArray;
@property (nonatomic, strong) NSMutableArray *middleDataArray;
@property (nonatomic, strong) NSMutableArray *rightDataArray;
@property (nonatomic, assign) CGFloat spaceX;

- (instancetype)initWithTheSuperView:(UIView *)theSuperView leftDataArray:(NSArray *)leftDataArray leftPlaceholders:(NSArray *)leftPlaceholders middleDataArray:(NSArray *)middleDataArray middlePlaceholders:(NSArray *)middlePlaceholders rightDataArray:(NSArray *)rightDataArray rightPlaceholders:(NSArray *)rightPlaceholders;

- (instancetype)initWithFrame:(CGRect)frame theSuperView:(UIView *)theSuperView leftDataArray:(NSArray *)leftDataArray leftPlaceholders:(NSArray *)leftPlaceholders middleDataArray:(NSArray *)middleDataArray middlePlaceholders:(NSArray *)middlePlaceholders rightDataArray:(NSArray *)rightDataArray rightPlaceholders:(NSArray *)rightPlaceholders;

- (void)didSelectedLeftItemWithLeftBlock:(StringBlock)leftBlock middleBlock:(StringBlock)middleBlock rightBlock:(StringBlock)rightBlock;

@end
