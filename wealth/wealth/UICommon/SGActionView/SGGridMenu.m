//
//  SGGridMenu.m
//  SGActionView
//
//  Created by wangyingjie on 15/2/10.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "SGGridMenu.h"
#import <QuartzCore/QuartzCore.h>

#define kMAX_CONTENT_SCROLLVIEW_HEIGHT   400
#define kMAX_MENU_ROW_COUNT              4

@interface SGGridItem : UIButton
@property (nonatomic, weak) SGGridMenu *menu;
@end

@implementation SGGridItem

- (id)initWithTitle:(NSString *)title image:(UIImage *)image
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.clipsToBounds = NO;
        
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:BaseMenuTextColor(self.menu.style) forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];

//        self.titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
//        self.titleLabel.layer.borderWidth = SINGLE_LINE_WIDTH;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;

    CGRect imageRect = CGRectMake((width - self.imageView.image.size.width)/2,
                                  (height - self.imageView.image.size.height - self.titleLabel.font.pointSize - 14)/2,
                                  self.imageView.image.size.width,
                                  self.imageView.image.size.height);
    self.imageView.frame = imageRect;
    
    CGFloat labelHeight = self.titleLabel.font.pointSize + 2;
    CGRect labelRect = CGRectMake(0, imageRect.origin.y + imageRect.size.height + 7,
                                  width, labelHeight);
    self.titleLabel.frame = labelRect;
}

@end


@interface SGGridMenu ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) SGButton *cancelButton;
@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, strong) NSArray *itemImages;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) void (^actionHandle)(NSInteger);
@end

@implementation SGGridMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BaseMenuBackgroundColor(self.style);

        _itemTitles = [NSArray array];
        _itemImages = [NSArray array];
        _items = [NSArray array];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = BaseMenuTextColor(self.style);
        [self addSubview:_titleLabel];
        
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _contentScrollView.contentSize = _contentScrollView.bounds.size;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentScrollView];

        _lineLabel = [[UILabel alloc] initWithFrame:CGRectZero];//getColorWithR211G218B226
        _lineLabel.backgroundColor =  [UIColor getColorWithR211G218B226];
        [self addSubview:_lineLabel];

        _cancelButton = [SGButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.clipsToBounds = YES;
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [_cancelButton setTitleColor:[UIColor formLeftTitleNormalColor] forState:UIControlStateNormal]; // BaseMenuTextColor(self.style)
        [_cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(self.width, 44)] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor navigateBarTitleColor] size:CGSizeMake(self.width, 44)] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self addSubview:_cancelButton];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles images:(NSArray *)images
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        NSInteger count = MIN(itemTitles.count, images.count);
        _titleLabel.text = title;
        _itemTitles = [itemTitles subarrayWithRange:NSMakeRange(0, count)];
        _itemImages = [images subarrayWithRange:NSMakeRange(0, count)];
        [self setupWithItemTitles:_itemTitles images:_itemImages];
    }
    return self;
}

- (void)setupWithItemTitles:(NSArray *)titles images:(NSArray *)images
{
    NSMutableArray *items = [NSMutableArray array];
    for (int i=0; i<titles.count; i++) {
        SGGridItem *item = [[SGGridItem alloc] initWithTitle:titles[i] image:images[i]];
//        item.layer.borderColor = [UIColor blackColor].CGColor;
//        item.layer.borderWidth = SINGLE_LINE_WIDTH;
        item.menu = self;
        item.tag = i;
        [item addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [items addObject:item];
        [_contentScrollView addSubview:item];
    }
    _items = [NSArray arrayWithArray:items];
}

- (void)setStyle:(SGActionViewStyle)style {
    _style = style;

    self.backgroundColor = BaseMenuBackgroundColor(style);
    self.titleLabel.textColor = BaseMenuTextColor(style);
    [self.cancelButton setTitleColor:[UIColor formLeftTitleEditingColor] forState:UIControlStateNormal]; // BaseMenuActionTextColor(style)
    for (SGGridItem *item in self.items) {
        [item setTitleColor:BaseMenuActionTextColor(style) forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if ( _titleLabel.text ) {
        self.titleLabel.frame = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, 40)};
    } else {
        self.titleLabel.frame = (CGRect){CGPointZero, CGSizeZero};
    }
    
    [self layoutContentScrollView];
    self.contentScrollView.frame = CGRectMake(0, self.titleLabel.frame.size.height,
                                              self.bounds.size.width,
                                              self.contentScrollView.bounds.size.height);

    self.bounds = CGRectMake(0, 0, self.bounds.size.width,
                             self.titleLabel.bounds.size.height + self.contentScrollView.bounds.size.height + 44);

    self.cancelButton.frame = CGRectMake(0, self.bounds.size.height - 44, self.bounds.size.width, 44);
    self.lineLabel.frame = CGRectMake(0, self.bounds.size.height - 44 - SINGLE_LINE_WIDTH,
                                      self.bounds.size.width, SINGLE_LINE_WIDTH);
}

- (void)layoutContentScrollView
{
    UIEdgeInsets margin = UIEdgeInsetsMake(28, 10, 20, 10);
    CGSize itemSize = CGSizeMake((self.bounds.size.width - margin.left - margin.right) / kMAX_MENU_ROW_COUNT, 90);
    
    NSInteger itemCount = self.items.count;
    NSInteger rowCount = ((itemCount-1) / kMAX_MENU_ROW_COUNT) + 1;
    NSInteger pageCount = rowCount/2 + rowCount%2;
    self.contentScrollView.pagingEnabled = (pageCount > 1);
    self.contentScrollView.contentSize = CGSizeMake(self.bounds.size.width*pageCount,
                                                    (rowCount > 2 ? 2 : rowCount) * itemSize.height + margin.top + margin.bottom);
    for (int i=0; i<itemCount; i++) {
        SGGridItem *item = self.items[i];
        int row = i / kMAX_MENU_ROW_COUNT;
        int column = i % kMAX_MENU_ROW_COUNT;
        int page = row / 2;
        CGPoint p = CGPointMake(margin.left + column * itemSize.width + page*self.bounds.size.width,
                                margin.top + (row%2) * (itemSize.height + margin.left));
        item.frame = (CGRect){p, itemSize};
        [item layoutIfNeeded];
    }
    
    if (self.contentScrollView.contentSize.height > kMAX_CONTENT_SCROLLVIEW_HEIGHT) {
        self.contentScrollView.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width*pageCount, kMAX_CONTENT_SCROLLVIEW_HEIGHT)};
    }else{
        self.contentScrollView.bounds = (CGRect){CGPointZero, self.contentScrollView.contentSize};
    }
}

#pragma mark - 

- (void)triggerSelectedAction:(void (^)(NSInteger))actionHandle
{
    self.actionHandle = actionHandle;
}

#pragma mark -

- (void)tapAction:(id)sender
{
    if (self.actionHandle) {
        if ([sender isEqual:self.cancelButton]) {
            double delayInSeconds = 0.15;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.actionHandle(0);
            });
        }else{
            double delayInSeconds = 0.15;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.actionHandle([sender tag] + 1);
            });
        }
    }
}

@end
