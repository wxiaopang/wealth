//
//  SetBaseTableViewCell.m
//  wealth
//
//  Created by wangyingjie on 16/3/23.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "SetBaseTableViewCell.h"


@interface SetBaseTableViewCell ()

@end

@implementation SetBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        [self setUpViews];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark -
#pragma mark -SetupViews
- (void)setUpViews {
    GreateLabelf(self.titleLabel, [UIColor get_1_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentLeft, self.contentView);
    GreateLabelf(self.messageLabel, [UIColor get_1_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentLeft, self.contentView);
    GreateLabelf(self.logoutLabel, [UIColor get_9_Color], [UIFont get_C30_CN_BOL_Font], NSTextAlignmentCenter, self.contentView);
    GreateImageView(self.nextImageView, @"icon_select", @"", self.contentView);
    GreateEmptyLabel(self.bottomLine, [UIColor get_5_Color], self.contentView);
}

#pragma mark -
#pragma mark -SetupFrames
- (void)setUpFrames {
    _bottomLine.frame = CGRectMake(0, self.height-0.5f, self.width, 0.5f);
    switch (_cellType) {
        case SetMainCellType_call:{
            _titleLabel.hidden = YES;
            _messageLabel.hidden = YES;
            _logoutLabel.hidden = YES;
            _nextImageView.hidden = YES;
            _bottomLine.hidden = YES;
        }break;
        case SetMainCellType_pwd:{
            _titleLabel.hidden = NO;
            _messageLabel.hidden = YES;
            _logoutLabel.hidden = YES;
            _nextImageView.hidden = NO;
            _bottomLine.hidden = NO;
            [_titleLabel setAdaptionHeightWithText:@"修改登录密码"];
            _titleLabel.frame = CGRectMake(kLeftCommonMargin, (self.height - _titleLabel.height)/2.0f, 150.0f, _titleLabel.height);
            _nextImageView.frame = CGRectMake(self.width-kLeftCommonMargin-_nextImageView.image.size.width, (self.height - _nextImageView.image.size.height)/2.0f, _nextImageView.image.size.width, _nextImageView.image.size.height);
        }break;
        case SetMainCellType_gest:{
            _titleLabel.hidden = NO;
            _messageLabel.hidden = YES;
            _logoutLabel.hidden = YES;
            _nextImageView.hidden = NO;
            _bottomLine.hidden = NO;
            [_titleLabel setAdaptionHeightWithText:@"修改手势密码"];
            _titleLabel.frame = CGRectMake(kLeftCommonMargin, (self.height - _titleLabel.height)/2.0f, 150.0f, _titleLabel.height);
            _nextImageView.frame = CGRectMake(self.width-kLeftCommonMargin-_nextImageView.image.size.width, (self.height - _nextImageView.image.size.height)/2.0f, _nextImageView.image.size.width, _nextImageView.image.size.height);
        }break;
        case SetMainCellType_wetchat:{
            _titleLabel.hidden = NO;
            _messageLabel.hidden = YES;
            _logoutLabel.hidden = YES;
            _nextImageView.hidden = NO;
            _bottomLine.hidden = NO;
            [_titleLabel setAdaptionHeightWithText:@"官方微信"];
            _titleLabel.frame = CGRectMake(kLeftCommonMargin, (self.height - _titleLabel.height)/2.0f, 150.0f, _titleLabel.height);
            _nextImageView.frame = CGRectMake(self.width-kLeftCommonMargin-_nextImageView.image.size.width, (self.height - _nextImageView.image.size.height)/2.0f, _nextImageView.image.size.width, _nextImageView.image.size.height);
        }break;
        case SetMainCellType_about:{
            _titleLabel.hidden = NO;
            _messageLabel.hidden = YES;
            _logoutLabel.hidden = YES;
            _nextImageView.hidden = NO;
            _bottomLine.hidden = YES;
            [_titleLabel setAdaptionHeightWithText:@"关于"];
            _titleLabel.frame = CGRectMake(kLeftCommonMargin, (self.height - _titleLabel.height)/2.0f, 150.0f, _titleLabel.height);
            _nextImageView.frame = CGRectMake(self.width-kLeftCommonMargin-_nextImageView.image.size.width, (self.height - _nextImageView.image.size.height)/2.0f, _nextImageView.image.size.width, _nextImageView.image.size.height);
        }break;
        case SetMainCellType_logout:{
            _titleLabel.hidden = YES;
            _messageLabel.hidden = YES;
            _logoutLabel.hidden = NO;
            _nextImageView.hidden = YES;
            _bottomLine.hidden = YES;
            [_logoutLabel setAdaptionHeightWithText:@"退出登录"];
            _logoutLabel.frame = CGRectMake(kLeftCommonMargin, (self.height - _logoutLabel.height)/2.0f, (self.width - kLeftCommonMargin*2.0f), _logoutLabel.height);
        }break;
            
        default:{
            _titleLabel.hidden = YES;
            _messageLabel.hidden = YES;
            _logoutLabel.hidden = YES;
            _nextImageView.hidden = YES;
            _bottomLine.hidden = YES;
            self.contentView.backgroundColor = [UIColor get_6_Color];
        }break;
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self setUpFrames];
}

#pragma mark -
#pragma mark -TouchActions
- (void)touchAction:(id)sender {
    
}

#pragma mark -
#pragma mark -PrivateMethod


#pragma mark -
#pragma mark -Setter


#pragma mark -
#pragma mark -Getter


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

