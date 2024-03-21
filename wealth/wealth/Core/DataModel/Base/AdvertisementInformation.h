//
//  AdvertisementInformation.h
//  wealth
//
//  Created by 心冷如灰 on 15/12/23.
//  Copyright © 2015年 普惠金融. All rights reserved.
//

#import "BaseModel.h"

@interface AdvertisementInformation : BaseModel

@property (nonatomic, assign) NSInteger advertisementId;          /**< 广告图片id */
@property (nonatomic, copy) NSString *advertisementUrl;           /**< 广告图片地址Url */
@property (nonatomic, copy) NSString *advertisementDetailsUrl;    /**< 广告图片地址详情Url 为空的时候 就只有图片 */
@property (nonatomic, copy) NSString *advertisementName;          /**< 广告名称 */
@property (nonatomic, copy) NSString *pictureName;                /**< 图片名称 */

@end
