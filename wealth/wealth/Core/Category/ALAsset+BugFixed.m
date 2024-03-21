//
//  ALAsset+BugFixed.m
//  wealth
//
//  Created by wangyingjie on 15/7/25.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "ALAsset+BugFixed.h"

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end

@implementation ALAsset (BugFixed)

- (UIImage *)getCustomImage {
    UIImage *result = nil;
    // 处理被iOS自带Photos修改过的图片
    if ([[self valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
        ALAssetRepresentation *rep = [self defaultRepresentation];
        NSString *adj = [rep metadata][@"AdjustmentXMP"];
        if ( adj ) {
            CGImageRef fullResImage = [rep fullResolutionImage];
            NSData *xmlData = [adj dataUsingEncoding:NSUTF8StringEncoding];
            CIImage *image = [CIImage imageWithCGImage:fullResImage];
            NSError *error = nil;
            NSArray *filters = [CIFilter filterArrayFromSerializedXMP:xmlData
                                                     inputImageExtent:[image extent]
                                                                error:&error];
            CIContext *context = [CIContext contextWithOptions:nil];
            if (filters && !error) {
                for (CIFilter *filter in filters) {
                    [filter setValue:image forKey:kCIInputImageKey];
                    image = [filter outputImage];
                }
                fullResImage = [context createCGImage:image fromRect:[image extent]];
                result = [UIImage imageWithCGImage:fullResImage
                                             scale:[rep scale]
                                       orientation:(UIImageOrientation)[rep orientation]];
            }
        }
    }
    if ( result == nil ) {
        result = [UIImage imageWithCGImage:[self defaultRepresentation].fullScreenImage];
    }
    if ( result == nil ) {
        result = [UIImage imageWithCGImage:[self thumbnail]];
    }
    if ( result == nil ) {
        result = [UIImage imageWithCGImage:[self aspectRatioThumbnail]];
    }
    return result;
}

@end
