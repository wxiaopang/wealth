//
//  FullScreenImageController.h
//  wealth
//
//  Created by wangyingjie on 15/1/23.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AspectFit)

- (CGRect)tgr_aspectFitRectForSize:(CGSize)size orientation:(UIInterfaceOrientation)orientation;

@end

@interface FullScreenImageZoomAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

// The image view that will be used as the source (zoom in) or destination
// (zoom out) of the transition.
@property (weak, nonatomic, readonly) UIImageView *referenceImageView;

// Initializes the receiver with the specified reference image view.
- (id)initWithReferenceImageView:(UIImageView *)referenceImageView;

@end

@interface FullScreenImageController : UIViewController

@property (strong, nonatomic) UIScrollView *scrollView;

// The image view that displays the image.
@property (strong, nonatomic) UIImageView *imageView;

// The image that will be shown.
@property (strong, nonatomic, readonly) UIImage *image;

@property (assign, nonatomic, readonly) CGRect imageFrame;

@property (assign, nonatomic) CGRect imagePortraitFrame;
@property (assign, nonatomic) CGRect imageLandscapeFrame;

// Initializes the receiver with the specified image.
- (instancetype)initWithImage:(UIImage *)image;

@end
