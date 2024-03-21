//
//  BankMessageModel.h
//  wealth
//
//  Created by wangyingjie on 16/4/20.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "BaseModel.h"

@interface BankMessageModel : BaseModel

@property (nonatomic, assign) BOOL isBankList;
@property (nonatomic, copy) NSString *cardNumber;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *code;


@end
