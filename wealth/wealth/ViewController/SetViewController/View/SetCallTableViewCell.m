//
//  SetCallTableViewCell.m
//  wealth
//
//  Created by wangyingjie on 16/3/23.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "SetCallTableViewCell.h"
#import "SetCallView.h"



@interface SetCallTableViewCell ()

@end

@implementation SetCallTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.contentView.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor clearColor];
        [self setUpViews];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark -
#pragma mark -SetupViews
- (void)setUpViews {
    
    SetCallView *callView = [[SetCallView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, 99.0f)];
    [self.contentView addSubview:callView];
}

#pragma mark -
#pragma mark -SetupFrames
- (void)setUpFrames {
    
    
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

