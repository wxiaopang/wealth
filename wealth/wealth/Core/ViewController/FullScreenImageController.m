//
//  FullScreenImageController.m
//  wealth
//
//  Created by wangyingjie on 15/1/23.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import "FullScreenImageController.h"

#pragma mark -- implementation UIImage(AspectFit)

@implementation UIImage (AspectFit)

- (CGRect)tgr_aspectFitRectForSize:(CGSize)size orientation:(UIInterfaceOrientation)orientation {
    CGFloat targetAspect = size.width / size.height;
    CGFloat sourceAspect = self.size.width / self.size.height;
    CGRect rect = CGRectZero;
    
    if ( orientation ) {
        if (targetAspect > sourceAspect) {
            rect.size.height = size.height;
            rect.size.width = ceilf(rect.size.height * sourceAspect);
            rect.origin.x = ceilf((size.width - rect.size.width) * 0.5);
        } else {
            rect.size.width = size.width;
            rect.size.height = ceilf(rect.size.width / sourceAspect);
            rect.origin.y = ceilf((size.height - rect.size.height) * 0.5);
        }
    } else {
        rect.size.height = size.height;
        rect.size.width = size.width;
    }
    return rect;
}

@end

#pragma mark -- implementation FullScreenImageZoomAnimationController

@implementation FullScreenImageZoomAnimationController

- (id)initWithReferenceImageView:(UIImageView *)referenceImageView {
    if (self = [super init]) {
        _referenceImageView = referenceImageView;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *viewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    return viewController.isBeingPresented ? 0.5 : 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *viewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (viewController.isBeingPresented) {
        [self animateZoomInTransition:transitionContext];
    } else {
        [self animateZoomOutTransition:transitionContext];
    }
}

- (void)animateZoomInTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // Get the view controllers participating in the transition
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    FullScreenImageController *toViewController = (FullScreenImageController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSAssert([toViewController isKindOfClass:[FullScreenImageController class]], @"*** toViewController must be a FullScreenImageController!");
    
    // Create a temporary view for the zoom in transition and set the initial frame based
    // on the reference image view
    UIImageView *transitionView = [[UIImageView alloc] initWithImage:self.referenceImageView.image];
    transitionView.contentMode = UIViewContentModeScaleAspectFit;
    transitionView.clipsToBounds = YES;
    transitionView.frame = [transitionContext.containerView convertRect:self.referenceImageView.bounds
                                                               fromView:self.referenceImageView];
    [transitionContext.containerView addSubview:transitionView];
    
    // Compute the final frame for the temporary view
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    if ( UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation]) ) {
        toViewController.imagePortraitFrame = [self.referenceImageView.image tgr_aspectFitRectForSize:finalFrame.size
                                                                                          orientation:UIInterfaceOrientationPortrait];
        toViewController.imageLandscapeFrame = [self.referenceImageView.image tgr_aspectFitRectForSize:CGSizeMake(finalFrame.size.height, finalFrame.size.width)
                                                                                           orientation:UIInterfaceOrientationLandscapeLeft];
    } else {
        toViewController.imageLandscapeFrame = [self.referenceImageView.image tgr_aspectFitRectForSize:finalFrame.size
                                                                                          orientation:UIInterfaceOrientationPortrait];
        toViewController.imagePortraitFrame = [self.referenceImageView.image tgr_aspectFitRectForSize:CGSizeMake(finalFrame.size.height, finalFrame.size.width)
                                                                                           orientation:UIInterfaceOrientationLandscapeLeft];
    }
    
    // Perform the transition using a spring motion effect
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    self.referenceImageView.alpha = 0;
    
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromViewController.view.alpha = 0;
                         transitionView.frame = toViewController.imageFrame;
                         toViewController.imageView.frame = toViewController.imageFrame;
                     }
                     completion:^(BOOL finished) {
                         fromViewController.view.alpha = 1;
                         
                         [transitionView removeFromSuperview];
                         [transitionContext.containerView addSubview:toViewController.view];
                         
                         [transitionContext completeTransition:YES];
                     }];
}

