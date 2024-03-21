//
//  UITipsView.h
//  wealth
//
//  Created by wangyingjie on 15/4/7.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface TipsButton : UIButton
@end


typedef NS_ENUM(NSInteger, TipsViewType) {
    TipsViewType_Empty,
    TipsViewType_EmptySearch,
    TipsViewType_EmptyMessage,
    TipsViewType_NetworkError,
    TipsViewType_Network404Error,
    TipsViewType_PhotoGraphEmpty,
};

typedef void(^UITipsViewInBtnClickBlock) ();

@interface UITipsView : UIView

@property (nonatomic, assign) TipsViewType type;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *detaiText;

@property (nonatomic, assign) CGFloat yOffset;

@property (nonatomic, copy) UITipsViewInBtnClickBlock btnClickBlock; /**< 刷新按钮点击回调 */

@end
