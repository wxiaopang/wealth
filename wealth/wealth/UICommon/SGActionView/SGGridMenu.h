//
//  SGGridMenu.h
//  SGActionView
//
//  Created by wangyingjie on 15/2/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGBaseMenu.h"

@interface SGGridMenu : SGBaseMenu

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles images:(NSArray *)images;

- (void)triggerSelectedAction:(void(^)(NSInteger))actionHandle;

@end
