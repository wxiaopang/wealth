//
//  TabView.m
//  wealth
//
//  Created by wangyingjie on 15/2/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "TabView.h"

#define UnreadTag 2000 //未读提示标记的tag基础值

@implementation TabView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

#pragma mark -
#pragma mark - 创建子视图
- (void)initSubviews {
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
    lineLabel.backgroundColor = [UIColor getColorWithR209G209B209];
    [self addSubview:lineLabel];

    for (int i = 0; i < TabBarCount; i++) {
        //创建按钮
        UIButton *button        = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *NormalImage   = [NSString stringWithFormat:@"tab_normal_%d", i];
        NSString *SelectedImage = [NSString stringWithFormat:@"tab_selected_%d", i];
        [button setImage:[UIImage imageNamed:NormalImage] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:SelectedImage] forState:UIControlStateSelected];
        button.tag   = TAG + i;
        button.frame = CGRectMake((self.width/TabBarCount)*i, 0, self.width/TabBarCount, kTabBarHeight);
        [button addTarget:self action:@selector(tabBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];

        if (i == 0) {
            //启动时默认选中第一个
            button.selected = YES;
            self.lastButton = button;
        }
    }
}

#pragma mark -
#pragma mark - tabBar 点击事件
- (void)tabBarButtonAction:(UIButton *)button {
    //当前点击的按钮不是上次点击的
    if (self.lastButton != button) {
        
        if (kClientManagerUid <= 0 && button.tag - TAG == 1) {
            self.lastIndex           = self.lastButton.tag - TAG;
            self.selectedIndex = button.tag - TAG;
            if (self.tabViewClick) {
                self.tabViewClick();
            }
        }else{
            //取消上次按钮的选中效果
            self.lastButton.selected = NO;
            self.lastIndex           = self.lastButton.tag - TAG;
            //记录当前点击的按钮
            self.lastButton = button;
            button.selected = YES;
            
            //通过修改索引来切换tab控制器中的子控制器
            self.selectedIndex = button.tag - TAG;
            
            if (self.tabViewClick) {
                self.tabViewClick();
            }
        }
    }
}

- (void)setMessageCount:(NSInteger)messageCount {
    [UIApplication sharedApplication].applicationIconBadgeNumber = messageCount;
    UIView *messageTab = [self viewWithTag:(TAG + 2)];
    if (ScreenWidth > 320.0f) {
        messageTab.badgeViewFrame = CGRectMake(messageTab.width - 45, 5, 30, 20);
    }
    else {
        messageTab.badgeViewFrame = CGRectMake(messageTab.width - 40, 5, 30, 20);
    }
    messageTab.badgeView.text                = (messageCount > 99 ? @"99+" : [@(messageCount)stringValue]);
    messageTab.badgeView.font                = [UIFont systemFontOfSize:11.0f];
    messageTab.badgeView.badgeColor          = [UIColor messageBubbleColor];
    messageTab.badgeView.layer.cornerRadius  = 15.0f;
    messageTab.badgeView.layer.masksToBounds = YES;
    messageTab.badgeView.hidden              = (messageCount > 0) ? NO : YES;
    [messageTab setNeedsDisplay];
}

- (NSInteger)messageCount {
    UIView *messageTab = [self viewWithTag:(TAG + 2)];
    return [[messageTab.badgeView.text findNumFromStr] integerValue];
}

@end
