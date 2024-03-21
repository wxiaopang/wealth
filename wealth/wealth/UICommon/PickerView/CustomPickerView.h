//
//  CustomPickerView.h
//  wealth
//
//  Created by wangyingjie on 15/2/11.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "WheelView.h"           //滚轮
#import "MagnifierView.h"       //放大

@protocol CustomPickerViewDataSource;
@protocol CustomPickerViewDelegate;

@interface CustomPickerView : UIView<WheelViewDelegate> {
    
    CGFloat centralRowOffset;
    
    MagnifierView *loop;

}

@property (nonatomic, weak) id<CustomPickerViewDelegate> delegate;
@property (nonatomic, weak) id<CustomPickerViewDataSource> dataSource;

@property (nonatomic, strong) UIColor *fontColor;

- (void)update;

- (void)reloadData;

- (void)reloadDataInComponent:(NSInteger)component;

@end

@protocol CustomPickerViewDataSource <NSObject>
@required

- (NSInteger)numberOfComponentsInPickerView:(CustomPickerView *)pickerView;

- (NSInteger)pickerView:(CustomPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@end

@protocol CustomPickerViewDelegate <NSObject>

@optional

- (CGFloat)pickerView:(CustomPickerView *)pickerView widthForComponent:(NSInteger)component;
//- (CGFloat)pickerView:(CustomPickerView *)pickerView rowHeightForComponent:(NSInteger)component;

- (NSString *)pickerView:(CustomPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

//- (UIView *)pickerView:(CustomPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

- (void)pickerView:(CustomPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;


@end


