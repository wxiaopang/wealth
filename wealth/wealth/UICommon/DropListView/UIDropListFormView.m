//
//  UIDropListFormView.m
//  wealth
//
//  Created by wangyingjie on 15/2/28.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UIDropListFormView.h"

@interface UIDropListFormView () <DropListViewDelegate> {
    UILabel *_leftLable;
    DropListView *_dropListView;
    UILabel *_rightLable;
    StringBlock theSelectedBlock;
}

@property (nonatomic, strong) UIView *theSuperView;

@end

@implementation UIDropListFormView

- (instancetype)initWithTheSuperView:(UIView *)theSuperView {
    self = [super init];
    if ( self ) {
        self.spaceX = 5.0f;
        self.theSuperView = theSuperView;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame theSuperView:(UIView *)theSuperView {
    self = [super initWithFrame:frame];
    if ( self ) {
        self.spaceX = 5.0f;
        self.theSuperView = theSuperView;
    }
    return self;
}

- (UILabel *)leftLable {
    if ( !_leftLable ) {
        _leftLable = [[UILabel alloc] init];
        _leftLable.backgroundColor = [UIColor clearColor];
        _leftLable.textAlignment = NSTextAlignmentRight;
        [self addSubview:_leftLable];
    }
    return _leftLable;
}

- (DropListView *)dropListView {
    if ( !_dropListView ) {
        _dropListView = [[DropListView alloc] initWithDelegate:self theSuperView:self.theSuperView isFullSuperWidth:NO dataArray:self.dataArray placeholders:self.placeholders];
        [self addSubview:_dropListView];
    }
    return _dropListView;
}

- (UILabel *)rightLable {
    if ( !_rightLable ) {
        _rightLable = [[UILabel alloc] init];
        _rightLable.backgroundColor = [UIColor clearColor];
        _rightLable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_rightLable];
    }
    return _rightLable;
}

- (void)layoutSubviews {
    _leftLable.frame = CGRectMake(0, 0, _leftLable.width, self.height);
    self.dropListView.frame = CGRectMake(_leftLable.right + _spaceX, 0,
                                      self.width - _leftLable.width - _rightLable.width - _spaceX*2, self.height);
    _rightLable.frame = CGRectMake(self.dropListView.right + _spaceX, 0, _rightLable.width, self.height);
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
    }
    _dropListView.dataArray = _dataArray;
}

#pragma mark -
#pragma mark -DropListViewDelegate
- (NSInteger)dropListView:(DropListView *)dropListView defaultShowSection:(NSInteger)section {
    if (self.placeholders && self.placeholders.count > 0) {
        return -1;
    }
    return 0;
}

-(void)dropListView:(DropListView *)dropListView didSelectedInSection:(NSInteger)section index:(NSInteger)index {
    if (theSelectedBlock) {
        theSelectedBlock ([[self.dataArray objectAtIndex:section] objectAtIndex:index]);
    }
}

- (void)didSelectedItemWithBlock:(StringBlock)selectedBlock {
    theSelectedBlock = [selectedBlock copy];
}

@end
