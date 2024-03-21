//
//  UIBlankView.m
//  wealth
//
//  Created by wangyingjie on 16/4/5.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UIBlankView.h"

@implementation UIBlankView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        //图片
        _blankView=[[UIImageView alloc]initWithFrame:CGRectMake((self.width - 154.0/2.0f)/2.0f, self.height/2.0f - 170.0f/1.50f, 154/2, 170/2)];
        _blankView.image=[UIImage imageNamed:@"default_icon_empty"];
        [self addSubview:_blankView];
        
        GreateLabelf(self.blankText, [UIColor get_2_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentCenter, self);
        [_blankText setAdaptionWidthWithText:@"对不起,暂无内容"];
        _blankText.frame = CGRectMake((self.width - _blankText.width)/2.0f, _blankView.bottom + 10.0f, _blankText.width, 16.0f);
        
        
    }
    return self;
}


@end
