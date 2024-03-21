//
//  SGAlertMenu.h
//  SGActionView
//
//  Created by wangyingjie on 15/2/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGBaseMenu.h"

@interface SGAlertMenu : SGBaseMenu

- (id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSString *)buttonTitles,...;

- (void)triggerSelectedAction:(void(^)(NSInteger))actionHandle;

@end
