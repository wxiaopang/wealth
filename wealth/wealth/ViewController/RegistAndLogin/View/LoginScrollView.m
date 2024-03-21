//
//  LoginScrollView.m
//  wealth
//
//  Created by wangyingjie on 16/3/18.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "LoginScrollView.h"




@interface LoginScrollView ()


@property (nonatomic, strong) UIImageView *bgImageView;   /**<*/
@property (nonatomic, strong) UIImageView *iconImageView;       /**<*/
@property (nonatomic, strong) UIButton *backButton;         /**<*/
@property (nonatomic, strong) UILabel *messageLabel;        /**<*/
@property (nonatomic, strong) UIButton *topButton;        /**<*/
@property (nonatomic, strong) UIButton *botButton;        /**<*/


@property (nonatomic, assign) NSInteger height1;
@property (nonatomic, assign) NSInteger height2;
@property (nonatomic, assign) NSInteger height3;
@property (nonatomic, assign) BOOL isCanClean;


@end

@implementation LoginScrollView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isCanClean = NO;

        [self setUpViews];
        
    }
    return self;
}


#pragma mark- SetupViews
- (void)setUpViews {
    //注册键盘弹起通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //注册键盘消失通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.backButton = [[UIButton alloc] initButtonWithFrame:CGRectMake(0, 10, 50, 70) backgroundColor:[UIColor clearColor] font:[UIFont get_A24_CN_NOR_Font] titleColor:[UIColor clearColor] title:@""];
    UIImage *image = [UIImage imageNamed:@"black_back"];
    [_backButton setImage:image forState:UIControlStateNormal];
    [_backButton setImage:image forState:UIControlStateDisabled];
    [_backButton setImage:image forState:UIControlStateHighlighted];
    [_backButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_backButton];
    
    self.iconImageView = [[UIImageView alloc] initImageViewWithFrame:CGRectMake((ScreenWidth - 140)/2.0f, ScreenHeight > 568 ? 110 : 90, 153.0f, 77.0f) image:[UIImage imageNamed:@"logo"] backgroundColor:[UIColor clearColor]];
    [self addSubview:_iconImageView];
    
    self.fristTextFeild = [[LARTextFeildView alloc] init];
    _fristTextFeild.frame = CGRectMake(0, _iconImageView.bottom + (ScreenHeight > 568 ? 70 : 60), ScreenWidth, 50);
    [_fristTextFeild setupThePlaceholderText:@"手机号码" AndTextColor:nil AndTextFont:nil AndIsSecure:NO AndTextFieldTag:1010];
    _fristTextFeild.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_fristTextFeild];
    
    self.secondTextFeild = [[LARTextFeildView alloc] init];
    _secondTextFeild.frame = CGRectMake(0, _fristTextFeild.bottom + 10.0f, ScreenWidth, 50);
    _secondTextFeild.contentTextField.secureTextEntry = YES;
    [_secondTextFeild setupThePlaceholderText:@"登录密码" AndTextColor:nil AndTextFont:nil AndIsSecure:YES AndTextFieldTag:1011];
//    _secondTextFeild.cleanBut.hidden = YES;
    [self addSubview:_secondTextFeild];
    _secondTextFeild.contentTextField.keyboardType = UIKeyboardTypeASCIICapable;
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _secondTextFeild.bottom + 10.0f, ScreenWidth, 20)];
    [_messageLabel setAdaptionWidthWithAttributedText:@"忘记密码?" textFont:FONT_CN_NORMAL(28) textColor:[UIColor get_9_Color] textLineStyle:NSUnderlineStyleSingle unitText:@"" unitFont:FONT_CN_NORMAL(28) unitColor:[UIColor get_9_Color] unitLineStyle:NSUnderlineStyleNone];
    _messageLabel.center = CGPointMake(ScreenWidth/2.0f, _messageLabel.center.y);
    _messageLabel.userInteractionEnabled = YES;
    [_messageLabel addTapGestureRecognizerWithTarget:self action:@selector(messageLabelClick)];
    [self addSubview:_messageLabel];
    
    UIImage *normalImage = [[UIImage imageNamed:@"big_button"] stretchableImageWithLeftCapWidth:50 topCapHeight:45];
    UIImage *highlightedImage = [[UIImage imageNamed:@"big_button_click"] stretchableImageWithLeftCapWidth:50 topCapHeight:45];
    
    self.topButton = [[UIButton alloc] initButtonWithFrame:CGRectMake(kLeftCommonMargin, _messageLabel.bottom + (10.0f)*1.5f, ScreenWidth-kLeftCommonMargin * 2, 45.0f) backgroundColor:[UIColor clearColor] font:FONT_CN_NORMAL(34) titleColor:[UIColor whiteColor] title:@"登录"];
    [_topButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [_topButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [_topButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_topButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_topButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _topButton.layer.masksToBounds = YES;
    _topButton.layer.cornerRadius = 3.0f;
    [_topButton addTapGestureRecognizerWithTarget:self action:@selector(topButtonClick)];
    [self addSubview:_topButton];
    
    self.botButton = [[UIButton alloc] initButtonWithFrame:CGRectMake(kLeftCommonMargin, _topButton.bottom + (10.0f)*0.6, ScreenWidth-kLeftCommonMargin * 2, 45.0f) backgroundColor:[UIColor clearColor] font:FONT_CN_NORMAL(34) titleColor:[UIColor get_9_Color] title:@"注册"];
    [_botButton addTapGestureRecognizerWithTarget:self action:@selector(botButtonClick)];
    [self addSubview:_botButton];
    
    self.height1 = _messageLabel.top;
    self.height2 = _topButton.top;
    self.height3 = _botButton.top;
    
    
}

- (void)messageLabelClick{
    NSLog(@"messageLabelClick");
    if (self.messageBlock) {
        self.messageBlock();
    }
}

- (void)clickBack{
    NSLog(@"clickBack");
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)topButtonClick{
    NSLog(@"topButtonClick");
    if (self.topButtonBlock) {
        self.topButtonBlock();
    }
}

- (void)botButtonClick{
    NSLog(@"botButtonClick");
    if (self.botButtonBlock) {
        self.botButtonBlock();
    }
}





#pragma mark - notification
- (void)keyboardWillShow:(NSNotification *)note
{
    [UIView animateWithDuration:0.26 animations:^{
        self.contentSize = CGSizeMake(ScreenWidth, ScreenHeight+(ScreenHeight>568 ? 150 : 120));
        self.contentOffset = CGPointMake(0, (ScreenHeight>568 ? 150 : 120));
        if (ScreenHeight > 568) {
//            _messageLabel.frame = CGRectMake(_messageLabel.left, _height1 - 10.0f, _messageLabel.width, _messageLabel.height);
//            _topButton.frame = CGRectMake(_topButton.left, _height2 - 20.0f, _topButton.width, _topButton.height);
//            _botButton.frame = CGRectMake(_botButton.left, _height3 - 30.0f, _botButton.width, _botButton.height);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:0.26 animations:^{
        self.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
        self.contentOffset = CGPointMake(0, 0);
        if (ScreenHeight > 568) {
//            _messageLabel.frame = CGRectMake(_messageLabel.left, _height1, _messageLabel.width, _messageLabel.height);
//            _topButton.frame = CGRectMake(_topButton.left, _height2, _topButton.width, _topButton.height);
//            _botButton.frame = CGRectMake(_botButton.left, _height3, _botButton.width, _botButton.height);
        }
    } completion:^(BOOL finished) {
        
    }];
}

//- (void)drawRect:(CGRect)rect {
//
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//}

@end
