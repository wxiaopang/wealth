//
//  EGORefreshTableFooterView.h
//  wealth
//
//  Created by wangyingjie on 15/3/31.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, EGOFooterPullRefreshState) {
    EGOOFooterPullRefreshPulling = 0,
    EGOOFooterPullRefreshNormal,
    EGOOFooterPullRefreshLoading,
    EGOOFooterPullRefreshEnd,
};

@protocol EGORefreshTableFooterDelegate;

@interface EGORefreshTableFooterView : UIView

@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, weak) UILabel *statusLabel;
@property (nonatomic, weak) id<EGORefreshTableFooterDelegate> delegate;
@property (nonatomic, assign) EGOFooterPullRefreshState state;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

@protocol EGORefreshTableFooterDelegate <NSObject>

- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView*)view;
- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView*)view;

@end
