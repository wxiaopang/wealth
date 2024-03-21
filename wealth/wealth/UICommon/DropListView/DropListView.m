//
//  DropListView.m
//  XSDropDownListView
//
//  Created by yangzhaofeng on 15/2/28.
//  Copyright (c) 2015年 yangzhaofeng. All rights reserved.
//

#import "DropListView.h"

#define   kAnimationSec               0.2f
#define   kCellHeight                 40.0f
#define   kSectionButtonTag           2000
#define   kSectionImageViewTag        3000
#define   kSectionWidth(count)        ((1.0 * (self.bounds.size.width)) / (count))
#define   kMaxVisableCount            5

@interface DropListView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *backCoverView;
@property (nonatomic, strong) UITableView *extendTableView;
@property (nonatomic, strong) NSMutableArray *selectedIndexs;  //已被选中的每一个section的item的位置,角标代表section,元素代表row
@property (nonatomic, assign) NSInteger currentExtendSection;  //当前展开的section
@property (nonatomic, strong) NSMutableArray *placeholders;    //每一个section的默认文案

@end

@implementation DropListView

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate theSuperView:(UIView *)theSuperView isFullSuperWidth:(BOOL)isFullSuperWidth dataArray:(NSArray *)dataArray placeholders:(NSArray *)placeholders {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.selectedIndexs = [NSMutableArray array];
        self.currentExtendSection = -1;//初始化-1表示都没有展开
        self.dropListDelegate = delegate;
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
        self.placeholders = [NSMutableArray arrayWithArray:placeholders];
        self.backgroundColor = [UIColor whiteColor];
        self.isFullSuperWidth = isFullSuperWidth;
        self.theSuperView = theSuperView;
        [self setUpViews];
    }
    return self;
}

//init(不设置frame) 和 setFrame配合使用
- (id)initWithDelegate:(id)delegate theSuperView:(UIView *)theSuperView isFullSuperWidth:(BOOL)isFullSuperWidth dataArray:(NSArray *)dataArray placeholders:(NSArray *)placeholders {
    self = [super init];
    if (self) {
        // Initialization code
        self.selectedIndexs = [NSMutableArray array];
        self.currentExtendSection = -1;//初始化-1表示都没有展开
        self.dropListDelegate = delegate;
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
        self.placeholders = [NSMutableArray arrayWithArray:placeholders];
        self.backgroundColor = [UIColor whiteColor];
        self.isFullSuperWidth = isFullSuperWidth;
        self.theSuperView = theSuperView;
        [self setUpViews];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setupViewsWithFrame:frame];
}

- (void)dealloc {
    self.backCoverView = nil;
    self.extendTableView = nil;
    self.theSuperView = nil;
    self.dataArray = nil;
    self.placeholders = nil;
}

