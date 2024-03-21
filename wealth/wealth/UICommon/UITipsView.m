//
//  UITipsView.m
//  wealth
//
//  Created by wangyingjie on 15/4/7.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "UITipsView.h"

@implementation TipsButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    NSDictionary *dic = @{ NSFontAttributeName:[UIFont systemFontOfSize:16.0f],
                           NSForegroundColorAttributeName:[UIColor QACheckSuccessedColor]};
    CGSize textSize = [@"刷新" sizeWithAttributes:dic];
     self.imageView.image  = [UIImage imageNamed:@"com_icon_reload"];
    [self.imageView.image drawInRect:CGRectMake((self.width - textSize.width - 18.0f)/2, 9.0f, 18.0f, 18.0f)];
    [@"刷新" drawInRect:CGRectMake((self.width - textSize.width - 18.0f)/2 + 18.0f, (self.height - textSize.height)/2, textSize.width, textSize.height) withAttributes:dic];
}
@end


@interface UITipsView ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) TipsButton *tipsBtn;/**< 刷新按钮 */

@end

@implementation UITipsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        self.backgroundColor = [UIColor whiteColor];
        _tipsBtn = [TipsButton buttonWithType:UIButtonTypeCustom];
        _tipsBtn.layer.cornerRadius = 2;
        _tipsBtn.layer.borderWidth = SINGLE_LINE_ADJUST_OFFSET;
        _tipsBtn.layer.backgroundColor = [UIColor getColorWithR211G218B226].CGColor;
        [_tipsBtn addTarget:self action:@selector(TipsButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_tipsBtn];
    }
    return self;
}

- (void)setType:(TipsViewType)type {
    _type = type;
    switch ( _type ) {
        case TipsViewType_Empty:
            self.image = nil;
            break;
            
        case TipsViewType_EmptySearch:
            self.image = [UIImage imageNamed:@"com_icon_default_result"];
            break;
            
        case TipsViewType_EmptyMessage:
            self.image = [UIImage imageNamed:@"com_icon_default_infor"];
            break;
            
        case TipsViewType_NetworkError://com_rerult_defeated
            self.image = [UIImage imageNamed:@"com_defalt_error"];
            break;

        case TipsViewType_Network404Error:
            self.image = [UIImage imageNamed:@"com_defalt_error"];
            break;

        case TipsViewType_PhotoGraphEmpty:
            self.image = [UIImage imageNamed:@"pic_none"];
            break;
       
        default:
            break;
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if ( self.image ) {
        CGSize imageSize = self.image.size;
        CGFloat x_offset = (rect.size.width - MAX(imageSize.width, 86.0f)) / 2;
        CGFloat y_offset = (rect.size.height - MAX(imageSize.height, 86.0f) - kNavigationBarHeight) / 2;
        [self.image drawInRect:CGRectMake(x_offset, y_offset + _yOffset,
                                          MAX(imageSize.width, 86.0f),
                                          MAX(imageSize.height, 86.0f))];
    }
    
    if ( self.title ) {
        NSDictionary *dic = @{ NSFontAttributeName:[UIFont systemFontOfSize:16.0f],
                               NSForegroundColorAttributeName:[UIColor formLeftTitleNormalColor] };
        CGSize textSize = [self.title sizeWithAttributes:dic];
        CGFloat x_offset = (rect.size.width - textSize.width) / 2;
        CGFloat y_offset = 0.0f;
        if ( self.image ) {
            CGSize imageSize = self.image.size;
            y_offset = (rect.size.height - MAX(imageSize.height, 86.0f) - kNavigationBarHeight) / 2 + MAX(imageSize.height, 86.0f) + 24.0f;
        } else {
            y_offset = (rect.size.height - textSize.height - kNavigationBarHeight) / 2;
        }
        if ( [self.title isEqualToString:kNullStr] ) {
            y_offset -= textSize.height;
            textSize.height = 0;
        } else {
            [self.title drawInRect:CGRectMake(x_offset, y_offset + _yOffset, textSize.width, textSize.height) withAttributes:dic];
        }
        
        
        if ( self.detaiText ) {
            CGSize detaiTextSize = [self.detaiText sizeWithAttributes:dic];
            CGFloat x_offset_detail = (rect.size.width - detaiTextSize.width) / 2;
            CGFloat y_offset_detail = y_offset + textSize.height + 12.0f;
            [self.detaiText drawInRect:CGRectMake(x_offset_detail, y_offset_detail + _yOffset, detaiTextSize.width, detaiTextSize.height) withAttributes:dic];
             _tipsBtn.frame = CGRectMake((self.width - 130.0f)/2, y_offset_detail + _yOffset + 42.0f, 130.0f, 36.0f);
            [_tipsBtn setNeedsDisplay];
        }
    }
}


- (void)TipsButtonClick {
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
}
@end
