//
//  UIRandomCodeView.m
//  wealth
//
//  Created by wangyingjie on 15/7/9.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UIRandomCodeView.h"

@interface UIRandomCodeView ()

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation UIRandomCodeView

+ (BOOL)randomCodeViewCheckString:(NSString *)text withCodeString:(NSString *)code {
    NSAssert(text != nil, nil);
    NSAssert(code != nil, nil);
    return [text.lowercaseString isEqualToString:code.lowercaseString];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self steup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self steup];
}

- (void)steup {
    self.userInteractionEnabled = YES;
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(generateCode:)];
    [self addGestureRecognizer:_tap];
    self.count = kRandomCodeCount;
    self.font = [UIFont systemFontOfSize:20.0];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = SINGLE_LINE_WIDTH;
    self.layer.borderColor = [UIColor grayColor].CGColor;
}

- (UIColor *)randomColor {
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    return randColor;
}

- (NSString *)randomCode {
    //数字: 48-57
    //小写字母: 97-122
    //大写字母: 65-90
    char chars[] = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLOMNOPQRSTUVWXYZ";
    char codes[self.count];

    for(NSInteger i = 0; i < self.count; i++){
        codes[i]= chars[arc4random()%62];
    }

    NSString *text = [[NSString alloc] initWithBytes:codes length:self.count encoding:NSUTF8StringEncoding];
    return text;
}

- (void)generateCode:(UITapGestureRecognizer *)tap {
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();

    NSString *text = [self randomCode];
    //生成文字
    if (self.didChangeCode) {
        self.didChangeCode(text);
    }
    CGSize charSize =  [@"A" sizeWithAttributes:@{NSFontAttributeName:_font}];

    CGPoint point;
    float pointX, pointY;

    int width = self.frame.size.width / text.length - charSize.width;
    int height = self.frame.size.height - charSize.height;

    for (NSInteger i = 0; i < text.length; i++) {
        pointX = arc4random() % width + self.frame.size.width / text.length * i;
        pointY = arc4random() % height;

        point = CGPointMake(pointX, pointY);
        unichar c = [text characterAtIndex:i];
        NSString *textChar = [NSString stringWithFormat:@"%C", c];
        CGContextSetLineWidth(context, 1.0);
        //[[UIColor blueColor] set];
        float fontSize = (arc4random() % 10) + 17;

        [textChar drawAtPoint:point withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                      NSStrokeColorAttributeName:[UIColor redColor],
                                                      NSForegroundColorAttributeName:[self randomColor]}];
    }

    //干扰线
    CGContextSetLineWidth(context, 1.0);
    for(int i = 0; i < self.count; i++) {
        CGContextSetStrokeColorWithColor(context, [[self randomColor] CGColor]);
        pointX = arc4random() % (int)self.frame.size.width;
        pointY = arc4random() % (int)self.frame.size.height;
        CGContextMoveToPoint(context, pointX, pointY);
        pointX = arc4random() % (int)self.frame.size.width;
        pointY = arc4random() % (int)self.frame.size.height;
        CGContextAddLineToPoint(context, pointX, pointY);
        CGContextStrokePath(context);
    }
    
    //干扰点
    for(int i = 0;i < self.count*6;i++) {
        CGContextSetStrokeColorWithColor(context, [[self randomColor] CGColor]);
        pointX = arc4random() % (int)self.frame.size.width;
        pointY = arc4random() % (int)self.frame.size.height;
        CGContextMoveToPoint(context, pointX, pointY);
        CGContextAddLineToPoint(context, pointX+1, pointY+1);

        //CGContextFillRect(context, CGRectMake(pointX,pointY,1,1));
        CGContextStrokePath(context);
    }
}

@end
