//
//  UCBankMsgInputView.h
//  wealth
//
//  Created by wangyingjie on 16/4/19.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCBankMsgInputView : UIView

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UILabel *bottomLine;
@property (nonatomic, strong) UILabel *upLine;
@property (nonatomic, strong) UIImageView *nextView;



- (void)setNameKey:(NSString *)name AndValue:(NSString *)value;
- (void)setNameKey:(NSString *)name AndValue:(NSString *)value UseNext:(BOOL)next;


@end
