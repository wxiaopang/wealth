//
//  ThreeLabelView.h
//  wealth
//
//  Created by wangyingjie on 16/3/22.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreeLabelView : UIView

@property (nonatomic, strong) UILabel *friLabel;
@property (nonatomic, strong) UILabel *secLabel;
@property (nonatomic, strong) UILabel *thrLabel;

- (CGFloat)setLabelFText:(NSString *)ftext
        AndFTextColor:(UIColor *)fcolor
         AndFTextFont:(UIFont *)ffont
             AndSText:(NSString *)stext
        AndSTextColor:(UIColor *)scolor
         AndSTextFont:(UIFont *)sfont
             AndTText:(NSString *)ttext
        AndTTextColor:(UIColor *)tcolor
         AndTTextFont:(UIFont *)tfont;

@end
