//
//  UIArrowView.m
//  wealth
//
//  Created by wangyingjie on 15/3/9.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UIArrowView.h"

@interface UIArrowView ()

@property (nonatomic, weak) UIImage *image;
@property (nonatomic, strong) UIImage *foldImage;
@property (nonatomic, strong) UIImage *unfoldImage;

@end

@implementation UIArrowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.arrowColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        self.foldImage = [UIImage imageNamed:@"com_arrows_fold"];
        self.unfoldImage = [UIImage imageNamed:@"com_arrows_unfold"];
        self.image = self.foldImage;
    }
    return self;
}

- (void)setTransform:(CGAffineTransform)transform {
    self.image = (transform.d == -1) ? self.foldImage : self.unfoldImage;
    [self setNeedsDisplay];
//    [UIView animateWithDuration:0.3f
//                     animations:^{
//                         [super setTransform:transform];
//                         if ( transform.d == -1 ) { // 旋转角度 M_PI
//                             [self drawWithColor:[UIColor messageBubbleColor]]
//                         } else if ( transform.d == 1 ) { // 旋转角度 0
//                             [self drawWithColor:[UIColor formLeftTitleNormalColor]];
//                         }
//                         [self setNeedsDisplay];
//                     }];
}

-(void)drawWithColor:(UIColor *)color {
    self.arrowColor = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self.image drawInRect:rect];
    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [self.arrowColor setStroke];
//    
//    [path setLineWidth:1.0f];
//    switch ( self.type ) {
//        case ArrowViewDirection_UP: {
//            [path moveToPoint:CGPointMake(0, self.height)];
//            [path addLineToPoint:CGPointMake(self.width/2, 0)];
//            [path addLineToPoint:CGPointMake(self.width, self.height)];
//        }
//            break;
//            
//        case ArrowViewDirection_DOWN: {
//            [path moveToPoint:CGPointMake(0, 0)];
//            [path addLineToPoint:CGPointMake(self.width/2, self.height)];
//            [path addLineToPoint:CGPointMake(self.width, 0)];
//        }
//            break;
//            
//        case ArrowViewDirection_LEFT: {
//            [path moveToPoint:CGPointMake(self.width, 0)];
//            [path addLineToPoint:CGPointMake(0, self.height/2)];
//            [path addLineToPoint:CGPointMake(self.width, self.height)];
//        }
//            break;
//            
//        case ArrowViewDirection_RIGHT: {
//            [path moveToPoint:CGPointMake(0, 0)];
//            [path addLineToPoint:CGPointMake(self.width, self.height/2)];
//            [path addLineToPoint:CGPointMake(0, self.height)];
//        }
//            break;
//            
//        default:
//            break;
//    }
//    [path stroke];
}

@end
