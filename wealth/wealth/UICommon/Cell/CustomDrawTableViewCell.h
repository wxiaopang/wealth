//
//  CustomDrawTableViewCell.h
//  wealth
//
//  Created by wangyingjie on 15/2/15.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CellPositionType) {
    CellPositionType_None,
    CellPositionType_Top,
    CellPositionType_Middle,
    CellPositionType_shortMiddle,
    CellPositionType_Bottom,
    CellPositionType_Single,
};

@interface CustomContentView : UIView

@property (nonatomic, assign) CellPositionType type;

@property (nonatomic, strong) UIColor *topLineColor;

@property (nonatomic, strong) UIColor *middleLineColor;

@property (nonatomic, strong) UIColor *bottomLineColor;

@end

@interface CustomDrawTableViewCell : UITableViewCell

@property (nonatomic, assign) CellPositionType type;

@property (nonatomic, weak) UIColor *topLineColor;

@property (nonatomic, weak) UIColor *middleLineColor;

@property (nonatomic, weak) UIColor *bottomLineColor;

//是否允许修改属性的Frame
@property (nonatomic, assign) BOOL controlFrameChange;

- (void)resetSubViews;

@end
