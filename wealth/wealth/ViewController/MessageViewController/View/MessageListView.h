//
//  MessageListView.h
//  wealth
//
//  Created by wangyingjie on 16/5/9.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageListTableViewCell.h"

@interface MessageListView : UIView<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UILabel *messageLabel;


@property (nonatomic, copy) IntegerBlock messageCellClick;
@property (nonatomic, copy) IntegerBlock getListClick;

@property (nonatomic, assign) BOOL isgetData;

@end
