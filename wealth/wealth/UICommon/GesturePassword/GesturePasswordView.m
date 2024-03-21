//
//  GesturePasswordView.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "GesturePasswordView.h"
#import "GesturePasswordButton.h"
#import "TentacleView.h"

@implementation GesturePasswordView {
    NSMutableArray * buttonArray;
    
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;

    UIView *buttonsView;
}
@synthesize imgView;
@synthesize forgetButton;
@synthesize useOtherButton;
@synthesize changeButton;
@synthesize tentacleInsets;
@synthesize tentacleView;
@synthesize state;
@synthesize gesturePasswordDelegate;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backgroundColor = CREATECOLOR(43, 60, 76, 0.9);
        self.backgroundColor = [UIColor clearColor];
        buttonArray = [[NSMutableArray alloc]initWithCapacity:0];
        tentacleInsets = UIEdgeInsetsMake(0, 0, 0, 0);

        CGFloat y_offset = 5.0f;
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 190.0f/2.0f)/2, kNavigationBarHeight + y_offset, 190.0f/2.0f, 96.0f/2.0f)];
//        imgView.clipsToBounds = YES;
//        [imgView.layer setCornerRadius:27];
//        [imgView.layer setBorderColor:[UIColor getColorWithR209G209B209].CGColor];
//        [imgView.layer setBorderWidth:SINGLE_LINE_WIDTH];
        imgView.image = [UIImage imageNamed:@"head_default_guest"];
        [self addSubview:imgView];

        [self customerHeaderReady:nil];

        state = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width - 280)/2, imgView.top + imgView.height + y_offset, 280, 30)];
        [state setTextAlignment:NSTextAlignmentCenter];
        [state setFont:[UIFont systemFontOfSize:15.f]];
        [self addSubview:state];
        
        CGSize size = CGSizeMake(ScreenWidth, ScreenHeight > 480 ? ScreenWidth : 250);
        buttonsView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - ScreenWidth)/2,
                                                               state.top + state.height + y_offset,
                                                               size.width, size.height)];
        buttonsView.backgroundColor = [UIColor clearColor];
        buttonsView.userInteractionEnabled = NO;

        tentacleView = [[TentacleView alloc] initWithFrame:buttonsView.frame];
        [self addSubview:tentacleView];

        CGFloat buttonSize = 56.0f;
        CGFloat margin = 44.0f;
        CGFloat leftMargin = (size.width - buttonSize * 3 - margin * 2) / 2;
        CGFloat topMargin = (size.height - buttonSize * 3 - margin * 2) / 2;
        for (int i = 0; i < 9; i++) {
            NSInteger row = i/3;
            NSInteger col = i%3;
            
//            // Button Frame
//            CGFloat buttonFrameWidth = floor(MIN(size.width, size.height)/3);
//            CGFloat buttonSize = floor(buttonFrameWidth/1.5);
//            CGFloat margin = (size.width-size.height)/2 + buttonSize/4;
//            GesturePasswordButton *gesturePasswordButton = [[GesturePasswordButton alloc] initWithFrame:CGRectMake(col*buttonFrameWidth+margin, row*buttonFrameWidth, buttonSize, buttonSize)];
//            [gesturePasswordButton setTag:i];
//            [view addSubview:gesturePasswordButton];
//            [buttonArray addObject:gesturePasswordButton];
            
            // Button Frame
            GesturePasswordButton *gesturePasswordButton = [[GesturePasswordButton alloc] initWithFrame:CGRectMake(leftMargin + col * (buttonSize + margin),
                                                                                                                   topMargin + row * (buttonSize + 40.0f),
                                                                                                                   buttonSize, buttonSize)];
            [gesturePasswordButton setTag:i];
            [buttonsView addSubview:gesturePasswordButton];
            [buttonArray addObject:gesturePasswordButton];
        }
        frame.origin.y = 0;
        [self addSubview:buttonsView];

//        tentacleView = [[TentacleView alloc] initWithFrame:view.frame];
        [tentacleView setButtonArray:buttonArray];
        [tentacleView setTouchBeginDelegate:self];
//        [self addSubview:tentacleView];

//        forgetButton = [[UIButton alloc]initWithFrame:CGRectMake((frame.size.width/2-120)/2,
//                                                                 tentacleView.top + tentacleView.height + 5,
//                                                                 120, 30)];
        NSInteger integer = 5;
        if (ScreenHeight == 480) {
            integer = 50;
        }
        forgetButton = [[UIButton alloc]initWithFrame:CGRectMake((frame.size.width - 120)/2,
                                                                 tentacleView.top + tentacleView.height + integer,
                                                                 120, 30)];
        [forgetButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [forgetButton setTitle:@"忘记手势密码" forState:UIControlStateNormal];
        [forgetButton addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchDown];
        [self addSubview:forgetButton];
        
        useOtherButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width-140.0f,
                                                                 tentacleView.top + tentacleView.height + integer,
                                                                 120, 30)];
        [useOtherButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [useOtherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [useOtherButton setTitle:@"使用其他账号登录" forState:UIControlStateNormal];
        [useOtherButton addTarget:self action:@selector(useOther) forControlEvents:UIControlEventTouchDown];
        [self addSubview:useOtherButton];
        useOtherButton.hidden =YES;
        
//        changeButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2 + (frame.size.width/2-120)/2,
//                                                                 tentacleView.top + tentacleView.height + 5,
//                                                                 120, 30)];
//        [changeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
//        [changeButton setTitleColor:[UIColor formLeftTitleNormalColor] forState:UIControlStateNormal];
//        [changeButton setTitle:@"修改手势密码" forState:UIControlStateNormal];
//        [changeButton addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchDown];
//        [self addSubview:changeButton];
    }

    SEL func = @selector(customerHeaderReady:);
    NotificationCenterAddObserver(func, kCustomHeaderReady, nil);
    return self;
}

