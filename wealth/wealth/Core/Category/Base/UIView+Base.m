//
//  UIView+Base.m
//  iqianjin
//
//  Created by yangzhaofeng on 15/7/15.
//  Copyright (c) 2015年 iqianjin. All rights reserved.
//

#import "UIView+Base.h"
#import <objc/runtime.h>
#import <Accelerate/Accelerate.h>

@implementation UIView (Base)

#pragma mark- init
- (UIView *)initViewWithFrame:(CGRect)frame
              backgroundColor:(UIColor *)backgroundColor {
    self = [self initWithFrame:frame];
    if (self) {
        if (backgroundColor) {
            self.backgroundColor = backgroundColor;
        }
    }
    return self;
}

#pragma mark- addGesture
- (void)addTapGestureRecognizerWithTarget:(id)target action:(SEL)action {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:tap];
}
- (void)addTapGestureRecognizerWithTarget:(id)target delegate:(id)delegate action:(SEL)action {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tap.delegate = delegate;
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:tap];
}

- (void)addSwipeGestureRecognizerWithTarget:(id)target action:(SEL)action {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    [swipe setDirection:UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionUp];
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:swipe];
}
- (void)addSwipeGestureRecognizerWithTarget:(id)target delegate:(id)delegate action:(SEL)action {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    [swipe setDirection:UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionUp];
    swipe.delegate = delegate;
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:swipe];
}

- (void)addLeftSwipeGestureRecognizerWithTarget:(id)target action:(SEL)action {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:swipe];
}
- (void)addLeftSwipeGestureRecognizerWithTarget:(id)target delegate:(id)delegate action:(SEL)action {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    swipe.delegate = delegate;
    [self addGestureRecognizer:swipe];
}

- (void)addRightSwipeGestureRecognizerWithTarget:(id)target action:(SEL)action {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:swipe];
}
- (void)addRightSwipeGestureRecognizerWithTarget:(id)target delegate:(id)delegate action:(SEL)action {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    swipe.delegate = delegate;
    [self addGestureRecognizer:swipe];
}

- (void)addLongPressGestureRecognizerWithTarget:(id)target action:(SEL)action {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:longPress];
}
- (void)addLongPressGestureRecognizerWithTarget:(id)target delegate:(id)delegate action:(SEL)action {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:action];
    longPress.delegate = delegate;
    [self addGestureRecognizer:longPress];
}

#pragma mark- 画线
- (void)addLineWithFrame:(CGRect)frame {
    [self addLineWithFrame:frame color:[UIColor get_6_Color]];
}

- (void)addLineWithFrame:(CGRect)frame color:(UIColor *)color {
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    [self addSubview:line];
}

- (UIView *)addGetLineWithFrame:(CGRect)frame color:(UIColor *)color {
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    [self addSubview:line];
    return line;
}

- (UIView *)addGetLineWithFrame:(CGRect)frame {
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = [UIColor get_6_Color];
    [self addSubview:line];
    return line;
}

#pragma mark 画点线
- (void)addPointsHorizontalLineFrame:(CGRect)frame {
    float onePointWidth = 1;
    float oneGapWidth = 1;
    for (int i = 0; i < ceilf(frame.size.width/(onePointWidth + oneGapWidth)); i++) {
        UIView *pointView = [[UIView alloc] initViewWithFrame:CGRectMake(frame.origin.x + (onePointWidth + oneGapWidth)*i, frame.origin.y, onePointWidth, kSeparateLineHeight) backgroundColor:[UIColor get_6_Color]];
        [self addSubview:pointView];
    }
}

- (void)addPointsVerticalLineFrame:(CGRect)frame {
    float onePointWidth = 1;
    float oneGapWidth = 1;
    for (int i = 0; i < ceilf(frame.size.height/(onePointWidth + oneGapWidth)); i++) {
        UIView *pointView = [[UIView alloc] initViewWithFrame:CGRectMake(frame.origin.x, frame.origin.y + (onePointWidth + oneGapWidth)*i, kSeparateLineHeight, onePointWidth) backgroundColor:[UIColor get_6_Color]];
        [self addSubview:pointView];
    }
}

#pragma mark 给View指定方位设置圆角
- (void)setViewWithRoundingCorners:(UIRectCorner)roundingCorners cornerRadius:(CGFloat)cornerRadius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:roundingCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

#pragma mark 截屏
- (UIImage *)getCurrentBackImage {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, YES, 0.0f);
    CGContextRef context2 = UIGraphicsGetCurrentContext();
    [window.layer renderInContext:context2];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end




@implementation UIView (Dashed)

static void *const kUIViewBorderTypeDashedKey = (void *)&kUIViewBorderTypeDashedKey;
static void *const kUIViewBorderColorKey = (void *)&kUIViewBorderColorKey;
static void *const kUIViewCornerRadiusKey = (void *)&kUIViewCornerRadiusKey;
static void *const kUIViewBorderWidthKey = (void *)&kUIViewBorderWidthKey;
static void *const kUIViewDashPatternKey = (void *)&kUIViewDashPatternKey;
static void *const kUIViewSpacePatternKey = (void *)&kUIViewSpacePatternKey;
static void *const kUIViewShapeLayerKey = (void *)&kUIViewShapeLayerKey;



