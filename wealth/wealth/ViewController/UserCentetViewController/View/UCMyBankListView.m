//
//  UCMyBankListView.m
//  wealth
//
//  Created by wangyingjie on 16/4/19.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UCMyBankListView.h"
#import "UCBankListCell.h"


@interface UCMyBankListView ()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation UCMyBankListView

- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


#pragma mark- SetupViews
- (void)setUpViews {
    self.mainTableView = [[UITableView alloc] init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.frame = CGRectMake(0,0, ScreenWidth, self.height);
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.showsVerticalScrollIndicator = FALSE;
    _mainTableView.showsHorizontalScrollIndicator = FALSE;
//    self.footView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, 0)];
//    [self.footView setBackgroundColor:[UIColor get_6_Color]];
//    [self.mainTableView setTableFooterView:self.footView];
//    self.mainTableView.tableFooterView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight*2);
    [self addSubview:self.mainTableView];
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return GET_CLIENT_MANAGER.userCenterManager.bankMessageList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [NSArray array];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    UCBankListCell *cell = (UCBankListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UCBankListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (GET_CLIENT_MANAGER.userCenterManager.bankMessageList.count > indexPath.row) {
        BankMessageModel *model = [GET_CLIENT_MANAGER.userCenterManager.bankMessageList objectAtIndex:indexPath.row];
        cell.messageModel = model;
    }
    cell.upLine.hidden = (indexPath.row != 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}





//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

@end
