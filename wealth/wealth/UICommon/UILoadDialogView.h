//
//  UILoadDialogView.h
//  AiShiDai
//
//  Created by wangyingjie on 15/4/29.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//
//  网络加载的提示视图
//

typedef NS_ENUM (NSInteger, UILoadStatus) {
    UILoadStart,            //开始加载&提交数据
    UILoadFail,             //加载&提交失败
    UILoadSuccess,          //加载&提交成功
    UILoadHide,             //隐藏视图
};

//加载完成后回调
typedef void (^FinishBlock)(void);

#import <UIKit/UIKit.h>

@interface UILoadDialogView : UIView

@property (nonatomic, readonly) UIView      *loadView;              //主要显示视图
@property (nonatomic, readonly) UIImageView *statusImageView;       //状态图片视图
@property (nonatomic, readonly) UILabel     *statusLabel;           //状态文字Label
@property (nonatomic, readonly) BOOL        isAnimating;            //是否需要动画

//视图状态变更的限制 从开始加载到加载完成之间保持一个最短时间间隔
@property (nonatomic, readonly) BOOL         statusConfine;
@property (nonatomic, copy) NSString         *imageName;          //状态图片的名称
@property (nonatomic, copy) NSString         *msg;                //状态文字
@property (nonatomic, assign) UILoadStatus   loadStatus;            //记录当前的状态
@property (nonatomic, copy) dispatch_block_t finishBlock;                //加载完成后回调

- (void)startAnimating;
- (void)stopAnimating;

@end
