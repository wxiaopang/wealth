//
//  LabelCell.m
//  wealth
//
//  Created by wangyingjie on 15/9/7.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "LabelCell.h"

@interface LabelCell ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation LabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftLabel = [[UITimerLable alloc] initWithFrame:CGRectZero];
        self.leftLabel.backgroundColor = [UIColor clearColor];
        self.leftLabel.textColor = [UIColor formLeftTitleNormalColor];
        self.leftLabel.textAlignment = NSTextAlignmentLeft;
        self.leftLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:_leftLabel];

        self.rightLabel = [[UITimerLable alloc] initWithFrame:CGRectZero];
        self.rightLabel.backgroundColor = [UIColor clearColor];
        self.rightLabel.textAlignment = NSTextAlignmentCenter;
        self.rightLabel.textColor = [UIColor formLeftTitleNormalColor];
        self.rightLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:_rightLabel];

        self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
        self.lineView.backgroundColor = [UIColor formTextFieldPlaceholderColor];
        [self addSubview:_lineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect origFrame = self.contentView.frame;
    _lineView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y + origFrame.size.height - _bottomMargin,
                                origFrame.size.width, _bottomMargin);
    if (_leftLabel.text != nil) {
        CGSize leftSize = [_leftLabel.text boundingRectWithSize:self.frame.size
                                                        options:(NSStringDrawingUsesLineFragmentOrigin
                                                                 | NSStringDrawingUsesFontLeading)
                                                     attributes:@{ NSFontAttributeName:_leftLabel.font }
                                                        context:nil].size;
        _leftLabel.frame = CGRectMake(origFrame.origin.x + 16, origFrame.origin.y,
                                      MAX(self.leftLabelMargin, leftSize.width + 12),
                                      origFrame.size.height-1);
        if ( _rightLabel.text != nil ) {
            CGSize rightSize = [_rightLabel.text boundingRectWithSize:self.frame.size
                                                              options:(NSStringDrawingUsesLineFragmentOrigin
                                                                       | NSStringDrawingUsesFontLeading)
                                                           attributes:@{ NSFontAttributeName:_rightLabel.font }
                                                              context:nil].size;
            _rightLabel.frame = CGRectMake(origFrame.size.width - rightSize.width - 16,
                                           origFrame.origin.y,
                                           rightSize.width,
                                           origFrame.size.height);
        } else {
            _leftLabel.width = origFrame.size.width - self.leftLabelMargin * 2;
        }
    } else {
        if ( _rightLabel.text != nil ) {
            _rightLabel.frame = origFrame;
        }
    }
    [self setNeedsDisplay];
}

@end
