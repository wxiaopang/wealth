//
//  AFNetworkReachabilityManager+Technology.h
//  wealth
//
//  Created by wangyingjie on 15/12/23.
//  Copyright © 2015年 普惠金融. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, NetworkReachabilityStatusReachable) {
    NetworkReachabilityStatusReachableNone,
    NetworkReachabilityStatusReachableViaWiFi,
    NetworkReachabilityStatusReachableVia4G,
    NetworkReachabilityStatusReachableVia3G,
    NetworkReachabilityStatusReachableVia2G,
    NetworkReachabilityStatusReachableViaOther
};

@interface AFNetworkReachabilityManager (Technology)

- (NetworkReachabilityStatusReachable)currentNetworkReachabilityStatus;

@end
