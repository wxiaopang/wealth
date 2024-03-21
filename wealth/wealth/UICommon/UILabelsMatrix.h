//
//  UILabelsMatrix.h
//  wealth
//
//  Created by wangyingjie on 15/2/12.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UILabelsMatrixDelegate;

@interface UILabelsMatrix : UIView

@property (nonatomic, weak) id<UILabelsMatrixDelegate> delegate;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) NSTextAlignment textAlignment;

@property (nonatomic, strong) UIColor *titleLableColor;     // 标题颜色
@property (nonatomic, strong) UIColor *oddRowLableColor;    // 奇数行颜色
@property (nonatomic, strong) UIColor *evenRowLableColor;   // 偶数数行颜色
@property (nonatomic, readonly) NSUInteger numRows;         // 行数

- (instancetype)initWithFrame:(CGRect)frame andColumnsWidths:(NSArray*)columns;

- (NSArray *)addRecord:(NSArray *)record;

- (void)deleteRecord:(NSInteger)row;

@end

@protocol UILabelsMatrixDelegate <NSObject>

- (void)touchUpInsideIndex:(NSInteger)index matrix:(UILabelsMatrix *)matrix;

@end
