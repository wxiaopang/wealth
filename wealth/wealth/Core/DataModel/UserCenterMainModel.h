//
//  UserCenterMainModel.h
//  wealth
//
//  Created by wangyingjie on 16/4/8.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "BaseModel.h"

@interface UserCenterMainModel : BaseModel


@property (nonatomic, copy) NSString *uri;           /**< 我的出借访问地址*/
@property (nonatomic, assign) long long massageTotalCount;


- (id)initWithDictionary:(NSDictionary *)dictionary;


@end
