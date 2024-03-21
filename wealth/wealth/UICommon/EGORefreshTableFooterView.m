//
//  EGORefreshTableFooterView.m
//  wealth
//
//  Created by wangyingjie on 15/3/31.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "EGORefreshTableFooterView.h"

#define TEXT_COLOR  [UIColor formLeftTitleEditingColor]
#define FLIP_ANIMATION_DURATION 0.18f

@interface EGORefreshTableFooterView ()

@property (nonatomic, weak) CALayer *arrowImage;
@property (nonatomic, weak) UIActivityIndicatorView *activityView;

- (void)setState:(EGOFooterPullRefreshState)aState;

@end

@implementation EGORefreshTableFooterView

- (instancetype)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor viewControllerBackgroundColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 15.0f, self.frame.size.width - 15.0f, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textColor = textColor;
        label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statusLabel = label;
        
//        CALayer *layer = [CALayer layer];
//        layer.frame = CGRectMake(frame.size.width - 85.0f, 15.0f, 20.0f, 40.0f);
//        layer.contentsGravity = kCAGravityResizeAspect;
//        layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
//        
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
//        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//            layer.contentsScale = [[UIScreen mainScreen] scale];
//        }
//#endif
//        
//        [[self layer] addSublayer:layer];
//        _arrowImage = layer;
        
        NSString *tmp = @"加载完成";
        CGSize textSize = [tmp sizeWithAttributes:@{ NSFontAttributeName:label.font }];
        
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        view.frame = CGRectMake((frame.size.width - textSize.width - 25.0f)/2, 15.0f, 20.0f, 20.0f);
        [self addSubview:view];
        _activityView = view;
        
        [self setState:EGOOFooterPullRefreshNormal];
        
    }
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame  {
    return [self initWithFrame:frame arrowImageName:@"blueArrowReversal" textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters


- (void)setState:(EGOFooterPullRefreshState)aState{
    
    switch (aState) {
        case EGOOFooterPullRefreshPulling:
            
//            _statusLabel.text = @"松开即可加载";
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
            break;
        case EGOOFooterPullRefreshNormal:
            
            if (_state == EGOOFooterPullRefreshPulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            
//            _statusLabel.text = @"上拉加载更多";
            _statusLabel.text = @"";
            
            [_activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
            
            break;
        case EGOOFooterPullRefreshLoading:
            
            _statusLabel.text = @"加载中";
            [_activityView startAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = YES;
            [CATransaction commit];
            
            break;
        default:
            _statusLabel.text = @"没有更多";
            
            [_activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
            
            break;
    }
    
    _state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
    if ( _state == EGOOFooterPullRefreshEnd )
        return;
    
    if (_state == EGOOFooterPullRefreshLoading) {
        CGFloat offset = MAX(scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height , 0);
        offset = MIN(offset, 60);
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, offset, 0.0f);
        
    } else if ( scrollView.isDragging ) {
        CGFloat scrollHight = MIN(scrollView.frame.size.height, scrollView.contentSize.height);
        
        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(egoRefreshTableFooterDataSourceIsLoading:)]) {
            _loading = [_delegate egoRefreshTableFooterDataSourceIsLoading:self];
        }
        
        if (_state == EGOOFooterPullRefreshPulling &&
            scrollHight + scrollView.contentOffset.y < scrollView.contentSize.height + 65.0f &&
            scrollHight + scrollView.contentOffset.y > scrollView.contentSize.height && !_loading) {
            [self setState:EGOOFooterPullRefreshNormal];
        } else if (_state == EGOOFooterPullRefreshNormal &&
                   scrollHight + scrollView.contentOffset.y > scrollView.contentSize.height + 65.0f && !_loading) {
            [self setState:EGOOFooterPullRefreshPulling];
        }
        
        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
        
    }
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    if ( _state == EGOOFooterPullRefreshEnd )
        return;
    
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(egoRefreshTableFooterDataSourceIsLoading:)]) {
        _loading = [_delegate egoRefreshTableFooterDataSourceIsLoading:self];
    }
    
    CGFloat scrollHight = MIN(scrollView.frame.size.height, scrollView.contentSize.height);
    if (scrollHight + scrollView.contentOffset.y >= scrollView.contentSize.height + 65.0f && !_loading) {
        
        if ([_delegate respondsToSelector:@selector(egoRefreshTableFooterDidTriggerRefresh:)]) {
            [_delegate egoRefreshTableFooterDidTriggerRefresh:self];
        }
        
        [self setState:EGOOFooterPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
        [UIView commitAnimations];
   
    }
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
    if ( _state == EGOOFooterPullRefreshEnd )
        return;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];

    [self setState:EGOOFooterPullRefreshNormal];
}

@end
