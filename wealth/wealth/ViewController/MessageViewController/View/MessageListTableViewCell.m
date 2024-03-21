//
//  MessageListTableViewCell.m
//  wealth
//
//  Created by wangyingjie on 16/5/9.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "MessageListTableViewCell.h"

@interface MessageListTableViewCell ()

@property (nonatomic, strong) UIView *titleBGView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *bottomLine;




@end

@implementation MessageListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        [self setUpViews];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark -
#pragma mark -SetupViews
- (void)setUpViews {
    
    GreateUIView(self.titleBGView, [UIColor get_6_Color], self);
    GreateLabelf(self.timeLabel, [UIColor get_2_Color], [UIFont get_A24_CN_NOR_Font], NSTextAlignmentLeft, self.titleBGView);
    GreateImageView(self.iconView,  @"mine_icon_message_list", @"mine_icon_message_list", self);
    GreateLabelf(self.titleLabel, [UIColor get_1_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentLeft, self);
    GreateLabelf(self.contentLabel, [UIColor get_2_Color], [UIFont get_B26_CN_NOR_Font], NSTextAlignmentLeft, self);
    GreateEmptyLabel(self.bottomLine, [UIColor get_5_Color], self);
    
    _contentLabel.numberOfLines = 2;
    
}

#pragma mark -
#pragma mark -SetupFrames
- (void)setUpFrames {
    
    self.titleBGView.frame = CGRectMake(0, 0, self.width, 40.0f);
    
    [self.timeLabel setAdaptionHeightWithText:self.listmodel.msgTime];
    self.timeLabel.frame = CGRectMake(kLeftCommonMargin, (40.0f - _timeLabel.height)/2.0f, self.width-2.0f*kLeftCommonMargin, _timeLabel.height);
    
    self.iconView.frame = CGRectMake(kLeftCommonMargin, 40.0f + 20.0f, 15.0f, 15.0f);
    
    [self.titleLabel setAdaptionHeightWithText:self.listmodel.msgTitle];
    self.titleLabel.frame = CGRectMake(_iconView.right + 5.0f, _iconView.top-1.0f, self.width - kLeftCommonMargin - _iconView.right - 5.0f, _titleLabel.height);
    
    NSString *content = self.listmodel.msgPaper;
    self.contentLabel.text = content;
    CGSize size = [Utility getTextSizeWithText:content size:CGSizeMake(self.width - kLeftCommonMargin * 2.0f, 40.0f) font:_contentLabel.font];
    self.contentLabel.frame = CGRectMake(kLeftCommonMargin, _titleLabel.bottom + (self.height - _titleLabel.bottom - size.height)/2.0f, self.width - kLeftCommonMargin * 2.0f, size.height);
    
    self.bottomLine.frame = CGRectMake(0, self.height-0.5, self.width, 0.5f);
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
