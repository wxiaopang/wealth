//
//  AFNetworkReachabilityManager+Technology.m
//  wealth
//
//  Created by wangyingjie on 15/12/23.
//  Copyright © 2015年 普惠金融. All rights reserved.
//

#import "AFNetworkReachabilityManager+Technology.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>  //为判断网络制式的主要文件

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end

@implementation AFNetworkReachabilityManager (Technology)

- (NetworkReachabilityStatusReachable)currentNetworkReachabilityStatus {
    NetworkReachabilityStatusReachable ret = NetworkReachabilityStatusReachableNone;
    if ( self.isReachable ) {
        if ( self.reachableViaWiFi ) {
            ret = NetworkReachabilityStatusReachableViaWiFi;
        } else if ( self.reachableViaWWAN ) {
            CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc]init];  //创建一个CTTelephonyNetworkInfo对象
            NSString *currentStatus = networkStatus.currentRadioAccessTechnology; //获取当前网络描述
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]){
                //GPRS网络
                ret = NetworkReachabilityStatusReachableVia2G;
            } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]){
                //2.75G的EDGE网络
                ret = NetworkReachabilityStatusReachableVia2G;
            } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                //3G WCDMA网络
                ret = NetworkReachabilityStatusReachableVia3G;
            } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                //3.5G网络
                ret = NetworkReachabilityStatusReachableVia3G;
            } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                //3.5G网络
                ret = NetworkReachabilityStatusReachableVia3G;
            } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                //CDMA2G网络
                ret = NetworkReachabilityStatusReachableVia2G;
            } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                //CDMA的EVDORev0(应该算3G吧?)
                ret = NetworkReachabilityStatusReachableVia3G;
            } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                //CDMA的EVDORevA(应该也算3G吧?)
                ret = NetworkReachabilityStatusReachableVia3G;
            } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                //CDMA的EVDORev0(应该还是算3G吧?)
                ret = NetworkReachabilityStatusReachableVia3G;
            } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                //HRPD网络
                ret = NetworkReachabilityStatusReachableVia3G;
            } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                //LTE4G网络
                ret = NetworkReachabilityStatusReachableVia4G;
            }
        }
    }
    return ret;
}

@end
