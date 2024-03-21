//
//  EGORefreshTableHeaderView.m
//  wealth
//
//  Created by wangyingjie on 15/3/26.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "EGORefreshTableHeaderView.h"

//#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define TEXT_COLOR  [UIColor formLeftTitleEditingColor]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableHeaderView ()

@property (nonatomic, weak) CALayer *arrowImage;

@end

@implementation EGORefreshTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor viewControllerBackgroundColor];
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
//        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        label.font = [UIFont systemFontOfSize:12.0f];
//        label.textColor = TEXT_COLOR;
//        label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
//        label.backgroundColor = [UIColor clearColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:label];
//        _lastUpdatedLabel = label;
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f,
                                                                   frame.size.height - 38.0f,
                                                                   self.frame.size.width - 15.0f,
                                                                   20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textColor = TEXT_COLOR;
//        label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statusLabel = label;
        
//        CALayer *layer = [CALayer layer];
//        layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
//        layer.contentsGravity = kCAGravityResizeAspect;
//        layer.contents = (id)[UIImage imageNamed:@"blueArrow"].CGImage;
//        
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
//        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//            layer.contentsScale = [[UIScreen mainScreen] scale];
//        }
//#endif
//        [[self layer] addSublayer:layer];
//        _arrowImage = layer;
        
        NSString *tmp = @"加载完成";
        CGSize textSize = [tmp sizeWithAttributes:@{ NSFontAttributeName:label.font }];
        
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
        view.frame = CGRectMake((frame.size.width - textSize.width - 25.0f)/2, frame.size.height - 38.0f, 20.0f, 20.0f);
        [self addSubview:view];
        _activityView = view;
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake((frame.size.width - textSize.width - 25.0f)/2, frame.size.height - 38.0f, 20.0f, 20.0f);
        layer.contentsGravity = kCAGravityResizeAspect;
        layer.contents = (id)[UIImage imageNamed:@"com_refresh_finish"].CGImage;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            layer.contentsScale = [[UIScreen mainScreen] scale];
        }
#endif
        [[self layer] addSublayer:layer];
        _stateImage = layer;
        
        self.state = EGOOPullRefreshNormal;
    }
    
    return self;
    
}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
    
    if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
        
        NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setAMSymbol:@"AM"];
        [formatter setPMSymbol:@"PM"];
        [formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
        _lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [formatter stringFromDate:date]];
        [[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        _lastUpdatedLabel.text = nil;
    }
}

- (void)setState:(EGOPullRefreshState)aState {

    switch (aState) {
        case EGOOPullRefreshPulling:
            
//            _statusLabel.text = @"松开刷新";
            _stateImage.hidden = YES;
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
            
            break;
        case EGOOPullRefreshNormal:
            
            if (_state == EGOOPullRefreshPulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            
//            _statusLabel.text = @"向下滑动刷新";
            _statusLabel.text = @"";
            _stateImage.hidden = YES;
            
            [_activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
            
            [self refreshLastUpdatedDate];
            
            break;
        case EGOOPullRefreshLoading:
            
            _statusLabel.text = @"加载中";
            _stateImage.hidden = YES;
            
            [_activityView startAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = YES;
            [CATransaction commit];
            
            break;
        default:
            _statusLabel.text = @"加载完成";
            _stateImage.hidden = NO;
            
            [_activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
            
            [self refreshLastUpdatedDate];
            break;
    }
    
    _state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ( _state == EGOOPullRefreshEnd ) {
        [self setState:EGOOPullRefreshNormal];
    }
    
    if (_state == EGOOPullRefreshLoading) {
        
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, 60);
        scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
        
    } else if (scrollView.isDragging) {
        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
            _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
        }
        
        if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
            [self setState:EGOOPullRefreshNormal];
        } else if ( _state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
            [self setState:EGOOPullRefreshPulling];
        }

        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    
    if ( _state == EGOOPullRefreshEnd )
        return;
    
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
        _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
    }
    
    if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
        
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
            [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
        }
        
        [self setState:EGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
        
    }
    
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];
    
//    [self setState:EGOOPullRefreshNormal];
    [self setState:EGOOPullRefreshEnd];
    
}

@end