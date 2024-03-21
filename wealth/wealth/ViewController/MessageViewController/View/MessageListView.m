//
//  MessageListView.m
//  wealth
//
//  Created by wangyingjie on 16/5/9.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "MessageListView.h"

@interface MessageListView ()




@end

@implementation MessageListView

- (void)dealloc {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}


#pragma mark- SetupViews
- (void)setUpViews {
    self.mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth,ScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    [self.mainTableView setBackgroundColor:[UIColor clearColor]];
    [self.mainTableView setDataSource:self];
    [self.mainTableView setDelegate:self];
    _mainTableView.mj_header = [UIRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getMessageList)];
    _mainTableView.showsVerticalScrollIndicator = FALSE;
    _mainTableView.showsHorizontalScrollIndicator = FALSE;
    [self.mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:self.mainTableView];
    
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    footView.frame = CGRectMake(0, 0, ScreenWidth, 0.0f);
    GreateLabelf(self.messageLabel, CREATECOLOR(0, 190, 125, 1), [UIFont get_B26_CN_NOR_Font], NSTextAlignmentCenter, footView);
    [self.messageLabel setText:@"加载更多"];
    self.messageLabel.frame = CGRectMake(0.0f, 13.3f, ScreenWidth, 15.0f);
    _mainTableView.tableFooterView = footView;
    _messageLabel.hidden = YES;
}


//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

- (void)getMessageList{
    if (self.getListClick) {
        self.getListClick(1);
    }
}


- (void)setIsgetData:(BOOL)isgetData{
    _isgetData = isgetData;
    if (_isgetData) {
        if (GET_CLIENT_MANAGER.messageManager.messageList.count > 0) {
            _messageLabel.hidden = NO;
        }else{
            _messageLabel.hidden = YES;
        }
    }
}

#pragma mark UITableViewDataSource & UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 20.0f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *footView = [[UIView alloc] init];
//    footView.backgroundColor = [UIColor redColor];
//    return footView;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return GET_CLIENT_MANAGER.messageManager.messageList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 137.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    MessageListTableViewCell *cell = (MessageListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MessageListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row < GET_CLIENT_MANAGER.messageManager.messageList.count) {
        cell.listmodel = [GET_CLIENT_MANAGER.messageManager.messageList objectAtIndex:indexPath.row];
    }
    
//    if (GET_CLIENT_MANAGER.productionManager.productionList.count > indexPath.row) {
//        cell.dataModel = [GET_CLIENT_MANAGER.productionManager.productionList objectAtIndex:indexPath.row];
//    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MessageListModel *model = [GET_CLIENT_MANAGER.messageManager.messageList objectAtIndex:indexPath.row];
    if (self.messageCellClick) {
        self.messageCellClick((NSUInteger)model.msgId);
    }
//    [self gotoBuyViewWtihId:indexPath.row];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + 30  && scrollView.contentOffset.y>0){
        if (self.getListClick) {
            self.getListClick(2);
        }
    }
}


@end
