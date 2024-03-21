//
//  UINoNetWorkView.h
//  wealth
//
//  Created by wangyingjie on 16/4/5.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UINoNetWorkViewDelegate<NSObject>

- (void)reloadButtonClick;

@end

@interface UINoNetWorkView : UIView

@property(nonatomic,weak)id<UINoNetWorkViewDelegate>delegate;



@end
