//
//  SGBaseMenu.h
//  SGActionView
//
//  Created by wangyingjie on 15/2/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGActionView.h"

#define BaseMenuBackgroundColor(style) (style == SGActionViewStyleLight \
                                        ? [UIColor colorWithWhite:1.0 alpha:1.0] \
                                        : (style == SGActionViewStyleDark \
                                            ? [UIColor colorWithWhite:0.2 alpha:1.0] \
                                            : [UIColor formLeftTitleNormalColor]))
#define BaseMenuTextColor(style)        (style == SGActionViewStyleLight \
                                         ? [UIColor darkTextColor] \
                                         : (style == SGActionViewStyleDark \
                                            ? [UIColor lightTextColor] \
                                            : [UIColor formLeftTitleNormalColor]))
#define BaseMenuActionTextColor(style)  ([UIColor formLeftTitleNormalColor])

@interface SGButton : UIButton
@end

@interface SGBaseMenu : UIView {
    SGActionViewStyle _style;
}

// if rounded top left/right corner, default is YES.
@property (nonatomic, assign) BOOL roundedCorner;

@property (nonatomic, assign) SGActionViewStyle style;

@end
