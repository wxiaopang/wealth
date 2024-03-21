//
//  CityModel.h
//  wealth
//
//  Created by yangzhaofeng on 15/3/31.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "BaseModel.h"

@interface CityModel : BaseModel

@property (nonatomic, copy) NSString *regionsCode;   /**< 城市编码 */
@property (nonatomic, copy) NSString *regionsName;   /**< 城市名称 */
@property (nonatomic, copy) NSString *parentCode;    /**< 父级编码 */

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
