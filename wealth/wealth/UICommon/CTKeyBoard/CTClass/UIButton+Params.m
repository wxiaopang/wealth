//
//  UIButton+Params.m
//  CTKeyboard
//
//  Created by wangyingjie on 15/7/31.
//  Copyright (c) 2015年 Keyboard. All rights reserved.
//

#import "UIButton+Params.h"
#import <objc/runtime.h>

static void * const KUIButtonParamsKey = (void *)&KUIButtonParamsKey;

@implementation UIButton (Params)

- (void)setOtherTag:(NSInteger)otherTag
{
    objc_setAssociatedObject(self, KUIButtonParamsKey, @(otherTag), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)otherTag
{
    return [objc_getAssociatedObject(self, KUIButtonParamsKey) integerValue];
}


/** 设置图片的背景图 */
- (void)setBackgroundImage:(NSString *)normal highlighted:(NSString *)highlighted
{
    if ( normal && normal.length > 0 ) {
        [self setBackgroundImage:[[UIImage imageNamed:normal] stretchableImageWithLeftCapWidth:3 topCapHeight:5] forState:UIControlStateNormal];
    }
    if ( highlighted && highlighted.length > 0 ) {
        [self setBackgroundImage:[[UIImage imageNamed:highlighted] stretchableImageWithLeftCapWidth:3 topCapHeight:5] forState:UIControlStateHighlighted];
    }
}

@end
