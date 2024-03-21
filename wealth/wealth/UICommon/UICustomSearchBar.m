//
//  UICustomSearchBar.m
//  wealth
//
//  Created by wangyingjie on 15/6/2.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UICustomSearchBar.h"

#define kXMargin 16
#define kYMargin 0
#define kIconSize 16

#define kSearchBarHeight 40

@interface UICustomSearchBar () <UITextFieldDelegate> {
    BOOL _cancelButtonHidden;
}

@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIImageView *searchImageView;
@property (nonatomic) UIRoundedView *backgroundView;

@property (nonatomic) UIImage *searchImage;

@end

@implementation UICustomSearchBar

#pragma mark - Initializers

- (void)setDefaults {
    
    UIImage *searchIcon = [UIImage imageNamed:@"search-icon"];
    _searchImage = searchIcon;
    self.backgroundColor = [UIColor clearColor];
    
    NSUInteger boundsWidth = self.bounds.size.width - 2*kXMargin;
    NSUInteger textFieldHeight = self.bounds.size.height - 2*kYMargin;
    
    //Background Rounded White Image
    self.backgroundView = [[UIRoundedView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, self.bounds.size.height)];
    [self addSubview:self.backgroundView];
    
    //Search Image
    self.searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconSize, kIconSize)];
    self.searchImageView.image = self.searchImage;
    self.searchImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.searchImageView.center = CGPointMake(kIconSize/2 + kXMargin, CGRectGetMidY(self.bounds));
    [self addSubview:self.searchImageView];
    
    //TextField
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(kXMargin + kIconSize, kYMargin, boundsWidth, textFieldHeight)];
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    UIFont *defaultFont = [UIFont systemFontOfSize:14];
    self.textField.font = defaultFont;
    self.textField.textColor = [UIColor blackColor];
    [self addSubview:self.textField];
    
    //Cancel Button
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kIconSize, kIconSize)];
    [self.cancelButton setImage:[UIImage imageNamed:@"close-icon"] forState:UIControlStateNormal];
    self.cancelButton.contentMode = UIViewContentModeScaleAspectFit;
    self.cancelButton.center = CGPointMake(boundsWidth - (kIconSize/2 + kXMargin), CGRectGetMidY(self.bounds));
    [self.cancelButton addTarget:self action:@selector(pressedCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.cancelButton];
    
    
    //Listen to text changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:self.textField];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    CGRect newFrame = frame;
    frame.size.height = kSearchBarHeight;
    frame = newFrame;
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectMake(15, 20, ScreenWidth - 20, kSearchBarHeight)];
}

#pragma mark - Properties and actions

- (NSString *)text {
    return self.textField.text;
}
- (void)setText:(NSString *)text {
    self.textField.text = text;
}
- (NSString *)placeholder {
    return self.textField.placeholder;
}
- (void)setPlaceholder:(NSString *)placeholder {
    self.textField.placeholder = placeholder;
}

- (UIFont *)font {
    return self.textField.font;
}
- (void)setFont:(UIFont *)font {
    self.textField.font = font;
}

- (BOOL)isCancelButtonHidden {
    return _cancelButtonHidden;
}
- (void)setCancelButtonHidden:(BOOL)cancelButtonHidden {
    
    if (_cancelButtonHidden != cancelButtonHidden) {
        _cancelButtonHidden = cancelButtonHidden;
        self.cancelButton.hidden = cancelButtonHidden;
    }
}

- (void)pressedCancel: (id)sender {
    if ([self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)])
        [self.delegate searchBarCancelButtonClicked:self];
}

#pragma mark - Text Delegate

- (void)textChanged: (id)sender {
    if ([self.delegate respondsToSelector:@selector(searchBar:textDidChange:)])
        [self.delegate searchBar:self textDidChange:self.text];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)])
        return [self.delegate searchBarShouldBeginEditing:self];
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)])
        [self.delegate searchBarTextDidBeginEditing:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)])
        [self.delegate searchBarTextDidEndEditing:self];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)])
        [self.delegate searchBarSearchButtonClicked:self];
    
    return YES;
}

- (BOOL)isFirstResponder {
    return [self.textField isFirstResponder];
}
- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    return [self.textField becomeFirstResponder];
}
- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    return [self.textField resignFirstResponder];
}

#pragma mark - Cleanup

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@implementation UIRoundedView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor whiteColor].CGColor);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:18];
    [path fill];
}

@end
