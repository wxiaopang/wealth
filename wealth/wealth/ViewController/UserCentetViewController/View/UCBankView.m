//
//  UCBankView.m
//  wealth
//
//  Created by wangyingjie on 16/4/19.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UCBankView.h"
#import "UCBankListCell.h"


@interface UCBankView ()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation UCBankView

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
    self.mainTableView = [[UITableView alloc] init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight - kNavigationBarHeight);
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
    return GET_CLIENT_MANAGER.userCenterManager.bankList.count;
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
    if (GET_CLIENT_MANAGER.userCenterManager.bankList.count > indexPath.row) {
        BankMessageModel *model = [GET_CLIENT_MANAGER.userCenterManager.bankList objectAtIndex:indexPath.row];
        cell.messageModel = model;
    }
    cell.upLine.hidden = (indexPath.row != 0);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.selectBankBlock) {
        self.selectBankBlock(indexPath.row);
    }
}





//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

@end
