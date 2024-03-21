//
//  MessageDetailModel.h
//  wealth
//
//  Created by wangyingjie on 16/5/17.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "BaseModel.h"

@interface MessageDetailModel : BaseModel


@property (nonatomic, copy) NSString *msgTitle;
@property (nonatomic, copy) NSString *msgPaper;
@property (nonatomic, copy) NSString *msgTime;
@property (nonatomic, copy) NSString *msgDetail;
@property (nonatomic, assign) NSInteger msgType;


- (id)initWithDictionary:(NSDictionary *)dictionary ;



@end
