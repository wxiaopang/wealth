//
//  UIImageView+SY.m
//  Seeyou
//
//  Created by ljh on 14-2-13.
//  Copyright (c) 2014年 linggan. All rights reserved.
//

#import "UIImageView+Progress.h"
#import "LK_THProgressView.h"
#import <objc/runtime.h>

#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

#ifdef dispatch_main_async_safe

#define __lk_setImageWithURL__ sd_setImageWithURL
#define __lk_cancelImageLoad__ sd_cancelCurrentImageLoad
#define __lk_completedURL__ ,NSURL* url

#else

#define __lk_setImageWithURL__ setImageWithURL
#define __lk_cancelImageLoad__ cancelCurrentImageLoad
#define __lk_completedURL__

#endif

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end

@implementation UIImageView (Progress)

- (LK_THProgressView *)lk_progressView:(BOOL)isCreate
{
    const int imageProgressTag = 41251;
    LK_THProgressView *progressView = (id)[self viewWithTag:imageProgressTag];
    if (isCreate)
    {
        int pwidth = ceil(self.frame.size.width * 0.76);
        if (progressView == nil)
        {
            progressView = [[LK_THProgressView alloc] initWithFrame:CGRectMake(0, 0,pwidth, 20)];
            progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
            progressView.progressTintColor = [UIColor whiteColor];
            progressView.borderTintColor = [UIColor whiteColor];
            progressView.hidden = YES;
            progressView.tag = imageProgressTag;
            
            [self addSubview:progressView];
        }
        CGRect frame = progressView.frame;
        frame.size.width = pwidth;
        progressView.frame = frame;
        progressView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        progressView.hidden = NO;
        
        [self bringSubviewToFront:progressView];
    }
    return progressView;
}

-(void)lk_hideProgressView
{
    LK_THProgressView *pv = [self lk_progressView:NO];
    pv.hidden = YES;
    pv.progress = 0;
    [pv removeFromSuperview];
}

//yzf0415新增通过地址获取图片将图片返回
- (void)sd_getImageWithURL:(NSURL *)imageURL imageExpectedSize:(NSInteger)imageExpectedSize placeHolderImage:(UIImage *)placeHolderImage completeBlock:(FinishLoadImageBlock)completeBlock {
    __block LK_THProgressView *pv = [self lk_progressView:YES];
    pv.progress = 0;
    pv.hidden = NO;
    [pv setNeedsDisplay];
    [self setNeedsDisplay];
    
    @weakify(self);
    [self sd_setImageWithURL:imageURL placeholderImage:placeHolderImage options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        @strongify(self);
        if(imageExpectedSize <= 0) {
            return;
        }
        float pvalue = MAX(0, MIN(1, receivedSize / (float) imageExpectedSize));
        dispatch_main_sync_safe(^{
            if(self.image == nil) {
                if(!pv) {
                    pv = [self lk_progressView:YES];
                }
                pv.hidden = NO;
            }
            pv.progress = pvalue;
        });
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self lk_hideProgressView];
        if (image) {
            dispatch_main_sync_safe(^{
                if (completeBlock) {
                    completeBlock (image);
                }
            });
        }
        else {
            dispatch_main_sync_safe(^{
                if (completeBlock) {
                    completeBlock (nil);
                }
            });
            if (error) {
                
            }
            else {
                
            }
        }

    }];
}

@end