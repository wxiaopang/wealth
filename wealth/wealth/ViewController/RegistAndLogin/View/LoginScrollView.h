//
//  LoginScrollView.h
//  wealth
//
//  Created by wangyingjie on 16/3/18.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LARTextFeildView.h"


@protocol LoginViewDelegate <NSObject>

@optional




@end



@interface LoginScrollView : UIScrollView


@property (nonatomic, strong) LARTextFeildView *fristTextFeild;   /**<*/
@property (nonatomic, strong) LARTextFeildView *secondTextFeild;   /**<*/

@property (nonatomic, copy) VoidBlock messageBlock;
@property (nonatomic, copy) VoidBlock topButtonBlock;
@property (nonatomic, copy) VoidBlock botButtonBlock;
@property (nonatomic, copy) VoidBlock backBlock;

@end
