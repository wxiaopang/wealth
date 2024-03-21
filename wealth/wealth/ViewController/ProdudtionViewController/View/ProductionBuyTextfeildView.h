//
//  ProductionBuyTextfeildView.h
//  wealth
//
//  Created by wangyingjie on 16/3/29.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductionBuyTextfeildView : UIView

@property (nonatomic, strong) UITextField *myTextField;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIView *botLine;


- (void)setFont:(UIFont *)textFont AndPlaceholderText:(NSString *)placeholderString ;

@end
