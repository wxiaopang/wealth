//
//  SubmitTransitionButton.h
//  wealth
//
//  Created by wangyingjie on 16/1/7.
//  Copyright © 2016年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinerLayer.h"

typedef void(^Completion)();

@interface SubmitTransitionButton : UIButton

@property (nonatomic, strong) SpinerLayer *spiner;

-(void)setCompletion:(Completion)completion;

-(void)StartAnimation;

-(void)ErrorRevertAnimationCompletion:(Completion)completion;

-(void)ExitAnimationCompletion:(Completion)completion;

@end
