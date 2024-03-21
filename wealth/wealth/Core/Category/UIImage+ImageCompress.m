//
//  UIImage+ImageCompress.m
//  wealth
//
//  Created by wangyingjie on 15/1/23.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import "UIImage+ImageCompress.h"

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
                                    @implementation TT_FIX_CATEGORY_BUG_##name @end

static NSInteger _g_min_upload_resolution_  = 1136 * 640;
static NSInteger _g_max_upload_size_ = 50;

@implementation UIImage (ImageCompress)

+ (UIImage *)compressImage:(UIImage *)image compressRatio:(CGFloat)ratio {
    return [[self class] compressImage:image compressRatio:ratio maxCompressRatio:0.1f];
}

+ (UIImage *)compressImage:(UIImage *)image compressRatio:(CGFloat)ratio maxCompressRatio:(CGFloat)maxRatio {
    CGFloat factor = 0.0f;
    CGFloat currentResolution = image.size.height * image.size.width;
    
    //We first shrink the image a little bit in order to compress it a little bit more
    if (currentResolution > _g_min_upload_resolution_) {
        factor = sqrt(currentResolution / _g_min_upload_resolution_) * 2;
        image = [self scaleDown:image withSize:CGSizeMake(image.size.width / factor, image.size.height / factor)];
    }
    
    //Compression settings
    CGFloat compression = ratio;
    CGFloat maxCompression = maxRatio;
    
    //We loop into the image data to compress accordingly to the compression ratio
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > _g_max_upload_size_ && compression > maxCompression) {
        compression -= 0.10;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    //Retuns the compressed image
    return [[UIImage alloc] initWithData:imageData];
}

+ (UIImage *)compressRemoteImage:(NSString *)url
                   compressRatio:(CGFloat)ratio
                maxCompressRatio:(CGFloat)maxRatio {
    //Parse the URL
    NSURL *imageURL = [NSURL URLWithString:url];
    
    //We init the image with the rmeote data
    UIImage *remoteImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    
    //Returns the remote image compressed
    return [[self class] compressImage:remoteImage compressRatio:ratio maxCompressRatio:maxRatio];
}

+ (UIImage *)compressRemoteImage:(NSString *)url compressRatio:(CGFloat)ratio {
    return [[self class] compressRemoteImage:url compressRatio:ratio maxCompressRatio:0.1f];
}

+ (UIImage*)scaleDown:(UIImage*)image withSize:(CGSize)newSize {
    //We prepare a bitmap with the new size
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    
    //Draws a rect for the image
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    //We set the scaled image from the context
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *)scaledImageWidth:(CGFloat)width height:(CGFloat)height {
    CGRect rect = CGRectIntegral(CGRectMake(0, 0, width, height));
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)scaledImage:(CGFloat)scale {
    CGRect rect = CGRectIntegral(CGRectMake(0, 0, self.size.width*scale, self.size.height*scale));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width*scale, self.size.height*scale), NO, scale);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
