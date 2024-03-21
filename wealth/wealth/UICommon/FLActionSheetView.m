//
//  FLActionSheetView.m
//  WarnningDetailViewController.m
//
//  Created by 刘红波 on 15/4/2.
//  Copyright (c) 2015年 flex_lau. All rights reserved.
//

#import "FLActionSheetView.h"

#define CANCEL_BUTTON_COLOR                     [UIColor whiteColor]  //取消按钮颜色
#define DESTRUCTIVE_BUTTON_COLOR                [UIColor colorWithRed:185/255.00f green:45/255.00f blue:39/255.00f alpha:1]//销毁按钮颜色
#define OTHER_BUTTON_COLOR                      [UIColor whiteColor]//其他的颜色
#define ACTIONSHEET_BACKGROUNDCOLOR             [UIColor clearColor]//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]//弹出框的背景色
#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]//window的背景颜色
#define CORNER_RADIUS                           5  //弧度大小

#define BUTTON_INTERVAL_HEIGHT                  8//按钮的间隔
#define BUTTON_HEIGHT                           44//按钮的高度
#define BUTTON_INTERVAL_WIDTH                   8//按钮的宽度
#define BUTTON_WIDTH                             [[UIScreen mainScreen] bounds].size.width-16 //按钮宽
#define BUTTONTITLE_FONT                        [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]//字体大小
#define BUTTON_BORDER_WIDTH                     0.5f//边框线的宽度
#define BUTTON_BORDER_COLOR                     [UIColor whiteColor].CGColor//[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8].CGColor//边框线的颜色


#define TITLE_INTERVAL_HEIGHT                   15//标题的间隔
#define TITLE_HEIGHT                            35//标题的高度
#define TITLE_INTERVAL_WIDTH                    30 //标题的间隔
#define TITLE_WIDTH                             [[UIScreen mainScreen] bounds].size.width-60 //标题label的宽
#define TITLE_FONT                              [UIFont fontWithName:@"Helvetica-Bold" size:14]//标题字体大小
#define SHADOW_OFFSET                           CGSizeMake(0, 0.8f) //阴影偏移量
#define TITLE_NUMBER_LINES                      2 //标题的行数

#define ANIMATE_DURATION                        0.25f //动画间隔时间

@interface FLActionSheetView()
@property (nonatomic,strong) UIView *backGroundView;//背景
@property (nonatomic,strong) NSString *actionTitle;//标题
@property (nonatomic,assign) NSInteger positionIndexNumber;
@property (nonatomic,assign) BOOL isHadTitle;
@property (nonatomic,assign) BOOL isHadDestructionButton;
@property (nonatomic,assign) BOOL isHadCancelButton;
@property (nonatomic,assign) BOOL isHadOtherButton;
@property (nonatomic,assign) CGFloat actionSheetHeight;
@property (nonatomic,assign) id<FLActionSheetViewDelegate> delegate;
@end
@implementation FLActionSheetView

#pragma mark -----Public Method

