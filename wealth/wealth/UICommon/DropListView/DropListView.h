//
//  DropListView.h
//  XSDropDownListView
//
//  Created by yangzhaofeng on 15/2/28.
//  Copyright (c) 2015年 yangzhaofeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropListView;

@protocol DropListViewDelegate <NSObject>

@optional
-(NSInteger)dropListView:(DropListView *)dropListView defaultShowSection:(NSInteger)section;
-(void)dropListView:(DropListView *)dropListView didSelectedInSection:(NSInteger)section index:(NSInteger)index;

@end

@interface DropListView : UIView

@property (nonatomic, assign) id<DropListViewDelegate> dropListDelegate;
@property (nonatomic, strong) UIView *theSuperView;
@property (nonatomic, assign) BOOL isFullSuperWidth;
@property (nonatomic, strong) NSMutableArray *dataArray;

/*
 theSuperView:     下拉菜单所要添加的父视图
 isFullSuperWidth: 下拉菜单是否与父视图等宽,YES-等宽,NO-不等宽(总宽度除以section的数量)
*/
//特别注意:数据源一定是二维数组!!!
//初始化frame
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate theSuperView:(UIView *)theSuperView isFullSuperWidth:(BOOL)isFullSuperWidth dataArray:(NSArray *)dataArray placeholders:(NSArray *)placeholders;
//不初始化frame
- (id)initWithDelegate:(id)delegate theSuperView:(UIView *)theSuperView isFullSuperWidth:(BOOL)isFullSuperWidth dataArray:(NSArray *)dataArray placeholders:(NSArray *)placeholders;

@end