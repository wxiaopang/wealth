//
//  UCAddBankViewController.h
//  wealth
//
//  Created by wangyingjie on 16/4/19.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UIBaseViewController.h"

@protocol selectBankDelegate <NSObject>

- (void)selectBankWith:(NSUInteger)index;

@end

@interface UCAddBankViewController : UIBaseViewController

@property (nonatomic, assign) id<selectBankDelegate> delegate;


@end
