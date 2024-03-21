//
//  PushModel.h
//  wealth
//
//  Created by wangyingjie on 16/5/11.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "BaseModel.h"

@interface PushModel : BaseModel


@property (nonatomic, strong) NSString *pushTitle;
@property (nonatomic, strong) NSString *pushContent;
@property (nonatomic, strong) NSString *pushUrl;
@property (nonatomic, assign) long long pushId;
@property (nonatomic, assign) PushType pushtype;

- (id)initWithDictionary:(NSDictionary *)dictionary ;


@end
