//
//  UIRefreshHeader.m
//  iqianjin
//
//  Created by JinShiChao on 15/11/18.
//  Copyright © 2015年 iqianjin. All rights reserved.
//

#import "UIRefreshHeader.h"

@interface UIRefreshHeader()
@property (nonatomic, strong) UIImageView *loadingImageView;//转动中的图片
@property (nonatomic, strong) UILabel *sheetLabel;          //提示文字
@property (nonatomic, strong) NSMutableArray *imageMArr;    //存放loading图片
@end

#define kImage  @"ic_lccp_shuaxin_bg"

@implementation UIRefreshHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 130/2;
    
    self.imageMArr = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 12; i++) {
        UIImage *im =[UIImage imageNamed:[NSString stringWithFormat:@"loading_%d",i]];
        [self.imageMArr addObject:im];
    }
    
    UIImage *image = [UIImage imageNamed:@"act_btn"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220/2, image.size.height)];
    bgImageView.image = SET_CONTENT_BACKGROUND_IMAGE(@"act_btn", 1, 20, 1, 20);
    [self addSubview:bgImageView];
    bgImageView.center = CGPointMake(ScreenWidth/2, self.height/2);
    
    self.loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20/2, 13/2, 46/2, 46/2)];
    self.loadingImageView.image = [UIImage imageNamed:@"act_right"];
    [bgImageView addSubview:self.loadingImageView];
    self.loadingImageView.center = CGPointMake(20/2 + 46/2/2, bgImageView.height/2);
    
    self.sheetLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.loadingImageView.right + 22/2, bgImageView.height/2 - 26/4, 20, 26/2)];
    self.sheetLabel.font = FONT_CN_NORMAL(26);
    self.sheetLabel.textColor = [UIColor get_3_Color];
    [bgImageView addSubview:self.sheetLabel];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
}

-(void)setsssCode {
    self.loadingImageView.animationImages = nil;
    if (self.refreshCode == 1) {
        self.loadingImageView.image = [UIImage imageNamed:@"act_right"];
        [self.sheetLabel setAdaptionWidthWithText:@"加载成功"];
    } else {
        self.sheetLabel.textColor = [UIColor get_3_Color];
        self.loadingImageView.image = [UIImage imageNamed:@"act_wrong"];
        [self.sheetLabel setAdaptionWidthWithText:@"加载失败"];
    }
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    if ([self.sheetLabel.text isEqualToString:@"加载成功"] || self.sheetLabel.text == nil || [self.sheetLabel.text isEqualToString:@"加载失败"]) {
        self.sheetLabel.textColor = [UIColor get_9_Color];
        self.loadingImageView.animationImages = nil;
        self.loadingImageView.image = [UIImage imageNamed:@"loading_1"];
        [self.sheetLabel setAdaptionWidthWithText:@"下拉刷新"];
    }
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    switch (state) {
        case MJRefreshStatePulling:
            [self.sheetLabel setAdaptionWidthWithText:@"松开刷新"];
            break;
        case MJRefreshStateRefreshing:
            [self.sheetLabel setAdaptionWidthWithText:@"加载中..."];
            self.loadingImageView.animationImages = self.imageMArr;
            [self startLoading];
            if (self.refreshCode != 999) {
                [self performSelector:@selector(setsssCode) withObject:nil afterDelay:0.5];
            }
            break;
        case MJRefreshStateNoMoreData:
            self.loadingImageView.animationImages = nil;
            [self.sheetLabel setAdaptionWidthWithText:@"加载成功"];
            self.loadingImageView.image = [UIImage imageNamed:@"act_right"];
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}

-(void)startLoading{
    self.loadingImageView.animationDuration = 0.5;
    [self.loadingImageView startAnimating];
}

-(void)stopLoading{
    [self.loadingImageView stopAnimating];
}


@end
