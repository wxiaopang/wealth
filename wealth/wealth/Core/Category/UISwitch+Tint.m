//
//  UISwitch+Tint.m
//  wealth
//
//  Created by wangyingjie on 15/7/20.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UISwitch+Tint.h"

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end

static void * const UISwitchStateChangedKey = (void*)&UISwitchStateChangedKey;

@implementation UISwitch (Tint)

- (void)setDidStateChanged:(UISwitchStateChanged)didStateChanged {
    objc_setAssociatedObject(self, &UISwitchStateChangedKey, didStateChanged, OBJC_ASSOCIATION_COPY_NONATOMIC);

    if ( didStateChanged ) {
        @weakify(self);
        [[self.rac_newOnChannel distinctUntilChanged] subscribeNext:^(id x) {
            @strongify(self);
            if ( didStateChanged ) {
                didStateChanged(self);
            }
        }];
    }
}

- (UISwitchStateChanged)didStateChanged {
    return objc_getAssociatedObject(self, &UISwitchStateChangedKey);
}

@end