-(id)initWithTitle:(NSString *)title delegate:(id<FLActionSheetViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray
{
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureCancle)];
        [self addGestureRecognizer:tapGesture];
        if (delegate) {
            self.delegate = delegate;
        }
        [self initSubViewWithButtonTitle:title cancelButtonTitle:cancelButtonTitle destructionButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitlesArray];
    }
    return self;
}
#pragma mark initSubView
- (void)initSubViewWithButtonTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructionButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray
{
    //初始化
    self.isHadTitle = NO;
    self.isHadDestructionButton = NO;
    self.isHadOtherButton = NO;
    self.isHadCancelButton = NO;
   
    //初始化flACtionView的高度为0
    self.actionSheetHeight = 0;
    
    //初始化IndexNumber为0;
    self.positionIndexNumber = 0;
    
    //生成flACtionView   //开始在屏幕之下
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
    self.backGroundView.backgroundColor = ACTIONSHEET_BACKGROUNDCOLOR;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureBg)];
    [self.backGroundView addGestureRecognizer:tapGesture];
    
    [self addSubview:self.backGroundView];
    
    
    if (title)
    {
        self.isHadTitle = YES;
        UILabel *titleLabel = [self makeTitleWithTitleString:title];
        self.actionSheetHeight = self.actionSheetHeight + 2*TITLE_INTERVAL_HEIGHT + TITLE_HEIGHT;
        [self.backGroundView addSubview:titleLabel];
    }
    
    if (destructiveButtonTitle)
    {
        self.isHadDestructionButton = YES;
        UIButton *destructionButton = [self makeDestructionButtonWithTitleString:destructiveButtonTitle];
        destructionButton.tag = self.positionIndexNumber;
        [destructionButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (self.isHadTitle)
        {
            //当有title时
            [destructionButton setFrame:CGRectMake(destructionButton.frame.origin.x, self.actionSheetHeight, destructionButton.frame.size.width, destructionButton.frame.size.height)];
            
            if (otherButtonTitlesArray && otherButtonTitlesArray.count > 0)
            {
                self.actionSheetHeight = self.actionSheetHeight + destructionButton.frame.size.height+BUTTON_INTERVAL_HEIGHT/2;
            }
            else
            {
                self.actionSheetHeight = self.actionSheetHeight + destructionButton.frame.size.height+BUTTON_INTERVAL_HEIGHT;//否者就是没有下面的view
            }

        }
        else
        {
            //当无title时
            if (otherButtonTitlesArray && otherButtonTitlesArray.count > 0)
            {
                self.actionSheetHeight = self.actionSheetHeight + destructionButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT+(BUTTON_INTERVAL_HEIGHT/2));//没有标题 并且有 其他 按钮
            }
            else
            {
                self.actionSheetHeight = self.actionSheetHeight + destructionButton.frame.size.height+(2*BUTTON_INTERVAL_HEIGHT);//没有标题没有其他按钮
            }
        }

        [self.backGroundView addSubview:destructionButton];
        
        self.positionIndexNumber++;

    }
    
    //初始化其他button
    if (otherButtonTitlesArray) {
        if (otherButtonTitlesArray.count > 0) {
            self.isHadOtherButton = YES;
            
            //当无title与destructionButton时
            if (self.isHadTitle == NO && self.isHadDestructionButton == NO)
            {
                for (int i = 0; i<otherButtonTitlesArray.count; i++)
                {
                    //创建其他button的按钮
                    UIButton *otherButton = [self makeOtherButtonWith:[otherButtonTitlesArray objectAtIndex:i] withPostion:i];
                    
                    otherButton.tag = self.positionIndexNumber;
                    [otherButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (i != otherButtonTitlesArray.count - 1)
                    {
                        self.actionSheetHeight = self.actionSheetHeight + otherButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT/2);
                    }
                    else
                    {
                        self.actionSheetHeight = self.actionSheetHeight + otherButton.frame.size.height+(2*BUTTON_INTERVAL_HEIGHT);
                    }
                    
                    [self.backGroundView addSubview:otherButton];
                    
                    self.positionIndexNumber++;
                }
            }
            
            //当有title或destructionButton时
            if (self.isHadTitle == YES || self.isHadDestructionButton == YES)
            {
                for (int i = 0; i<otherButtonTitlesArray.count; i++)
                {
                    UIButton *otherButton = [self makeOtherButtonWith:[otherButtonTitlesArray objectAtIndex:i] withPostion:i];
                    
                    otherButton.tag = self.positionIndexNumber;
                    [otherButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
                    [otherButton setFrame:CGRectMake(otherButton.frame.origin.x, self.actionSheetHeight, otherButton.frame.size.width, otherButton.frame.size.height)];
                    
                    if (i != otherButtonTitlesArray.count - 1)
                    {
                        self.actionSheetHeight = self.actionSheetHeight + otherButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT/2);
                    }
                    else
                    {
                        self.actionSheetHeight = self.actionSheetHeight + otherButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT);
                    }
                    
                    [self.backGroundView addSubview:otherButton];
                    
                    self.positionIndexNumber++;
                }
            }
        }
    }
    
    if (cancelButtonTitle) {
        self.isHadCancelButton = YES;
        
        UIButton *cancelButton = [self makeCancelButtonWith:cancelButtonTitle];
        
        cancelButton.tag = self.positionIndexNumber;
        [cancelButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
        
        //当没title destructionButton otherbuttons时
        if (self.isHadTitle == NO && self.isHadDestructionButton == NO && self.isHadOtherButton == NO) {
            self.actionSheetHeight = self.actionSheetHeight + cancelButton.frame.size.height+(2*BUTTON_INTERVAL_HEIGHT);
        }
        
        //当有title或destructionButton或otherbuttons时
        if (self.isHadTitle == YES || self.isHadDestructionButton == YES || self.isHadOtherButton == YES) {
            [cancelButton setFrame:CGRectMake(cancelButton.frame.origin.x, self.actionSheetHeight, cancelButton.frame.size.width, cancelButton.frame.size.height)];
            self.actionSheetHeight = self.actionSheetHeight + cancelButton.frame.size.height+BUTTON_INTERVAL_HEIGHT;
        }
        
        [self.backGroundView addSubview:cancelButton];
        
        self.positionIndexNumber++;
    }
    
    //出现时的动画
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.actionSheetHeight, [UIScreen mainScreen].bounds.size.width, self.actionSheetHeight)];
    } completion:^(BOOL finished) {
    }];


}
#pragma mark  初始化标题
-(UILabel *)makeTitleWithTitleString:(NSString *)titleString
{
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_INTERVAL_WIDTH, TITLE_INTERVAL_HEIGHT, TITLE_WIDTH, TITLE_HEIGHT)];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.shadowColor = [UIColor blackColor];
    titlelabel.shadowOffset = SHADOW_OFFSET;
    titlelabel.font = TITLE_FONT;
    titlelabel.text = titleString;
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.numberOfLines = TITLE_NUMBER_LINES;
    return titlelabel;

}
-(UIButton *)makeDestructionButtonWithTitleString:(NSString *)titleString
{
   
    UIButton *destructiveButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_INTERVAL_WIDTH, BUTTON_INTERVAL_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT)];
    destructiveButton.layer.masksToBounds = YES;
    destructiveButton.layer.cornerRadius = CORNER_RADIUS;
    
    destructiveButton.layer.borderWidth = BUTTON_BORDER_WIDTH;
    destructiveButton.layer.borderColor = BUTTON_BORDER_COLOR;
    
    destructiveButton.backgroundColor = DESTRUCTIVE_BUTTON_COLOR;
    [destructiveButton setTitle:titleString forState:UIControlStateNormal];
    destructiveButton.titleLabel.font = BUTTONTITLE_FONT;
    
    [destructiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [destructiveButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    return destructiveButton;
}

- (UIButton *)makeOtherButtonWith:(NSString *)otherButtonTitle withPostion:(NSInteger )postionIndex
{
    UIButton *otherButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_INTERVAL_WIDTH, BUTTON_INTERVAL_HEIGHT + (postionIndex*(BUTTON_HEIGHT+(BUTTON_INTERVAL_HEIGHT/2))), BUTTON_WIDTH, BUTTON_HEIGHT)];
    otherButton.layer.masksToBounds = YES;
    otherButton.layer.cornerRadius = CORNER_RADIUS;
    
    otherButton.layer.borderWidth = BUTTON_BORDER_WIDTH;
    otherButton.layer.borderColor = BUTTON_BORDER_COLOR;
    
    otherButton.backgroundColor = OTHER_BUTTON_COLOR;
    [otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
    otherButton.titleLabel.font = BUTTONTITLE_FONT;
    [otherButton setTitleColor:[UIColor button1BackgroundNormalColor] forState:UIControlStateNormal];
    [otherButton setTitleColor:[UIColor button1BackgroundNormalColor] forState:UIControlStateHighlighted];
    return otherButton;
}

