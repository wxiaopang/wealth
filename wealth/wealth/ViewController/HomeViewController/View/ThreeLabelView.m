//
//  ThreeLabelView.m
//  wealth
//
//  Created by wangyingjie on 16/3/22.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "ThreeLabelView.h"

@interface ThreeLabelView ()





@end

@implementation ThreeLabelView

- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUpViews];
    }
    return self;
}


#pragma mark- SetupViews
- (void)setUpViews {
    GreateEmptyLabel(self.friLabel, [UIColor clearColor], self);
    GreateEmptyLabel(self.secLabel, [UIColor clearColor], self);
    GreateEmptyLabel(self.thrLabel, [UIColor clearColor], self);
}

- (CGFloat)setLabelFText:(NSString *)ftext
        AndFTextColor:(UIColor *)fcolor
         AndFTextFont:(UIFont *)ffont
             AndSText:(NSString *)stext
        AndSTextColor:(UIColor *)scolor
         AndSTextFont:(UIFont *)sfont
             AndTText:(NSString *)ttext
        AndTTextColor:(UIColor *)tcolor
         AndTTextFont:(UIFont *)tfont{
    CGSize size1 = CGSizeZero;
    if (ftext && ftext.length > 0) {
        _friLabel.textColor = fcolor;
        _friLabel.font = ffont;
        [_friLabel setAdaptionWidthWithText:ftext];
        size1 = [ftext sizeWithAttributes:@{ NSFontAttributeName: ffont }];
        _friLabel.frame = CGRectMake(0, self.height-size1.height, _friLabel.width, size1.height);
    }
    CGSize size2 = CGSizeZero;
    if (stext && stext.length > 0) {
        _secLabel.textColor = scolor;
        _secLabel.font = sfont;
        [_secLabel setAdaptionWidthWithText:stext];
        size2 = [stext sizeWithAttributes:@{ NSFontAttributeName: sfont }];
        _secLabel.frame = CGRectMake(_friLabel.right, self.height-size2.height, _secLabel.width, size2.height);
    }
    CGSize size3 = CGSizeZero;
    if (ttext && ttext.length > 0) {
        _thrLabel.textColor = tcolor;
        _thrLabel.font = tfont;
        [_thrLabel setAdaptionWidthWithText:ttext];
        size3 = [ttext sizeWithAttributes:@{ NSFontAttributeName: tfont }];
        _thrLabel.frame = CGRectMake(_secLabel.right, self.height-size3.height, _thrLabel.width, size3.height);
    }
    
    
    CGFloat maxHeight = kGetMax(size1.height, size2.height, size3.height);
    
    
    
    return maxHeight;
}



//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

@end
