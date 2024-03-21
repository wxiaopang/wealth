//
//  UIMsgDialogView.m
//  AiShiDai
//
//  Created by wangyingjie on 15/4/29.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UIMsgDialogView.h"

@interface UIMsgDialogView ()

@property (nonatomic, copy) NSString   *text;            /**< 提示的文案 */
@property (nonatomic, strong) UIView   *superView;     /**< 提示视图的父视图 */
@property (nonatomic, strong) UIView   * bottomView;    /**< 提示视图底部连接的视图 */
@property (nonatomic, assign) CGFloat    space;         /**< 提示视图底部与连接的视图的间隔 */

@end

@implementation UIMsgDialogView

- (id)initWithText:(NSString *)text withSuperView:(UIView *)superView
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        self.text = text;
        self.superView = superView;
        
        [self initSubviews];
        
        /*/
        //背景视图
        GreateUIView(self.bgView, [UIColor getColorWithR255G246B219], self);
        
        //图标
        UIImageView * icon = nil;
        GreateImageView(icon, @"Remind_icon", @"", self.bgView);
        icon.frame = CGRectMake(15, 0, 15, 15);
        
        //设置文本label
        CGFloat width  = superView.width;
        CGFloat height = 0;
        CGFloat lableWidth = width - 16 - (icon.right + 8);
        
        UIFont * font = [UIFont systemFontOfSize:15.0f];
        CGSize size = [text boundingRectWithSize:CGSizeMake(lableWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size;
        UILabel * titleLable = nil;
        GreateLabel(titleLable, [UIColor getColorWithR230G137B34], 15, NSTextAlignmentLeft, self.bgView);
        titleLable.frame = CGRectMake(icon.right+8, 8, lableWidth, size.height);
        titleLable.text = text;
        [self.bgView addSubview:titleLable];
        
        height = (titleLable.height + 16);
        height = height >= 44 ? height : 44;
        self.frame = CGRectMake(0, kNavigationBarHeight, width, height);
        self.bgView.frame = CGRectMake(0, -height, width, height);
        
        icon.top = (self.height-icon.height)/2;
        titleLable.top = (self.height-titleLable.height)/2;
        
        [superView addSubview:self];//*/
    }
    return self;
}

- (id)initWithText:(NSString *)text withSuperView:(UIView *)superView bottomView:(UIView *)bottomView space:(CGFloat)space
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        self.text = text;
        self.superView = superView;
        self.bottomView = bottomView;
        self.space = space;
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    //背景视图
    GreateUIView(self.bgView, [UIColor whiteColor], self);
    
    //图标
    UIImageView * icon = nil;
    GreateImageView(icon, @"remind_icon", @"", self.bgView);
    icon.frame = CGRectMake(15, 0, 15, 15);
    
    //设置文本label
    CGFloat width  = self.superView.width;
    CGFloat height = 0;
    CGFloat lableWidth = width - 16 - (icon.right + 8);
    
    UIFont * font = [UIFont systemFontOfSize:15.0f];
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(lableWidth, 100)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName:font }
                                          context:nil].size;
    UILabel * titleLable = nil;
    GreateLabel(titleLable, [UIColor clearColor], 15, NSTextAlignmentLeft, self.bgView);
    titleLable.frame = CGRectMake(icon.right+8, 8, lableWidth, size.height);
    titleLable.text = self.text;
//    titleLable.textColor = [UIColor messageBubbleColor];
    [self.bgView addSubview:titleLable];

    height = (titleLable.height + 16);
    height = height >= 44 ? height : 44;
    self.frame = CGRectMake(0, kNavigationBarHeight, width, height);
    self.bgView.frame = CGRectMake(0, -height, width, height);
    
    icon.top = (self.height-icon.height)/2;
    titleLable.top = (self.height-titleLable.height)/2;
    
    [self.superView addSubview:self];
}

- (void)show {
    //bottomView需要移动的距离
    static BOOL isAnimations = NO;
    if ( !isAnimations ) {
        isAnimations = YES;
        CGFloat moveSize = 0;
        CGFloat bottomViewTop = 0;
        if (self.bottomView) {
            moveSize = self.height + self.space;
            bottomViewTop = self.bottomView.top;
        }
        
        [UIView animateWithDuration:0.35 animations:^{
            //视图向下移动
            self.bgView.top = 0;
            if (self.bottomView) {
                self.bottomView.top = bottomViewTop + moveSize;
            }
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.35 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                //视图停留2秒 再向上收起
                self.bgView.bottom = 0;
                if (self.bottomView) {
                    self.bottomView.top = bottomViewTop;
                }
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                isAnimations = NO;
            }];
        }];
    }
}

@end
