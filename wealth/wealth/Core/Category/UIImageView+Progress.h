//
//  UIImageView+SY.h
//  Seeyou
//
//  Created by ljh on 14-2-13.
//  Copyright (c) 2014年 linggan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FinishLoadImageBlock)(UIImage *image);

@interface UIImageView (Progress)

//yzf0415新增通过地址获取图片将图片返回
- (void)sd_getImageWithURL:(NSURL *)imageURL
         imageExpectedSize:(NSInteger)imageExpectedSize
          placeHolderImage:(UIImage *)placeHolderImage
             completeBlock:(FinishLoadImageBlock)completeBlock;

@end
