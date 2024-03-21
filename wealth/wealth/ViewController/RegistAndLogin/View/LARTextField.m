//
//  LARTextField.m
//  iqianjin
//
//  Created by wangyingjie on 15/12/24.
//  Copyright © 2015年 iqianjin. All rights reserved.
//

#import "LARTextField.h"

@implementation LARTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)caretRectForPosition:(UITextPosition *)position{
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.size.height = self.font.lineHeight + 10;
    originalRect.size.width = 1;
    return originalRect;
}

//控制placeHolder的位置，居中
-(CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x, (bounds.origin.y + bounds.size.height - 18) / 2, bounds.size.width, bounds.size.height);//更好理解些
}
//关闭复制粘贴等功能
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(cut:)){
        return NO;
    }else if(action == @selector(copy:)){
        return NO;
    }else if(action == @selector(paste:)){
        return NO;
    }else if(action == @selector(select:)){
        return NO;
    }else if(action == @selector(selectAll:)){
        return NO;
    }else{
        return NO;
    }
}



@end
