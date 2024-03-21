//
//  HomeProductionTableViewCell.m
//  wealth
//
//  Created by wangyingjie on 16/3/22.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "HomeProductionTableViewCell.h"

@interface HomeProductionTableViewCell ()

@end

@implementation HomeProductionTableViewCell

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

