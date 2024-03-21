//
//  UCBankListCell.m
//  wealth
//
//  Created by wangyingjie on 16/4/19.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UCBankListCell.h"

@interface UCBankListCell ()

@property (nonatomic, strong) UIImageView *bankIcon;
@property (nonatomic, strong) UILabel *bankNameLabel;
@property (nonatomic, strong) UILabel *bankNoLabel;




@end

@implementation UCBankListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
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
    self.bankIcon = [[UIImageView alloc] initImageViewWithFrame:CGRectMake(kLeftCommonMargin, (80-57)/2.0f, 57.0f, 57.0f) image:[UIImage imageNamed:@""] backgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_bankIcon];
    
    GreateLabelf(self.bankNameLabel, [UIColor get_1_Color], [UIFont get_C30_CN_NOR_Font], NSTextAlignmentLeft, self.contentView);
    GreateLabelf(self.bankNoLabel, [UIColor get_1_Color], [UIFont get_A24_CN_NOR_Font], NSTextAlignmentRight, self.contentView);
    GreateEmptyLabel(self.upLine, [UIColor get_5_Color], self.contentView);
    GreateEmptyLabel(self.bottomLine, [UIColor get_5_Color], self.contentView);
    _upLine.hidden = YES;
    
}

#pragma mark -
#pragma mark -SetupFrames
- (void)setUpFrames {
    _bankNoLabel.hidden = _messageModel.isBankList;
    _upLine.frame = CGRectMake(0, 0, self.width, 0.5f);
    _bottomLine.frame = CGRectMake(0, 79.5f, self.width, 0.5f);
    if (_messageModel.isBankList) {
        _bankNameLabel.frame = CGRectMake(_bankIcon.right + 5.0f, (80-16)/2.0f, 250, 17.0f);
        _bankNoLabel.frame = CGRectMake(self.width-kLeftCommonMargin-200.0f, (80-16)/2.0f, 220, 16.0f);
        _bankNoLabel.textAlignment = NSTextAlignmentRight;
    }else{
//        _bankNameLabel.text = @"银行英航银行英航银行英航银";
//        _bankNoLabel.text = @"12345678901234567890";
        _bankNameLabel.frame = CGRectMake(_bankIcon.right + 5.0f, 23.0f, 250.0f, 17.0f);
        _bankNoLabel.frame = CGRectMake(_bankIcon.right + 5.0f, _bankNameLabel.bottom + 5.0f, 220, 16.0f);
        _bankNoLabel.textAlignment = NSTextAlignmentLeft;
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    _bankNameLabel.text = _messageModel.value;
    _bankNoLabel.text = _messageModel.cardNumber;
    [_bankIcon sd_setImageWithURL:[NSURL URLWithString:_messageModel.url] placeholderImage:[UIImage imageNamed:@"mine_icon_default_bank"]];
    
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

