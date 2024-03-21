//
//  UIColor+Change.h
//  wealth
//
//  Created by wangyingjie on 15/2/5.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (Change)

///  获取canvas用的颜色字符串
- (NSString *)canvasColorString;

///获取网页颜色字串
- (NSString *) webColorString;

///获取RGB值
- (CGFloat *) getRGB;

///让颜色更亮
- (UIColor *) lighten;

///让颜色更暗
- (UIColor *) darken;

///取两个颜色的中间
- (UIColor *) mix: (UIColor *) color;

@end
