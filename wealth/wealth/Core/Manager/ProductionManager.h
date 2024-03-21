//
//  ProductionManager.h
//  wealth
//
//  Created by wangyingjie on 16/3/30.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^ProductionManagerCallBack)(NSString *errMsg);

@interface ProductionManager : NSObject


@property (nonatomic, strong) NSMutableArray *productionList;   /**< */
@property (nonatomic, strong) ProductionBuyDetailModel *productionBuyModel;   /**< */
@property (nonatomic, assign) long long code;   /**< */




/**
 *    初始化消息信息
 */
- (void)initInformation;

/**
 *    清空消息信息
 */
- (void)clearInformation;

/**
 *  获取产品列表
 *
 *  @param completion 信息回调
 */
- (void)getProductionListComplete:(ProductionManagerCallBack)completion;
/**
 *  联系理财师
 *
 *  @param completion 信息回调
 */
- (void)callTheManagerComplete:(ProductionManagerCallBack)completion;
/**
 *  获取理财产品购买信息
 *
 *  @param pId        产品Id
 *  @param completion 信息回调
 */
- (void)getProductionBuyDetailWithProductionId:(long long)pId Complete:(ProductionManagerCallBack)completion;
/**
 *  提交确定出借
 *
 *  @param pId        产品ID
 *  @param amount     出借金额
 *  @param employeeNo 客户经理编号（不填为@""）
 *  @param completion 信息回调
 */
- (void)submitProductionBuyMessageWithProductionId:(long long)pId AndAmount:(double)amount AndEmployeeNo:(NSString *)employeeNo Complete:(ProductionManagerCallBack)completion;
/**
 *  获取销售信息
 */
- (void)getSalesMessage;



@end
