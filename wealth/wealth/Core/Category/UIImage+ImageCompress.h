//
//  UIImage+ImageCompress.h
//  wealth
//
//  Created by wangyingjie on 15/1/23.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageCompress)

/**
 Compress a UIImage to the specified ratio
 
 @param image The image to compress
 @param ratio The compress ratio to compress to
 
 */
+ (UIImage *)compressImage:(UIImage *)image
             compressRatio:(CGFloat)ratio;

/**
 Compress a UIImage to the specified ratio with a max ratio compression
 
 @param image The image to compress
 @param ratio The compress ratio to compress to
 @param maxRatio The maximum compression ratio for the image
 
 */
+ (UIImage *)compressImage:(UIImage *)image
             compressRatio:(CGFloat)ratio
          maxCompressRatio:(CGFloat)maxRatio;

/**
 Compress a remote UIImage to the specified ratio with a max ratio compression
 
 @param url The remote image URL to compress
 @param ratio The compress ratio to compress to
 
 */
+ (UIImage *)compressRemoteImage:(NSString *)url
                   compressRatio:(CGFloat)ratio;

/**
 Compress a remote UIImage to the specified ratio with a max ratio compression
 
 @param url The remote image URL to compress
 @param ratio The compress ratio to compress to
 @param maxRatio The maximum compression ratio for the image
 
 */
+ (UIImage *)compressRemoteImage:(NSString *)url
                   compressRatio:(CGFloat)ratio
                maxCompressRatio:(CGFloat)maxRatio;

/**
 Scale a UIImage to the specified width and height
 
 @param width The specified width to compress
 @param height The specified height to compress
 
 */
- (UIImage *)scaledImageWidth:(CGFloat)width height:(CGFloat)height;

/**
 Scale a UIImage to the specified scale
 
 @param scale The specified scale to compress
 
 */
- (UIImage *)scaledImage:(CGFloat)scale;

@end