- (void)dealloc {
    NotificationCenterRemoveObserver;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect frame = self.frame;
    CGFloat y_offset = 10.0f;
    if (ScreenHeight > 480) {
        CGFloat top = [self.gesturePasswordDelegate isKindOfClass:[UIBaseViewController class]]
                        ? kNavigationBarHeight + 20
                        : kNavigationBarHeight;
//        imgView.frame = CGRectMake((frame.size.width - 54)/2, top + y_offset, 54, 54);
        imgView.frame = CGRectMake((frame.size.width - 190.0f/2.0f)/2, top + y_offset, 190.0f/2.0f, 96.0f/2.0f);
        state.frame = CGRectMake((frame.size.width - 280)/2, imgView.top + imgView.height + y_offset, 280, 30);

        CGSize size = CGSizeMake(ScreenWidth, ScreenWidth);
        buttonsView.frame = CGRectMake((frame.size.width - ScreenWidth)/2,
                                       state.top + state.height + 10.0f,
                                       size.width, size.height);
        tentacleView.frame = buttonsView.frame;

        forgetButton.frame = CGRectMake(forgetButton.frame.origin.x,
                                        tentacleView.top + tentacleView.height - 10,
                                        120, 30);
        
    } else {
//        imgView.frame = CGRectMake((frame.size.width - 54)/2, 70, 54, 54);
        imgView.frame = CGRectMake((frame.size.width - 190.0f/2.0f)/2, 70, 190.0f/2.0f, 96.0f/2.0f);
        state.frame = CGRectMake((frame.size.width - 280)/2, imgView.top + imgView.height + 10, 280, 30);

        CGSize size = CGSizeMake(ScreenWidth, 250);
        buttonsView.frame = CGRectMake((frame.size.width - ScreenWidth)/2,
                                       state.top + state.height + 10.0f,
                                       size.width, size.height);
        tentacleView.frame = buttonsView.frame;

        forgetButton.frame = CGRectMake(forgetButton.frame.origin.x,
                                        tentacleView.top + tentacleView.height + 5,
                                        120, 30);
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    // Drawing code
    if ( self.blurImage ) {
        // 高斯模糊效果
//        [[self.blurImage applyDarkEffect] drawInRect:rect];
    } else {
        // 渐变色效果
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        CGFloat colors[] = {
            //57 73 88
            57 / 255.0, 73 / 255.0, 88 / 255.0, 0.80,
            57 / 255.0, 73 / 255.0, 88 / 255.0, 0.80,
        };
        CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
        CGColorSpaceRelease(rgb);
        CGContextDrawLinearGradient(context, gradient,
                                    CGPointMake(0.0,0.0) ,CGPointMake(0.0,rect.size.height),
                                    kCGGradientDrawsBeforeStartLocation);
        CGGradientRelease(gradient);
    }
}

- (void)gestureTouchBegin {
    [self.state setText:@""];
}

- (void)customerHeaderReady:(NSNotification *)notification {
//    PictureInformation *pictureInformation = [[GET_CLIENT_MANAGER.loanManager getPictureInformation:AnnexType_HeaderImage] firstObject];
//    if (pictureInformation) {
//        imgView.image = [UIImage imageWithContentsOfFile:[[PathEngine getDocumentPath] stringByAppendingPathComponent:pictureInformation.filePath]];
//    } else {
////        CustomerInformation *customerInformation = GET_CLIENT_MANAGER.customerManager.customerInformation;
////        if ( customerInformation.iconPath && customerInformation.iconPath.length > 0 ) {
////            [imgView sd_setImageWithURL:[NSURL URLWithString:customerInformation.iconPath]
////                       placeholderImage:[UIImage imageNamed:@"mine_head"]
////                                options:GET_SDWEBIMAGE_OPTIONS];
////        } else {
////            imgView.image = [UIImage imageNamed:@"mine_head"];
////        }
//    }
}

-(void)forget {
    if ( gesturePasswordDelegate && [gesturePasswordDelegate respondsToSelector:@selector(forget)] ) {
        [gesturePasswordDelegate forget];
    }
}

-(void)change {
    if ( gesturePasswordDelegate && [gesturePasswordDelegate respondsToSelector:@selector(change)] ) {
        [gesturePasswordDelegate change];
    }
}

- (void)useOther{
    if ( gesturePasswordDelegate && [gesturePasswordDelegate respondsToSelector:@selector(useOther)] ) {
        [gesturePasswordDelegate useOther];
    }
}

@end
