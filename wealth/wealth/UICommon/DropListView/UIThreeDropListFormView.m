//
//  UIThreeDropListFormView.m
//  wealth
//
//  Created by yangzhaofeng on 15/3/3.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UIThreeDropListFormView.h"

@interface UIThreeDropListFormView ()

@property (nonatomic, strong) NSMutableArray *leftPlaceholders;
@property (nonatomic, strong) NSMutableArray *middlePlaceholders;
@property (nonatomic, strong) NSMutableArray *rightPlaceholders;
@property (nonatomic, copy) StringBlock leftSelectedBlock;
@property (nonatomic, copy) StringBlock middleSelectedBlock;
@property (nonatomic, copy) StringBlock rightSelectedBlock;
@property (nonatomic, strong) UIView *theSuperView;

@end

@implementation UIThreeDropListFormView

- (instancetype)initWithTheSuperView:(UIView *)theSuperView leftDataArray:(NSArray *)leftDataArray leftPlaceholders:(NSArray *)leftPlaceholders middleDataArray:(NSArray *)middleDataArray middlePlaceholders:(NSArray *)middlePlaceholders rightDataArray:(NSArray *)rightDataArray rightPlaceholders:(NSArray *)rightPlaceholders {
    self = [super init];
    if ( self ) {
        self.spaceX = 5.0f;
        self.leftDataArray = [NSMutableArray arrayWithArray:leftDataArray];
        self.leftPlaceholders = [NSMutableArray arrayWithArray:leftPlaceholders];
        self.middleDataArray = [NSMutableArray arrayWithArray:middleDataArray];
        self.middlePlaceholders = [NSMutableArray arrayWithArray:middlePlaceholders];
        self.rightDataArray = [NSMutableArray arrayWithArray:rightDataArray];
        self.rightPlaceholders = [NSMutableArray arrayWithArray:rightPlaceholders];
        self.theSuperView = theSuperView;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame theSuperView:(UIView *)theSuperView leftDataArray:(NSArray *)leftDataArray leftPlaceholders:(NSArray *)leftPlaceholders middleDataArray:(NSArray *)middleDataArray middlePlaceholders:(NSArray *)middlePlaceholders rightDataArray:(NSArray *)rightDataArray rightPlaceholders:(NSArray *)rightPlaceholders {
    self = [super initWithFrame:frame];
    if ( self ) {
        self.spaceX = 5.0f;
        self.leftDataArray = [NSMutableArray arrayWithArray:leftDataArray];
        self.leftPlaceholders = [NSMutableArray arrayWithArray:leftPlaceholders];
        self.middleDataArray = [NSMutableArray arrayWithArray:middleDataArray];
        self.middlePlaceholders = [NSMutableArray arrayWithArray:middlePlaceholders];
        self.rightDataArray = [NSMutableArray arrayWithArray:rightDataArray];
        self.rightPlaceholders = [NSMutableArray arrayWithArray:rightPlaceholders];
        self.theSuperView = theSuperView;
    }
    return self;
}

- (void)dealloc {
    self.leftDropListView = nil;
    self.rightDropListView = nil;
    self.leftDataArray = nil;
    self.leftPlaceholders = nil;
    self.middleDataArray = nil;
    self.middlePlaceholders = nil;
    self.rightDataArray = nil;
    self.rightPlaceholders = nil;
    self.theSuperView = nil;
}

- (UIDropListFormView *)leftDropListView {
    if ( !_leftDropListView) {
        _leftDropListView = [[UIDropListFormView alloc] initWithTheSuperView:self.theSuperView];
        _leftDropListView.dataArray = self.leftDataArray;
        _leftDropListView.placeholders = self.leftPlaceholders;
        [self addSubview:_leftDropListView];
        @weakify(self);
        [_leftDropListView didSelectedItemWithBlock:^(NSString *string) {
            @strongify(self);
            if (self.leftSelectedBlock) {
                self.leftSelectedBlock (string);
            }
        }];
    }
    return _leftDropListView;
}

- (UIDropListFormView *)middleDropListView {
    if ( !_middleDropListView) {
        _middleDropListView = [[UIDropListFormView alloc] initWithTheSuperView:self.theSuperView];
        _middleDropListView.dataArray = self.middleDataArray;
        _middleDropListView.placeholders = self.middlePlaceholders;
        [self addSubview:_middleDropListView];
        @weakify(self);
        [_middleDropListView didSelectedItemWithBlock:^(NSString *string) {
            @strongify(self);
            if (self.middleSelectedBlock) {
                self.middleSelectedBlock (string);
            }
        }];
    }
    return _middleDropListView;
}

- (UIDropListFormView *)rightDropListView {
    if ( !_rightDropListView) {
        _rightDropListView = [[UIDropListFormView alloc] initWithTheSuperView:self.theSuperView];
        _rightDropListView.dataArray = self.rightDataArray;
        _rightDropListView.placeholders = self.rightPlaceholders;
        [self addSubview:_rightDropListView];
        @weakify(self);
        [_rightDropListView didSelectedItemWithBlock:^(NSString *string) {
            @strongify(self);
            if (self.rightSelectedBlock) {
                self.rightSelectedBlock (string);
            }
        }];
    }
    return _rightDropListView;
}

- (void)setLeftDataArray:(NSMutableArray *)leftDataArray {
    if (_leftDataArray != leftDataArray) {
        _leftDataArray = leftDataArray;
    }
    _leftDropListView.dataArray = _leftDataArray;
}

- (void)setMiddleDataArray:(NSMutableArray *)middleDataArray {
    if (_middleDataArray != middleDataArray) {
        _middleDataArray = middleDataArray;
    }
    _middleDropListView.dataArray = _middleDataArray;
}

- (void)setRightDataArray:(NSMutableArray *)rightDataArray {
    if (_rightDataArray != rightDataArray) {
        _rightDataArray = rightDataArray;
    }
    _rightDropListView.dataArray = _rightDataArray;
}

- (void)layoutSubviews {
    self.leftDropListView.frame = CGRectMake(0, 0, 100, self.height);
    [self.leftDropListView setNeedsDisplay];
    self.middleDropListView.frame = CGRectMake(self.leftDropListView.right + _spaceX, 0, 100, self.height);
    [self.middleDropListView setNeedsDisplay];
    self.rightDropListView.frame = CGRectMake(self.middleDropListView.right + _spaceX, 0, self.width - self.leftDropListView.width - self.middleDropListView.width - _spaceX * 2, self.height);
    [self.rightDropListView setNeedsDisplay];
}

- (void)didSelectedLeftItemWithLeftBlock:(StringBlock)leftBlock middleBlock:(StringBlock)middleBlock rightBlock:(StringBlock)rightBlock {
    self.leftSelectedBlock = leftBlock;
    self.middleSelectedBlock = middleBlock;
    self.rightSelectedBlock = rightBlock;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
