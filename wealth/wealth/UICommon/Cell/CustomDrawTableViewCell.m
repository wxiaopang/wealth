//
//  CustomDrawTableViewCell.m
//  wealth
//
//  Created by wangyingjie on 15/2/15.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "CustomDrawTableViewCell.h"

@implementation CustomContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        self.topLineColor = [UIColor getColorWithR209G209B209];
        self.middleLineColor = [UIColor getColorWithR230G230B230];
        self.bottomLineColor = [UIColor getColorWithR209G209B209];
    }
    return self;
}

- (void)setType:(CellPositionType)type {
    _type = type;
    [self setNeedsDisplayInRect:self.frame];
}

//画直线
- (void)drawLineWithContext:(CGContextRef)context width:(CGFloat)width color:(CGColorRef)color fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    CGContextSetStrokeColorWithColor(context, color);
    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
    CGContextSetLineWidth(context, width);
    CGContextStrokePath(context);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    switch ( _type ) {
        case CellPositionType_Top: {
            //上分割线
            [self drawLineWithContext:context
                                width:SINGLE_LINE_WIDTH
                                color:self.topLineColor.CGColor
                            fromPoint:CGPointMake(0, 0)
                              toPoint:CGPointMake(width, 0)];
            //下分割线
            [self drawLineWithContext:context
                                width:SINGLE_LINE_WIDTH
                                color:self.middleLineColor.CGColor
                            fromPoint:CGPointMake(16, height - 0.5)
                              toPoint:CGPointMake(width, height - 0.5)];
        }
            break;
            
        case CellPositionType_Middle: {
            //下分割线
            [self drawLineWithContext:context
                                width:SINGLE_LINE_WIDTH
                                color:self.middleLineColor.CGColor
                            fromPoint:CGPointMake(16, height - 0.5)
                              toPoint:CGPointMake(width, height - 0.5)];
        }
            break;
            
        case CellPositionType_shortMiddle: {
            //下分割线
            [self drawLineWithContext:context
                                width:SINGLE_LINE_WIDTH
                                color:self.middleLineColor.CGColor
                            fromPoint:CGPointMake(16, height - 0.5)
                              toPoint:CGPointMake(width - 32, height - 0.5)];
        }
            break;
            
        case CellPositionType_Bottom: {
            //下分割线
            [self drawLineWithContext:context
                                width:SINGLE_LINE_WIDTH
                                color:self.bottomLineColor.CGColor
                            fromPoint:CGPointMake(0, height - 0.5)
                              toPoint:CGPointMake(width, height - 0.5)];
        }
            break;
            
        case CellPositionType_Single: {
            //上分割线
            [self drawLineWithContext:context
                                width:SINGLE_LINE_WIDTH
                                color:self.topLineColor.CGColor
                            fromPoint:CGPointMake(0, 0)
                              toPoint:CGPointMake(width, 0)];
            //下分割线
            [self drawLineWithContext:context
                                width:SINGLE_LINE_WIDTH
                                color:self.topLineColor.CGColor
                            fromPoint:CGPointMake(0, height - 0.5)
                              toPoint:CGPointMake(width, height - 0.5)];
        }
            break;
            
        default:
            break;
    }
    UIGraphicsPushContext(context);
}

@end

@interface CustomDrawTableViewCell ()

@property (nonatomic, strong) CustomContentView *customContentView;
@property (nonatomic, assign) UITableViewCellStyle accountStyle;

@end

@implementation CustomDrawTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.customContentView = [[CustomContentView alloc] initWithFrame:self.contentView.bounds];
        self.customContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.customContentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.customContentView];
        
        self.accountStyle = style;
    }
    return self;
}

- (void)setType:(CellPositionType)type {
    self.customContentView.type = type;
}

- (CellPositionType)type {
    return self.customContentView.type;
}


- (void)setTopLineColor:(UIColor *)topLineColor {
    self.customContentView.topLineColor = topLineColor;
}

- (UIColor *)topLineColor {
    return self.customContentView.topLineColor;
}

- (void)setMiddleLineColor:(UIColor *)middleLineColor {
    self.customContentView.middleLineColor = middleLineColor;
}

- (UIColor *)middleLineColor {
    return self.customContentView.middleLineColor;
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    self.customContentView.bottomLineColor = bottomLineColor;
}

- (UIColor *)bottomLineColor {
    return self.customContentView.bottomLineColor;
}

- (void)resetSubViews {
    [self.customContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ( ![obj isEqual:self.customContentView] ) {
            [obj removeFromSuperview];
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.controlFrameChange) {
        self.textLabel.frame = CGRectMake(self.imageView.right + 15, self.textLabel.top, self.textLabel.width, self.textLabel.height);
    }
    
    if (self.accountStyle == UITableViewCellStyleValue1) {
        self.textLabel.frame = CGRectMake(self.imageView.right+50, self.textLabel.top, self.textLabel.width, self.textLabel.height);
        self.detailTextLabel.frame = CGRectMake(self.textLabel.right + 20, self.detailTextLabel.top, self.detailTextLabel.width, self.detailTextLabel.height);

    }

    
}

@end
