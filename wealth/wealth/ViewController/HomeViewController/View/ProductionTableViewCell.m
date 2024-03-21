//
//  ProductionTableViewCell.m
//  wealth
//
//  Created by wangyingjie on 16/3/22.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "ProductionTableViewCell.h"
#import "IconAndLabelView.h"
#import "ThreeLabelView.h"


@interface ProductionTableViewCell ()

@property (nonatomic, strong) UILabel *bottomView;
@property (nonatomic, strong) IconAndLabelView *titleView;
@property (nonatomic, strong) ThreeLabelView *monthLabel;
@property (nonatomic, strong) ThreeLabelView *moneyLabel;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) ThreeLabelView *insterestLabel;

@end

@implementation ProductionTableViewCell

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
    GreateLabel(self.bottomView, [UIColor get_10_Color], 10, NSTextAlignmentCenter, self.contentView);
    _bottomView.backgroundColor = [UIColor get_6_Color];
    
    self.titleView = [[IconAndLabelView alloc] initWithFrame:CGRectMake(0, 15.0f, ScreenWidth/2.0f, 30.0f)];
    [self.contentView addSubview:_titleView];
    
    self.monthLabel = [[ThreeLabelView alloc] init];
    [self.contentView addSubview:_monthLabel];
    self.moneyLabel = [[ThreeLabelView alloc] init];
    [self.contentView addSubview:_moneyLabel];
    self.insterestLabel = [[ThreeLabelView alloc] init];
    [self.contentView addSubview:_insterestLabel];
    GreateButtonType(self.nextButton, CGRectZero, @"立即出借", YES, self.contentView);
    [_nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark -
#pragma mark -SetupFrames
- (void)setUpFrames {
    _bottomView.frame = CGRectMake(0, self.height - 5.0f, self.width, 5.0f);
    
    [_titleView setTitle:_dataModel.productName AndIconView:[UIImage imageNamed:@"product_icon"]];
    _titleView.titleLabel.textColor = [UIColor get_1_Color];
    CGFloat height = [_monthLabel setLabelFText:@"出借期限:" AndFTextColor:[UIColor get_2_Color] AndFTextFont:[UIFont get_A24_CN_NOR_Font] AndSText:[NSString stringWithFormat:@"%lld ",_dataModel.period] AndSTextColor:[UIColor get_9_Color] AndSTextFont:[UIFont get_E36_CN_NOR_Font] AndTText:_dataModel.periodType AndTTextColor:[UIColor get_2_Color] AndTTextFont:[UIFont get_A24_CN_NOR_Font]];
    _monthLabel.secLabel.frame = CGRectMake(_monthLabel.secLabel.frame.origin.x, _monthLabel.secLabel.frame.origin.y+3.0f, _monthLabel.secLabel.frame.size.width, _monthLabel.secLabel.frame.size.height);
    _monthLabel.frame = CGRectMake(kLeftCommonMargin, _titleView.bottom + 0.0f, ScreenWidth/2.0f, height);
    
    height = [_moneyLabel setLabelFText:@"出借金额:" AndFTextColor:[UIColor get_2_Color] AndFTextFont:[UIFont get_A24_CN_NOR_Font] AndSText:[NSString getStringFromNumber:_dataModel.minAmount point:NO sign:NO] AndSTextColor:[UIColor get_9_Color] AndSTextFont:[UIFont get_E36_CN_NOR_Font] AndTText:@"起" AndTTextColor:[UIColor get_2_Color] AndTTextFont:[UIFont get_A24_CN_NOR_Font]];
    _moneyLabel.secLabel.frame = CGRectMake(_moneyLabel.secLabel.frame.origin.x, _moneyLabel.secLabel.frame.origin.y+3.0f, _moneyLabel.secLabel.frame.size.width, _moneyLabel.secLabel.frame.size.height);
    _moneyLabel.frame = CGRectMake(kLeftCommonMargin, _monthLabel.bottom + 5.0f, ScreenWidth/2.0f, height);
    
    height = [_insterestLabel setLabelFText:@"预期年化收益率:" AndFTextColor:[UIColor get_2_Color] AndFTextFont:[UIFont get_A24_CN_NOR_Font] AndSText:[NSString getStringFromNumber:_dataModel.annuaRate point:YES sign:NO] AndSTextColor:[UIColor get_9_Color] AndSTextFont:ScreenWidth320 ? [UIFont get_CN_NOR_FontWithFont:40] : [UIFont get_CN_NOR_FontWithFont:48] AndTText:@"%" AndTTextColor:[UIColor get_2_Color] AndTTextFont:[UIFont get_A24_CN_NOR_Font]];
    _insterestLabel.secLabel.frame = CGRectMake(_insterestLabel.secLabel.frame.origin.x, _insterestLabel.secLabel.frame.origin.y+3.0f, _insterestLabel.secLabel.frame.size.width, _insterestLabel.secLabel.frame.size.height);
    _insterestLabel.frame = CGRectMake(ScreenWidth/2.0f, 15.0f, ScreenWidth/2.0f, height);
    
    _nextButton.frame = CGRectMake(ScreenWidth/2.0f, _insterestLabel.bottom +12.0f, 170*kProportion, 40.0f);
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(self.width/2.0 - 20.0f, 15.0f, 0.5f, self.height-20.0f-10.0f);
//    [line drawDashedBorderWithCornerRadius:0 AndBorderWidth:0.5 AndDashPattern:2 AndSpacePattern:2 AndLineColor:[UIColor get_3_Color]];
    [self.contentView addSubview:line];
    [self drawDashLine:line lineLength:1 lineSpacing:1 lineColor:[UIColor get_3_Color]];
    line.hidden = ScreenWidth320;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    [self setUpFrames];
}

- (void)nextClick{
    if (self.buyClick) {
        self.buyClick();
    }
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

- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(0.3f, 50.0f)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:0.3f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, 0, self.height-35.0f-10.0f);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}




@end
