//
//  UIButton+Params.h
//  CTKeyboard
//
//  Created by wangyingjie on 15/7/31.
//  Copyright (c) 2015年 Keyboard. All rights reserved.
//
//  按钮的扩展类
//

#import <UIKit/UIKit.h>

@interface UIButton (Params)

@property (nonatomic, assign) NSInteger otherTag;     /**< 按钮类型标记 可当做第二个Tag值使用 */

/** 设置图片的背景图 */
- (void)setBackgroundImage:(NSString *)normal highlighted:(NSString *)highlighted;


@end
