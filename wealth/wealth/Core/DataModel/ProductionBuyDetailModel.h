//
//  ProductionBuyDetailModel.h
//  wealth
//
//  Created by wangyingjie on 16/4/6.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductionBuyDetailModel : BaseModel

@property (nonatomic, assign) long long productionId;       /**< */
@property (nonatomic, assign) double startAmount;           /**< 起始金额*/
@property (nonatomic, assign) double minAmount;             /**< 最小投资额*/
@property (nonatomic, assign) double maxAmount;             /**< 最大投资额*/
@property (nonatomic, assign) double sellerTotalSales;      /**< 销售金额*/
@property (nonatomic, assign) double expectedEarnings;      /**< 预计收益" w*/
@property (nonatomic, assign) double theAccountBalance;     /**< 账户余额*/
@property (nonatomic, assign) long long seller;             /**< 销售id*/
@property (nonatomic, assign) BOOL haveSales;               /**< 是否有销售*/
@property (nonatomic, copy) NSString *contractUrl;          /**< 合同url*/
@property (nonatomic, copy) NSString *sellerPicUrl;         /**< 销售头像*/
@property (nonatomic, copy) NSString *sellerName;           /**< 销售姓名*/
@property (nonatomic, copy) NSString *sellerPosition;       /**< 销售职位*/





- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
