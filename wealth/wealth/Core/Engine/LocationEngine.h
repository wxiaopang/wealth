//
//  LocationEngine.h
//  wealth
//
//  Created by wangyingjie on 15/1/14.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationInformation : NSObject

// 纬度
@property (nonatomic, assign) CLLocationDegrees latitude;

// 经度
@property (nonatomic, assign) CLLocationDegrees longitude;

// Represents a geographical coordinate along with accuracy and timestamp information.
@property (nonatomic, strong) CLLocation *location;

// 地址
@property (nonatomic, strong) NSMutableArray *address;

@end

typedef void (^LocationBlock)(CLLocationCoordinate2D locationCorrrdinate);
typedef void (^AddressBlock)(NSString *address);
typedef void (^LocationInformationBlock)(LocationInformation *info);
typedef void (^LocationErrorBlock) (NSString *error);

@interface LocationEngine : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(LocationEngine);

/**
 *    本地调度更新位置信息
 */
@property (nonatomic, assign) BOOL scheduledUpdateLocation;

/**
 *    重启加载位置信息
 *
 *    @param application   重启app对象
 *    @param launchOptions 加载参数
 *
 *    @return 是否成功
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/**
 *  获取坐标
 *
 *  @param locaiontBlock locaiontBlock description
 *  @param errorBlock errorBlock description
 */
- (void)getLocationCoordinate:(BOOL)repeate location:(LocationBlock)locaiontBlock error:(LocationErrorBlock)errorBlock;

/**
 *  获取详细地址
 *
 *  @param addressBlock addressBlock description
 *  @param errorBlock errorBlock description
 */
- (void)getAddress:(BOOL)repeate address:(AddressBlock)addressBlock error:(LocationErrorBlock)errorBlock;

/**
 *  获取位置信息
 *
 *  @param addressBlock addressBlock description
 *  @param errorBlock errorBlock description
 */
- (void)getLocationInformation:(BOOL)repeate
                   information:(LocationInformationBlock)informationBlock
                         error:(LocationErrorBlock)errorBlock;

@end
