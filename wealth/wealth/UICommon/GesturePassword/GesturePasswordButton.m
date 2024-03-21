//
//  GesturePasswordButton.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "GesturePasswordButton.h"

#define bounds self.bounds

@interface GesturePasswordButton ()

@end

@implementation GesturePasswordButton
@synthesize selected;
@synthesize success;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        success = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *img = nil;
    if (selected) {
        if (success) {
            CGContextSetRGBStrokeColor(context, 25.0f/255.f, 46.0f/255.f, 84.0f/255.f,1);
            CGContextSetRGBFillColor(context, 25.0f/255.f, 46.0f/255.f, 84.0f/255.f,1);
            img = [UIImage imageNamed:@"gesture_circle_click"];
        } else {
            CGContextSetRGBStrokeColor(context, 198.0f/255.f, 22.0f/255.f, 30.0f/255.f, 1);
            CGContextSetRGBFillColor(context, 198.0f/255.f, 22.0f/255.f, 30.0f/255.f, 1);
            img = [UIImage imageNamed:@"bg_locker_default_click_wrong"];
        }
//        img = [UIImage imageNamed:@"gesture_circle_click"];
    } else {
        img = [UIImage imageNamed:@"gesture_circle_default"];
    }
    [img drawInRect:rect];
    CGContextStrokePath(context); // 绘制开始
    
//    // 填充颜色
//    if (success) {
//        CGContextSetRGBFillColor(context, 25.0f/255.f, 46.0f/255.f, 84.0f/255.f, 0.3);
//    } else {
//        CGContextSetRGBFillColor(context, 198.0f/255.f, 22.0f/255.f, 30.0f/255.f, 0.3);
//    }
//    CGContextAddEllipseInRect(context, CGRectMake(2, 2, bounds.size.width-3, bounds.size.height-3));
//    if (selected) {
//        CGContextFillPath(context);
//    }
}

//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    if (selected) {
//        if (success) {
//            CGContextSetRGBStrokeColor(context, 2/255.f, 174/255.f, 240/255.f,1);//线条颜色
//            CGContextSetRGBFillColor(context, 2/255.f, 174/255.f, 240/255.f,1);
//        }
//        else {
//            CGContextSetRGBStrokeColor(context, 208/255.f, 36/255.f, 36/255.f,1);//线条颜色
//            CGContextSetRGBFillColor(context, 208/255.f, 36/255.f, 36/255.f,1);
//        }
//        
//        CGFloat lengths[] = { 15, 15 };
//        CGContextSetLineDash(context, 0, lengths, 2);
//        CGRect frame = CGRectMake(bounds.size.width/2-bounds.size.width/8+1,
//                                  bounds.size.height/2-bounds.size.height/8,
//                                  bounds.size.width/4, bounds.size.height/4);
//        CGContextAddEllipseInRect(context,frame);
//        CGContextFillPath(context);
//    }
//    else{
//        CGContextSetRGBStrokeColor(context, 1,1,1,1);//线条颜色
//    }
//    
//    CGContextSetLineWidth(context,2);
//    CGRect frame = CGRectMake(2, 2, bounds.size.width-3, bounds.size.height-3);
//    CGContextAddEllipseInRect(context,frame);
//    CGContextStrokePath(context);
//    if (success) {
//        CGContextSetRGBFillColor(context,30/255.f, 175/255.f, 235/255.f,0.3);
//    }
//    else {
//        CGContextSetRGBFillColor(context,208/255.f, 36/255.f, 36/255.f,0.3);
//    }
//    CGContextAddEllipseInRect(context,frame);
//    if (selected) {
//        CGContextFillPath(context);
//    }
//}

@end
