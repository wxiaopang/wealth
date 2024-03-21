//
//  UIButton+count.h
//  wealth
//
//  Created by wangyingjie on 15/12/24.
//  Copyright © 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (count)

@property (nonatomic, assign) NSInteger btnClickedCount;

@property (nonatomic, assign) NSInteger btnFunctionId;

@property (nonatomic, copy) void (^customBtnOnClick)() ;

@end
