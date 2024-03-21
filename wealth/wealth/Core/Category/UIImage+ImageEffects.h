//
//  UIImage+ImageEffects.h
//  wealth
//
//  Created by wangyingjie on 15/1/23.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BlurType) {
    NOBLUR,
    BOXFILTER,
    TENTFILTER
};

@interface UIImage (ImageEffects)

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyDarkEffectWithTent:(CGFloat)radius;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                        blurType:(BlurType)blurType
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage*)renderImage:(NSString *)imagName;

//截取图片的某一部分
- (UIImage *)clipImageInRect:(CGRect)rect;

- (UIImage *)fixOrientation;

- (UIImage *)addWatermarkForText:(NSString *)mark;

- (UIImage *)addWatermarkForImage:(UIImage *)watermarkImage;

- (UIImage *)rotation:(UIImageOrientation)orientation;

- (UIColor*)mostColor;

@end
