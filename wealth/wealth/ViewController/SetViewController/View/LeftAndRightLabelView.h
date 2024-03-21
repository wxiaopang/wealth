//
//  LeftAndRightLabelView.h
//  wealth
//
//  Created by wangyingjie on 16/3/23.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftAndRightLabelView : UIView

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *RightLabel;
@property (nonatomic, strong) UILabel *lineView;


- (void)setleftText:(NSString *)lText AndRightText:(NSString *)rText;

@end
