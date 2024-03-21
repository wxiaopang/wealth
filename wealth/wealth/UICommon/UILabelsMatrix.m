//
//  UILabelsMatrix.m
//  wealth
//
//  Created by wangyingjie on 15/2/12.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UILabelsMatrix.h"
#import "UIInsetsLabel.h"

#define kRowHeight  35

@interface UILabelsMatrix () {
    NSMutableArray *_records;
}

@property (nonatomic, strong) NSArray *columnsWidths;
@property (nonatomic, assign) NSUInteger numRows;
@property (nonatomic, assign) NSUInteger dy; // 表格y轴偏移量
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, assign) CGPoint startTouchPoint;

@end

@implementation UILabelsMatrix

- (instancetype)initWithFrame:(CGRect)frame andColumnsWidths:(NSArray*)columns {
    self = [super initWithFrame:frame];
    if ( self ) {
        [self initialized];
        
        self.columnsWidths = columns;
        self.textAlignment = NSTextAlignmentCenter;
        self.insets = UIEdgeInsetsZero;
        self.rowHeight = kRowHeight;
        _records = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)initialized {
    self.dy = 0;
    self.numRows = 0;
    self.startTouchPoint = CGPointZero;
    
    self.footerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.footerView.backgroundColor = CREATECOLOR(26, 47, 83, 1);
    [self addSubview:self.footerView];
}

- (NSArray *)addRecord:(NSArray*)record {
    NSAssert(record.count == self.columnsWidths.count, @"!!! Number of items does not match number of columns. !!!");
    
    [_records addObject:record];
    
    NSUInteger rowHeight = self.rowHeight;
    NSUInteger dx = self.left;
    
    NSMutableArray* labels = [[NSMutableArray alloc] init];
    
    //CREATE THE ITEMS/COLUMNS OF THE ROW
    for (NSUInteger i = 0; i < record.count; i++) {
        float colWidth = [self.columnsWidths[i] floatValue];	//colwidth as given at setup
        CGRect rect = CGRectMake(dx, self.dy, colWidth, rowHeight);
        
        //ADJUST X FOR BORDER OVERLAPPING BETWEEN COLUMNS
        if( i > 0 ) { rect.origin.x -= i; }
        
        UIInsetsLabel* col1 = [[UIInsetsLabel alloc] initWithInsets:self.insets];
//        [col1.layer setBorderColor:[[UIColor colorWithWhite:0.821 alpha:1.000] CGColor]];
//        [col1.layer setBorderWidth:1.0];
        col1.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        col1.frame = rect;
        
        //SET LEFT RIGHT MARGINS & ALIGNMENT FOR THE LABEL
        NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = self.textAlignment;
//        style.headIndent = 10;
//        style.firstLineHeadIndent = 10.0;
//        style.tailIndent = -10.0;
        
        //SPECIAL TREATMENT FOR THE FIRST ROW
        if(self.numRows == 0) {
            if ( self.titleLableColor ) {
                col1.textColor = [UIColor whiteColor];
                col1.backgroundColor = self.titleLableColor;
            }
        } else if ( self.numRows % 2 == 1 ) {
            if ( self.oddRowLableColor ) {
                col1.backgroundColor = self.oddRowLableColor;
            }
        } else {
            if ( self.evenRowLableColor ) {
                col1.backgroundColor = self.evenRowLableColor;
            }
        }
        
        NSAttributedString *attrText = nil;
        if ( [record[i] isKindOfClass:[NSAttributedString class]] ) {
            attrText = record[i];
        } else {
            attrText = [[NSAttributedString alloc] initWithString:record[i] attributes:@{ NSParagraphStyleAttributeName:style }];
        }
        col1.textAlignment = NSTextAlignmentCenter;
        col1.lineBreakMode = NSLineBreakByCharWrapping;
        col1.numberOfLines = 0;
        col1.attributedText = attrText;
        [col1 sizeToFit];
        
        //USED TO FIND HEIGHT OF LONGEST LABEL
        CGFloat h = col1.frame.size.height ;
        if ( h > rowHeight ) { rowHeight = h; }
        
        //MAKE THE LABEL WIDTH SAME AS COLUMN'S WIDTH
        rect.size.width = colWidth;
        col1.frame = rect;
        
        [labels addObject:col1];
        
        //USED FOR SETTING THE NEXT COLUMN X POSITION
        dx += colWidth;
    }
    
    //MAKE ALL THE LABELS OF SAME HEIGHT AND THEN ADD TO VIEW
    for ( NSUInteger i = 0; i < labels.count; i++ ) {
        UIInsetsLabel* tempLabel = (UIInsetsLabel*)[labels objectAtIndex:i];
        CGRect tempRect = tempLabel.frame;
        tempRect.size.height = rowHeight;
        tempLabel.frame = tempRect;
        [self addSubview:tempLabel];
    }
    
    self.numRows++;
    
    //ADJUST y FOR BORDER OVERLAPPING BETWEEN ROWS
    self.dy += rowHeight-1;
    
    //RESIZE THE MAIN VIEW TO FIT THE ROWS
    CGRect tempRect = self.frame;
    if ( self.titleLableColor ) {
        self.footerView.frame = CGRectMake(0, self.dy, tempRect.size.width-2, 5);
        tempRect.size.height = self.dy + 5;
    }
    self.frame = tempRect;
    
    return labels;
}

- (void)deleteRecord:(NSInteger)row {
    if ( self.numRows >= row ) {
        [_records removeObjectAtIndex:row];
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self initialized];

        [_records enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self addRecord:obj];
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.startTouchPoint = [touches.allObjects.firstObject locationInView:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touches.allObjects.firstObject locationInView:self];
    if ( CGRectContainsPoint(self.bounds, touchPoint) && fabs(self.startTouchPoint.y - touchPoint.y) < kRowHeight ) {
        NSInteger row = self.startTouchPoint.y / kRowHeight;
        if ( self.delegate && [self.delegate respondsToSelector:@selector(touchUpInsideIndex:matrix:)] && row >= 0 ) {
            [self.delegate touchUpInsideIndex:row matrix:self];
        }
    }
}

@end
