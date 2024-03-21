//
//  ProductionListMode.h
//  wealth
//
//  Created by wangyingjie on 16/3/30.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "BaseModel.h"

@interface ProductionListMode : BaseModel

@property (nonatomic, assign) long long listId;         /**< 列表id*/
@property (nonatomic, assign) double annuaRate;         /**< 年化收益率*/
@property (nonatomic, assign) double minAmount;         /**< 最低出借额*/
@property (nonatomic, assign) long long period;         /**< 出借期限*/
@property (nonatomic, copy) NSString *productName;      /**< 名称*/
@property (nonatomic, copy) NSString *periodType;       /**< 天or月*/

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
