//
//  LocationEngine.m
//  wealth
//
//  Created by wangyingjie on 15/1/14.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import "LocationEngine.h"
#import "NSDictionary+Null.h"

#define kChinaTimeZone      8
#define kMorningHour        (9 - kChinaTimeZone)
#define kAfternoonHour      (12 - kChinaTimeZone)
#define kNightHour          (18 - kChinaTimeZone)

@implementation LocationInformation

- (NSString *)description {
    return [NSString stringWithFormat:@"经度:%@; 纬度:%@; 地址:%@", @(_longitude), @(_longitude), _address];
}

@end

@interface LocationEngine () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation LocationEngine

SYNTHESIZE_SINGLETON_FOR_CLASS(LocationEngine);

- (instancetype)init {
    self = [super init];
    if ( self ) {
        _mapView = [[MKMapView alloc] init];
        _geocoder = [[CLGeocoder alloc] init];
        
        _locationManager = [CLLocationManager updateManagerWithAccuracy:50.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionWhenInUse];
        [_locationManager startMonitoringSignificantLocationChanges];
        _locationManager.updateAccuracyFilter = kCLUpdateAccuracyFilterNone;
        _locationManager.updateLocationAgeFilter = kCLLocationAgeFilterNone;
    }
    return self;
}

- (void)setScheduledUpdateLocation:(BOOL)scheduledUpdateLocation {
    _scheduledUpdateLocation = scheduledUpdateLocation;
    if ( _scheduledUpdateLocation ) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];

        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
        NSDateComponents *comp = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
        comp.timeZone = [NSTimeZone defaultTimeZone];
        NSInteger hour = [comp hour];
        NSInteger min = [comp minute];
        NSInteger sec = [comp second];
        NSInteger delayTime = 0;
        if ( hour < kMorningHour ) {
            delayTime = (kMorningHour-hour) * 60 * 60 - min * 60 - sec;
        } else if ( hour < kAfternoonHour ) {
            delayTime = (kAfternoonHour-hour) * 60 * 60 - min * 60 - sec;
        } else if ( hour < kNightHour ) {
            delayTime = (kNightHour-hour) * 60 * 60 - min * 60 - sec;
        } else {
            delayTime = (24-hour+kMorningHour) * 60 * 60 - min * 60 - sec;
        }
        // 中国时区与格林尼治时间相差整整8个小时
        NSDate *dates = [date dateByAddingTimeInterval:(delayTime + kChinaTimeZone * 60 * 60)];
//        NSDate *dates = [date dateByAddingTimeInterval:(delayTime + 20)];
        UILocalNotification *localNoti = [[UILocalNotification alloc] init];
//        localNoti.alertAction = @"查看";
//        localNoti.alertBody = @"后台重启的位置更新";
        localNoti.soundName = UILocalNotificationDefaultSoundName;
        localNoti.userInfo = @{ @"scheduledUpdateLocation":dates };
        localNoti.fireDate = dates;
        localNoti.repeatInterval = NSDayCalendarUnit;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
    } else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.scheduledUpdateLocation = YES;

    BOOL ret = NO;
    if ( [launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey] ) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        if ([self respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            NSString *alwaysDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"];
            NSString *whenInUseDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"];
            if ( alwaysDescription ) {
                [self.locationManager requestAlwaysAuthorization];
            } else if ( whenInUseDescription ) {
                [self.locationManager requestWhenInUseAuthorization];
            } else {
                NSAssert([alwaysDescription length] || [whenInUseDescription length], @"NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription key not present in the info.plist. Please add it in order to recieve location updates");
            }
        }
#endif
        //这是iOS9中针对后台定位推出的新属性 不设置的话 可是会出现顶部蓝条的哦(类似热点连接)
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
//        if ( [self.locationManager respondsToSelector:@selector(allowsBackgroundLocationUpdates)]) {
//            self.locationManager.allowsBackgroundLocationUpdates = YES;
//        }
//#endif
        [self getLocationInformation:NO information:^(LocationInformation *info) {
            NSLog(@"getCustomerGpsInformation = %@", info);
        } error:^(NSString *error) {
            NSLog(@"位置权限受制");
        }];
        ret = YES;
    }
    return ret;
}

- (void)getLocationCoordinate:(BOOL)repeate location:(LocationBlock)locaiontBlock error:(LocationErrorBlock)errorBlock {
    if ( [CLLocationManager locationServicesEnabled] && [CLLocationManager isLocationUpdatesAvailable] ) {
//        @weakify(self);
        [_locationManager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
//            @strongify(self);
            if ( locaiontBlock ) {
                locaiontBlock(location.coordinate);
            }
            *stopUpdating = !repeate;
        }];
    } else {
        if ( errorBlock ) {
            errorBlock(@"位置权限受制");
        }
    }
}

- (void)getAddress:(BOOL)repeate address:(AddressBlock)addressBlock error:(LocationErrorBlock)errorBlock {
    if ( [CLLocationManager locationServicesEnabled] && [CLLocationManager isLocationUpdatesAvailable] ) {
        @weakify(self);
        [_locationManager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
            @strongify(self);
            
            CLLocationCoordinate2D coordinate = location.coordinate;
            MKCoordinateRegion region = {{0.,0.},{0.,0.}};
            region.center = coordinate;
            region.span.latitudeDelta = 0.01;
            region.span.longitudeDelta = 0.01;
            [self.mapView setRegion:region];
            
            [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                CLPlacemark *placemark = placemarks.firstObject;
                if ( addressBlock && placemark ) {
                    addressBlock([placemark.addressDictionary[@"FormattedAddressLines"] componentsJoinedByString:@", "]);
                }
            }];
            *stopUpdating = !repeate;
        }];
    } else {
        if ( errorBlock ) {
            errorBlock(@"位置权限受制");
        }
    }
}

- (void)getLocationInformation:(BOOL)repeate
                   information:(LocationInformationBlock)informationBlock
                         error:(LocationErrorBlock)errorBlock
{
    if ( [CLLocationManager locationServicesEnabled] && [CLLocationManager isLocationUpdatesAvailable] ) {
        @weakify(self);
        [_locationManager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
            @strongify(self);
            
            LocationInformation *info = [[LocationInformation alloc] init];
            info.location = location;
            info.latitude = location.coordinate.latitude;
            info.longitude = location.coordinate.longitude;
            
            CLLocationCoordinate2D coordinate = location.coordinate;
            MKCoordinateRegion region = {{0.,0.},{0.,0.}};
            region.center = coordinate;
            region.span.latitudeDelta = 0.01;
            region.span.longitudeDelta = 0.01;
            [self.mapView setRegion:region];
            
            [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                info.address = [[NSMutableArray alloc] initWithCapacity:placemarks.count];
                [placemarks enumerateObjectsUsingBlock:^(CLPlacemark *placemark, NSUInteger idx, BOOL *stop) {
                    if ( placemark ) {
                        [info.address addObject:[placemark.addressDictionary[@"FormattedAddressLines"] componentsJoinedByString:@", "]];
                    }
                }];
                if ( informationBlock ) {
                    informationBlock(info);
                }
            }];
            *stopUpdating = !repeate;
        }];
    } else {
        if ( errorBlock ) {
            errorBlock(@"位置权限受制");
        }
    }
}

@end