#pragma mark - Drawing

- (void)drawDashedBorderWithCornerRadius:(double)cornerRadius AndBorderWidth:(double)borderWidth AndDashPattern:(NSInteger)dashPattern AndSpacePattern:(NSInteger)spacePattern AndLineColor:(UIColor *)borderColor{
    self.cornerRadius = cornerRadius;
    self.borderWidth = borderWidth;
    self.dashPattern = dashPattern;
    self.spacePattern = spacePattern;
    self.borderColor = borderColor;
    self.borderTypeDashed = YES;
    
}

- (void)drawDashedBorder{
    if (self.shapeLayer) [self.shapeLayer removeFromSuperlayer];
    
    //border definitions
    CGFloat cornerRadius = self.cornerRadius;
    if (self.layer.cornerRadius >0) {
        cornerRadius = self.layer.cornerRadius;
    }
    CGFloat borderWidth = self.borderWidth;
    NSInteger dashPattern1 = self.dashPattern;
    NSInteger dashPattern2 = self.spacePattern;
    UIColor *lineColor = self.borderColor ? self.borderColor : [UIColor clearColor];
    
    //drawing
    CGRect frame = self.bounds;
    
    self.shapeLayer = [CAShapeLayer layer];
    
    //creating a path
    CGMutablePathRef path = CGPathCreateMutable();
    
    if (self.bounds.size.height <= 1 || self.bounds.size.height <= borderWidth * 2.0f) {
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, frame.size.width, 0);
    }else if (self.bounds.size.width <= 1 || self.bounds.size.width <= borderWidth * 2.0f) {
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, 0, frame.size.height);
    }else {
        //drawing a border around a view
        CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
        CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
        CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
        CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
        CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
        CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
        CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
        CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
        CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    }
    //path is set as the _shapeLayer object's path
    self.shapeLayer.path = path;
    CGPathRelease(path);
    
    self.shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    self.shapeLayer.frame = frame;
    self.shapeLayer.masksToBounds = NO;
    [self.shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    self.shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    self.shapeLayer.strokeColor = [lineColor CGColor];
    self.shapeLayer.lineWidth = borderWidth;
    self.shapeLayer.lineDashPattern = self.borderTypeDashed ? [NSArray arrayWithObjects:[NSNumber numberWithInteger:dashPattern1], [NSNumber numberWithInteger:dashPattern2], nil] : nil;
    self.shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view
    [self.layer addSublayer:self.shapeLayer];
    self.layer.cornerRadius = cornerRadius;
}


- (void)setBorderColor:(UIColor *)borderColor{
    objc_setAssociatedObject(self, kUIViewBorderColorKey, borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self drawDashedBorder];
}

- (UIColor *)borderColor{
    return objc_getAssociatedObject(self, kUIViewBorderColorKey);
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    objc_setAssociatedObject(self, kUIViewCornerRadiusKey, @(cornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self drawDashedBorder];
}

- (CGFloat)cornerRadius{
    return [objc_getAssociatedObject(self, kUIViewCornerRadiusKey) floatValue];
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    objc_setAssociatedObject(self, kUIViewBorderWidthKey, @(borderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self drawDashedBorder];
}

- (CGFloat)borderWidth{
    return [objc_getAssociatedObject(self, kUIViewBorderWidthKey) floatValue];
}

- (void)setDashPattern:(NSUInteger)dashPattern{
    objc_setAssociatedObject(self, kUIViewDashPatternKey, @(dashPattern), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self drawDashedBorder];
}

- (NSUInteger)dashPattern{
    return [objc_getAssociatedObject(self, kUIViewDashPatternKey) integerValue];
}

- (void)setSpacePattern:(NSUInteger)spacePattern{
    objc_setAssociatedObject(self, kUIViewSpacePatternKey, @(spacePattern), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self drawDashedBorder];
}

- (NSUInteger)spacePattern{
    return [objc_getAssociatedObject(self, kUIViewSpacePatternKey) integerValue];
}

- (void)setShapeLayer:(CAShapeLayer *)shapeLayer{
    objc_setAssociatedObject(self, kUIViewShapeLayerKey, shapeLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)shapeLayer{
    return objc_getAssociatedObject(self, kUIViewShapeLayerKey);
}

- (void)setBorderTypeDashed:(BOOL)borderTypeDashed{
    objc_setAssociatedObject(self, kUIViewBorderTypeDashedKey, @(borderTypeDashed), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self drawDashedBorder];
}

- (BOOL)borderTypeDashed{
    return [objc_getAssociatedObject(self, kUIViewBorderTypeDashedKey) boolValue];
}

@end