- (void)animateZoomOutTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // Get the view controllers participating in the transition
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    FullScreenImageController *fromViewController = (FullScreenImageController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    NSAssert([fromViewController isKindOfClass:[FullScreenImageController class]], @"*** fromViewController must be a FullScreenImageController!");
    
    // The toViewController view will fade in during the transition
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0;
    [transitionContext.containerView addSubview:toViewController.view];
    [transitionContext.containerView sendSubviewToBack:toViewController.view];
    
    // Compute the initial frame for the temporary view based on the image view
    // of the TGRImageViewController
    CGRect transitionViewInitialFrame = [fromViewController.imageView.image tgr_aspectFitRectForSize:fromViewController.imageView.bounds.size
                                                                                         orientation:[[UIApplication sharedApplication]statusBarOrientation]];
    transitionViewInitialFrame = [transitionContext.containerView convertRect:transitionViewInitialFrame
                                                                     fromView:fromViewController.imageView];
    
    // Compute the final frame for the temporary view based on the reference
    // image view
    CGRect transitionViewFinalFrame = [transitionContext.containerView convertRect:self.referenceImageView.bounds
                                                                          fromView:self.referenceImageView];
    
    if (UIApplication.sharedApplication.isStatusBarHidden && ![toViewController prefersStatusBarHidden]) {
        transitionViewFinalFrame = CGRectOffset(transitionViewFinalFrame, 0, 20);
    }
    
    // Create a temporary view for the zoom out transition based on the image
    // view controller contents
    UIImageView *transitionView = [[UIImageView alloc] initWithImage:fromViewController.imageView.image];
    transitionView.contentMode = UIViewContentModeScaleAspectFit;
    transitionView.clipsToBounds = YES;
    transitionView.frame = transitionViewInitialFrame;
    [transitionContext.containerView addSubview:transitionView];
    [fromViewController.view removeFromSuperview];
    
    // Perform the transition
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         toViewController.view.alpha = 1;
                         transitionView.frame = transitionViewFinalFrame;
                     } completion:^(BOOL finished) {
                         self.referenceImageView.alpha = 1;
                         [transitionView removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
}

@end

#pragma mark -- implementation FullScreenImageController

@interface FullScreenImageController () <UIScrollViewDelegate>

@property (strong, nonatomic) UITapGestureRecognizer *singleTapGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTapGestureRecognizer;

@end

@implementation FullScreenImageController

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        _image = image;
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.contentSize = frame.size;
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.showsHorizontalScrollIndicator = _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.minimumZoomScale = 1.0f;
    _scrollView.maximumZoomScale = 3.0f;
    [self.view addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:frame];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _imageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_imageView];
    
    _singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    _singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [_imageView addGestureRecognizer:_singleTapGestureRecognizer];
    
    _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [_imageView addGestureRecognizer:_doubleTapGestureRecognizer];
    
    [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
    
    self.imageView.image = self.image;
}

- (CGRect)imageFrame {
    if ( UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation]) ) {
        return _imagePortraitFrame;
    } else {
        return _imageLandscapeFrame;
    }
}

#pragma mark -- UIViewControllerRotation

-(BOOL)shouldAutorotate {
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if ( self.scrollView.zoomScale != self.scrollView.minimumZoomScale ) {
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
        [self.scrollView zoomToRect:self.scrollView.bounds animated:YES];
    }
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ) {
        
    } else {
        self.imageView.frame = self.scrollView.frame;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if ( UIInterfaceOrientationIsPortrait(fromInterfaceOrientation) ) {

    } else {
        self.imageView.frame = self.imageFrame;
    }
}

#pragma mark - UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (self.scrollView.zoomScale < self.scrollView.minimumZoomScale) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
}

#pragma mark - Private methods

- (void)handleSingleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
            [self.scrollView zoomToRect:self.scrollView.bounds animated:YES];
        }];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [UIView animateWithDuration:0.3 animations:^{
        if (self.scrollView.zoomScale < self.scrollView.maximumZoomScale) {
            // Zoom in
            self.imageView.frame = [UIScreen mainScreen].bounds;
            self.scrollView.zoomScale = self.scrollView.maximumZoomScale;
            CGPoint center = [tapGestureRecognizer locationInView:self.imageView];
            self.scrollView.contentOffset = center;
        } else {
            // Zoom out
            self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
            [self.scrollView zoomToRect:self.scrollView.bounds animated:YES];
            self.imageView.frame = self.imageFrame;
        }
    }];
}

@end
