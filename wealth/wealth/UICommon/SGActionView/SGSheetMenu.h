//
//  SGSheetMenu.h
//  SGActionView
//
//  Created by wangyingjie on 15/2/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGBaseMenu.h"

@interface SGSheetMenu : SGBaseMenu

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles;

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles subTitles:(NSArray *)subTitles;

@property (nonatomic, assign) NSUInteger selectedItemIndex;

- (void)triggerSelectedAction:(void(^)(NSInteger))actionHandle;

@end
