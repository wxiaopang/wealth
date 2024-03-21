//
//  TentacleView.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "TentacleView.h"
#import "GesturePasswordButton.h"

@implementation TentacleView {
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;
    
    NSMutableArray * touchesArray;
    NSMutableArray * touchedArray;
    BOOL success;
}
@synthesize buttonArray;
@synthesize rerificationDelegate;
@synthesize resetDelegate;
@synthesize touchBeginDelegate;
@synthesize style;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        touchesArray = [[NSMutableArray alloc] initWithCapacity:0];
        touchedArray = [[NSMutableArray alloc] initWithCapacity:0];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        success = 1;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint;
    UITouch *touch = [touches anyObject];
    [touchesArray removeAllObjects];
    [touchedArray removeAllObjects];
    [touchBeginDelegate gestureTouchBegin];
    success=1;
    if (touch) {
        touchPoint = [touch locationInView:self];
        for (int i=0; i<buttonArray.count; i++) {
            GesturePasswordButton * buttonTemp = ((GesturePasswordButton *)[buttonArray objectAtIndex:i]);
            [buttonTemp setSuccess:YES];
            [buttonTemp setSelected:NO];
            if (CGRectContainsPoint(buttonTemp.frame,touchPoint)) {
                CGRect frameTemp = buttonTemp.frame;
                CGPoint point = CGPointMake(frameTemp.origin.x+frameTemp.size.width/2,frameTemp.origin.y+frameTemp.size.height/2);
                [touchesArray addObject:@{ @"x":[NSString stringWithFormat:@"%f",point.x],
                                           @"y":[NSString stringWithFormat:@"%f",point.y] }];
                lineStartPoint = touchPoint;
            }
            [buttonTemp setNeedsDisplay];
        }
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint;
    UITouch *touch = [touches anyObject];
    if (touch) {
        touchPoint = [touch locationInView:self];
        for (int i=0; i<buttonArray.count; i++) {
            GesturePasswordButton * buttonTemp = ((GesturePasswordButton *)[buttonArray objectAtIndex:i]);
            if (CGRectContainsPoint(buttonTemp.frame,touchPoint)) {
                if ([touchedArray containsObject:[NSString stringWithFormat:@"num%d",i]]) {
                    lineEndPoint = touchPoint;
                    [self setNeedsDisplay];
                    return;
                }
                [touchedArray addObject:[NSString stringWithFormat:@"num%d",i]];
                [buttonTemp setSelected:YES];
                [buttonTemp setNeedsDisplay];
                CGRect frameTemp = buttonTemp.frame;
                CGPoint point = CGPointMake(frameTemp.origin.x+frameTemp.size.width/2,frameTemp.origin.y+frameTemp.size.height/2);
                [touchesArray addObject:@{ @"x":[NSString stringWithFormat:@"%f",point.x],
                                           @"y":[NSString stringWithFormat:@"%f",point.y],
                                           @"num":[NSString stringWithFormat:@"%d",i] }];
                break;
            }
        }
        lineEndPoint = touchPoint;
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSMutableString * resultString=[NSMutableString string];
    for ( NSDictionary * num in touchesArray ){
        if(![num objectForKey:@"num"])break;
        [resultString appendString:[num objectForKey:@"num"]];
    }
    if(style==1){
        success = [rerificationDelegate verification:resultString];
    } else {
        success = [resetDelegate resetPassword:resultString];
    }
    
    for (int i=0; i<touchesArray.count; i++) {
        NSInteger selection = [[[touchesArray objectAtIndex:i] objectForKey:@"num"]intValue];
        GesturePasswordButton * buttonTemp = ((GesturePasswordButton *)[buttonArray objectAtIndex:selection]);
        [buttonTemp setSuccess:success];
        [buttonTemp setNeedsDisplay];
    }
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    // Drawing code
    for (int i=0; i<touchesArray.count; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (![[touchesArray objectAtIndex:i] objectForKey:@"num"]) { //防止过快滑动产生垃圾数据
            [touchesArray removeObjectAtIndex:i];
            continue;
        }
//219, 183, 107, 1
        if (success) {
            CGContextSetRGBStrokeColor(context, 219/255.f, 183/255.f, 107/255.f, 1);//线条颜色
        } else {
            CGContextSetRGBStrokeColor(context, 255/255.f, 77/255.f, 77/255.f, 1);//红色
        }

        CGPoint startPoint = CGPointMake([[[touchesArray objectAtIndex:i] objectForKey:@"x"] floatValue],
                                         [[[touchesArray objectAtIndex:i] objectForKey:@"y"] floatValue]);
        CGContextSetLineWidth(context, 3);
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        if (i < touchesArray.count-1) {
            CGPoint endPoint = CGPointMake([[[touchesArray objectAtIndex:i+1] objectForKey:@"x"] floatValue],
                                           [[[touchesArray objectAtIndex:i+1] objectForKey:@"y"] floatValue]);
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        } else {
            if (success) {
                CGContextAddLineToPoint(context, lineEndPoint.x, lineEndPoint.y);
            }
        }
        CGContextStrokePath(context);
    }
}

- (void)enterArgin {
    [touchesArray removeAllObjects];
    [touchedArray removeAllObjects];
    for (int i=0; i<buttonArray.count; i++) {
        GesturePasswordButton * buttonTemp = ((GesturePasswordButton *)[buttonArray objectAtIndex:i]);
        [buttonTemp setSelected:NO];
        [buttonTemp setSuccess:YES];
        [buttonTemp setNeedsDisplay];
    }
    
    [self setNeedsDisplay];
}

- (void)enterErrorArgin{
    for (int i=0; i<touchesArray.count; i++) {
        NSDictionary * num = [touchesArray objectAtIndex:i];
        GesturePasswordButton * buttonTemp = ((GesturePasswordButton *)[buttonArray objectAtIndex:[num[@"num"] integerValue]]);
        [buttonTemp setSelected:YES];
        [buttonTemp setSuccess:NO];
        [buttonTemp setNeedsDisplay];
    }
    [self performSelector:@selector(enterArgin) withObject:nil afterDelay:0.3];
}



@end