- (UIButton *)makeCancelButtonWith:(NSString *)cancelButtonTitle
{
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_INTERVAL_WIDTH, BUTTON_INTERVAL_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT)];
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = CORNER_RADIUS;
    
    cancelButton.layer.borderWidth = BUTTON_BORDER_WIDTH;
    cancelButton.layer.borderColor = BUTTON_BORDER_COLOR;
    
    cancelButton.backgroundColor = CANCEL_BUTTON_COLOR;
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    cancelButton.titleLabel.font = BUTTONTITLE_FONT;
    [cancelButton setTitleColor:[UIColor accoutViewBackgroudColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor accoutViewBackgroudColor] forState:UIControlStateHighlighted];
    return cancelButton;
}
#pragma mark  点击按钮

- (void)clickOnButtonWith:(UIButton *)button
{
    if (self.isHadDestructionButton == YES) {
        if (self.delegate) {
            if (button.tag == 0) {
                if ([self.delegate respondsToSelector:@selector(flActionSheetViewClickOnDestructiveButton:)] == YES){
                    [self.delegate flActionSheetViewClickOnDestructiveButton:self];
                }
            }
        }
    }
    
    if (self.isHadCancelButton == YES) {
        if (self.delegate) {
            if (button.tag == self.positionIndexNumber-1) {
                if ([self.delegate respondsToSelector:@selector(flActionSheetViewClickOnCancleButton:)] == YES) {
                    [self.delegate flActionSheetViewClickOnCancleButton:self];
                }
            }
        }
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(flActionSheetView:ClickOnButtonIndex:)] == YES) {
            [self.delegate flActionSheetView:self ClickOnButtonIndex:(NSInteger)button.tag];
        }
    }
    
    [self tapGestureCancle];
}
#pragma mark  展示
- (void)showInView:(UIView *)view
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

#pragma mark  点击本身
-(void)tapGestureCancle
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];

}
#pragma make 点击背景
-(void)tapGestureBg
{
    NSLog(@"点击了action的背景");
}
@end