- (void)setUpViews {
    NSInteger sectionCount = self.dataArray.count;
    [self.selectedIndexs removeAllObjects];
    if (sectionCount > 0) {
        for (NSInteger i = 0; i < sectionCount; i ++) {
            [self.selectedIndexs addObject:@([self.dropListDelegate dropListView:self defaultShowSection:i])];//初始化每一个section被选中的item的位置
            UIButton *displayBtn = (UIButton *)[self viewWithTag:kSectionButtonTag + i];
            if (!displayBtn) {
                displayBtn = [[UIButton alloc] initWithFrame:CGRectMake(kSectionWidth(sectionCount) * i, 0, kSectionWidth(sectionCount), self.bounds.size.height)];
                [displayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                displayBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
                displayBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
                displayBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                displayBtn.contentEdgeInsets = UIEdgeInsetsMake(0,14, 0, 0);
                displayBtn.tag = kSectionButtonTag + i;
                [displayBtn addTarget:self action:@selector(displayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:displayBtn];
            }
            
            //设置默认显示的内容
            NSString *displayBtnTitle = @"--";
            if (self.placeholders && self.placeholders.count > 0) {
                
                NSString *placeholder = [self.placeholders objectAtIndex:i];
                if (placeholder && placeholder.length > 0) {
                    displayBtnTitle = placeholder;
                }
            }
            else {
                if (self.dataArray && self.dataArray.count > 0) {
                    NSArray *array = [self.dataArray objectAtIndex:i];
                    if (array && array.count > 0) {
                        NSInteger defaultRow = [self.dropListDelegate dropListView:self defaultShowSection:i];
                        if (defaultRow >= 0) {
                            displayBtnTitle = [array objectAtIndex:defaultRow];
                        }
                    }
                }
            }
            [displayBtn setTitle:displayBtnTitle forState:UIControlStateNormal];
            
            //会反转的小箭头
            UIImageView *dropDownIV = (UIImageView *)[self viewWithTag:kSectionImageViewTag + i];
            if (!dropDownIV) {
                dropDownIV = [[UIImageView alloc] initWithFrame:CGRectMake(kSectionWidth(sectionCount) * i + (kSectionWidth(sectionCount) - 12 - 10), (self.bounds.size.height - 12) / 2, 12, 12)];
                dropDownIV.tag = kSectionImageViewTag + i;
                //            dropDownIV.image = [UIImage imageNamed:@"down_dark"];
                [self addSubview:dropDownIV];
            }
        }
    }
}

//补充设置内部控件的frame
- (void)setupViewsWithFrame:(CGRect)frame {
    NSInteger sectionCount = self.dataArray.count;
    if (sectionCount > 0) {
        for (NSInteger i = 0; i < sectionCount; i ++) {
            UIButton *displayBtn = (UIButton *)[self viewWithTag:kSectionButtonTag + i];
            displayBtn.frame = CGRectMake(kSectionWidth(sectionCount) * i, 0, kSectionWidth(sectionCount), frame.size.height);
            //会反转的小箭头
            UIImageView *dropDownIV = (UIImageView *)[self viewWithTag:kSectionImageViewTag + i];
            dropDownIV.frame = CGRectMake(kSectionWidth(sectionCount) * i + (kSectionWidth(sectionCount) - 12 - 10), (frame.size.height - 12) / 2, 12, 12);
        }
    }
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
        [self setUpViews];
    }
}

//给button赋值
- (void)setTitle:(NSString *)title inSection:(NSInteger)section {
    UIButton *btn = (UIButton *)[self viewWithTag:kSectionButtonTag +section];
    [btn setTitle:title forState:UIControlStateNormal];
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowsCount = 0;
    if (self.dataArray && self.dataArray.count > 0) {
        rowsCount = [[self.dataArray objectAtIndex:self.currentExtendSection] count];
    }
    return rowsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *itemCellIdentifier = @"itemCellIdentifier";
    UITableViewCell *itemCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
    if (!itemCell) {
        itemCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];
    }
    itemCell.selectionStyle = UITableViewCellSelectionStyleGray;
    itemCell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    itemCell.accessoryType = UITableViewCellAccessoryNone;
    if (self.selectedIndexs && self.selectedIndexs.count > 0) {
        if (indexPath.row == [[self.selectedIndexs objectAtIndex:self.currentExtendSection] integerValue]) {
            itemCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    NSString *cellTitle = @"--";
    if (self.dataArray && self.dataArray.count > 0) {
        NSArray *array = [self.dataArray objectAtIndex:self.currentExtendSection];
        if (array && array.count > 0) {
            cellTitle = [array objectAtIndex:indexPath.row];
        }
    }
    itemCell.textLabel.text = cellTitle;
    return itemCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.dropListDelegate && [self.dropListDelegate respondsToSelector:@selector(dropListView:didSelectedInSection:index:)]) {
        NSString *selectedTitle = @"--";
        if (self.dataArray && self.dataArray.count > 0) {
            NSArray *array = [self.dataArray objectAtIndex:self.currentExtendSection];
            if (array && array.count > 0) {
                selectedTitle = [array objectAtIndex:indexPath.row];
            }
        }
        UIButton *displayBtn = (UIButton *)[self viewWithTag:kSectionButtonTag + self.currentExtendSection];
        [displayBtn setTitle:selectedTitle forState:UIControlStateNormal];
        [self.dropListDelegate dropListView:self didSelectedInSection:self.currentExtendSection index:indexPath.row];
    }
    [self.selectedIndexs replaceObjectAtIndex:self.currentExtendSection withObject:@(indexPath.row)];
    [self foldAction];
}

#pragma mark -
#pragma mark -buttonAction
- (void)displayBtnAction:(UIButton *)displayBtn {
    NSInteger section = displayBtn.tag - kSectionButtonTag;
    UIImageView *dropDownIV = (UIImageView *)[self viewWithTag:kSectionImageViewTag + self.currentExtendSection];
    if (dropDownIV) {
        [UIView animateWithDuration:kAnimationSec animations:^{
            dropDownIV.transform = CGAffineTransformRotate(dropDownIV.transform, DEGREES_TO_RADIANS(180));
        }];
    }
    if (self.currentExtendSection == section) {
        [self hideListView];
    }
    else {
        self.currentExtendSection = section;
        dropDownIV = (UIImageView *)[self viewWithTag:kSectionImageViewTag + self.currentExtendSection];
        if (dropDownIV) {
            [UIView animateWithDuration:kAnimationSec animations:^{
                dropDownIV.transform = CGAffineTransformRotate(dropDownIV.transform, DEGREES_TO_RADIANS(180));
            }];
        }
        [self extendLisView];
    }
}

- (void)foldAction {
    UIImageView *dropDownIV = (UIImageView *)[self viewWithTag:kSectionImageViewTag + self.currentExtendSection];
    if (dropDownIV) {
        [UIView animateWithDuration:kAnimationSec animations:^{
            dropDownIV.transform = CGAffineTransformRotate(dropDownIV.transform, DEGREES_TO_RADIANS(180));
        }];
    }
    [self hideListView];
}

#pragma mark -
#pragma mark -hide&&extend
//展开list
- (void)extendLisView {
    NSInteger sectionCount = self.dataArray.count;
    NSInteger currentRowCount = 0;
    if (sectionCount > 0) {
        currentRowCount = [[self.dataArray objectAtIndex:self.currentExtendSection] count];
    }
    CGRect superFrame = [self convertRect:self.bounds toView:self.theSuperView];
    //如果没有那就创建一下
    if (!self.extendTableView) {
        self.backCoverView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backCoverView.backgroundColor = [UIColor clearColor];
        self.backCoverView.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foldAction)];
        [self.backCoverView addGestureRecognizer:tap];
        
        self.extendTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.extendTableView.dataSource = self;
        self.extendTableView.delegate = self;
        self.extendTableView.showsHorizontalScrollIndicator = NO;
        self.extendTableView.showsVerticalScrollIndicator = NO;
        self.extendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    //设置展开的table和背景的frame
    self.backCoverView.frame = self.theSuperView.bounds;
    self.backCoverView.hidden = NO;
    
    self.extendTableView.frame = CGRectMake((self.isFullSuperWidth ? 0 : superFrame.origin.x + kSectionWidth(sectionCount) * self.currentExtendSection), superFrame.origin.y + superFrame.size.height, (self.isFullSuperWidth ? self.theSuperView.bounds.size.width : kSectionWidth(sectionCount)), 0);
    [self.theSuperView addSubview:self.backCoverView];
    [self.theSuperView addSubview:self.extendTableView];
    //控制是否显示弹性
    if (currentRowCount > kMaxVisableCount) {
        self.extendTableView.bounces = YES;
    }
    else {
        self.extendTableView.bounces = NO;
    }
    
    [self.extendTableView reloadData];
    
    [UIView animateWithDuration:kAnimationSec animations:^{
        CGRect tableViewFrame = self.extendTableView.frame;
        tableViewFrame.size.height = ((currentRowCount > kMaxVisableCount) ? kCellHeight * kMaxVisableCount : kCellHeight * currentRowCount);
        self.extendTableView.frame = tableViewFrame;
    } completion:^(BOOL finished) {

    }];
}

//收起list
- (void)hideListView {
    self.backCoverView.hidden = YES;
    if (self.currentExtendSection != -1) {
        [UIView animateWithDuration:kAnimationSec animations:^{
            CGRect tableViewFrame = self.extendTableView.frame;
            tableViewFrame.size.height = 0;
            self.extendTableView.frame = tableViewFrame;
        } completion:^(BOOL finished) {
            self.currentExtendSection = -1;
            [self.backCoverView removeFromSuperview];
            [self.extendTableView removeFromSuperview];
        }];
    }
}

@end


