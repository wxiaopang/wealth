//
//  FLActionSheetView.h
//  WarnningDetailViewController.m
//
//  Created by 刘红波 on 15/4/2.
//  Copyright (c) 2015年 flex_lau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLActionSheetView;
@protocol FLActionSheetViewDelegate<NSObject>
-(void)flActionSheetView:(FLActionSheetView *)flActionSheetView ClickOnButtonIndex:(NSInteger)buttonIndex;

@optional
-(void)flActionSheetViewClickOnDestructiveButton:(FLActionSheetView *)flActionSheetView;
-(void)flActionSheetViewClickOnCancleButton:(FLActionSheetView *)flActionSheetView;
@end

@interface FLActionSheetView : UIView
-(id)initWithTitle:(NSString *)title delegate:(id<FLActionSheetViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray;
-(void)showInView:(UIView *)view;
@end
