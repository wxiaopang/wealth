//
//  EGORefreshTableHeaderView.h
//  wealth
//
//  Created by wangyingjie on 15/3/26.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EGOPullRefreshState) {
    EGOOPullRefreshPulling = 0,
    EGOOPullRefreshNormal,
    EGOOPullRefreshLoading,
    EGOOPullRefreshEnd,
};

@protocol EGORefreshTableHeaderDelegate;

@interface EGORefreshTableHeaderView : UIView

@property (nonatomic, weak) UILabel *lastUpdatedLabel;
@property (nonatomic, weak) UILabel *statusLabel;
@property (nonatomic, weak) UIActivityIndicatorView *activityView;
@property (nonatomic, weak) CALayer *stateImage;
@property (nonatomic, weak) id<EGORefreshTableHeaderDelegate> delegate;
@property (nonatomic, assign) EGOPullRefreshState state;

- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

@protocol EGORefreshTableHeaderDelegate <NSObject>

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view;
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view;

@optional
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view;

@end
