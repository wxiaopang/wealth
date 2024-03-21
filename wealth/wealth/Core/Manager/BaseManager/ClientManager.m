//
//  ClientManager.m
//  wealth
//
//  Created by wangyingjie on 15/2/28.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "ClientManager.h"

@interface ClientManager ()

// LBS位置服务
@property (nonatomic, strong) LocationEngine *locationEngine;

@property (nonatomic, strong) LocationInformation *locationInformation;

@end

@implementation ClientManager

SYNTHESIZE_SINGLETON_FOR_CLASS(ClientManager);

//@synthesize addressBookManager = _addressBookManager;
@synthesize loginManager = _loginManager;
@synthesize dataBaseManager = _dataBaseManager;
@synthesize customerManager = _customerManager;
@synthesize productionManager = _productionManager;
@synthesize userCenterManager = _userCenterManager;
@synthesize pushManager = _pushManager;
@synthesize messageManager = _messageManager;


- (instancetype)init {
    self = [super init];
    if ( self ) {
        // 缓存管理
        _pushManager = [[PushManager alloc] init];
        _loginManager = [[LoginManager alloc] init];
        _productionManager = [[ProductionManager alloc] init];
        _messageManager = [[MessageManager alloc] init];
    }
    return self;
}

- (LocationEngine *)locationEngine {
    if ( _locationEngine == nil ) {
        _locationEngine = [LocationEngine sharedLocationEngine];
    }
    return _locationEngine;
}

- (void)setUid:(long long)uid {
    if ( uid >= 0 ) {
        [UserDefaultsWrapper setUserDefaultsObject:@(uid) forKey:kLonginUserid];
//        [self.dataBaseManager initInformation];
        [self.dataBaseManager initInformationWithUid:uid];
        NSLog(@"打开数据库:%@", self.dataBaseManager.appDataBase.pathToDatabase);
        [self.messageManager registThePushDeviceToken];
    } else {
        [self.dataBaseManager clearInformation];
        [UserDefaultsWrapper removeUserDefaults:kLonginUserid];
    }
}

- (long long)uid {
    return [[UserDefaultsWrapper userDefaultsObject:kLonginUserid] longLongValue];
}

- (LoginManager *)loginManager {
    @synchronized(self) {
        if ( _loginManager == nil ) {
            _loginManager = [[LoginManager alloc] init];
        }
        return _loginManager;
    }
}

//- (AddressBookManager *)addressBookManager {
//    @synchronized(self) {
//        if ( _addressBookManager == nil ) {
//            _addressBookManager = [[AddressBookManager alloc] init];
//        }
//        return _addressBookManager;
//    }
//}

- (DataBaseManager *)dataBaseManager {
    @synchronized(self) {
        if ( _dataBaseManager == nil ) {
            _dataBaseManager = [[DataBaseManager alloc] init];
        }
        return _dataBaseManager;
    }
}

- (CustomerManager *)customerManager {
    @synchronized(self) {
        if ( _customerManager == nil ) {
            _customerManager = [[CustomerManager alloc] init];
        }
        return _customerManager;
    }
}

- (ProductionManager *)productionManager {
    @synchronized(self) {
        if ( _productionManager == nil ) {
            _productionManager = [[ProductionManager alloc] init];
        }
        return _productionManager;
    }
}

- (UserCenterManager *)userCenterManager {
    @synchronized(self) {
        if ( _userCenterManager == nil ) {
            _userCenterManager = [[UserCenterManager alloc] init];
        }
        return _userCenterManager;
    }
}

- (MessageManager *)messageManager {
    @synchronized(self) {
        if ( _messageManager == nil ) {
            _messageManager = [[MessageManager alloc] init];
        }
        return _messageManager;
    }
}

- (void)initInformation {
    // 打开数据库
    [self.dataBaseManager initInformation];
    if ( self.dataBaseManager.appDataBase ) {
        
        [self.loginManager initInformation];
    
        [self.customerManager initInformation];
        
        [self.productionManager initInformation];
        
        [self.userCenterManager initInformation];
        
        [self.pushManager initInformation];
        
        [self.messageManager initInformation];
        
        // todo: 其他manager初始化数据
    }
}

- (void)clearInformation {
    // 清空之前的http请求
    [GET_HTTP_API.manager.operationQueue cancelAllOperations];
    
    [self.loginManager clearInformation];

    [self.customerManager clearInformation];
    
    [self.productionManager clearInformation];
    
    [self.userCenterManager clearInformation];
    
    [self.pushManager clearInformation];
    
    [self.messageManager clearInformation];
    
    self.uid = 0; // 此处清理了数据库缓存信息
}

- (void)submitCustomerPushAliasMethod {
//    NSString *deviceToken = GET_CLIENT_MANAGER.pushManager.deviceToken;
//    if ( deviceToken && deviceToken.length > 0 ) {
//        [GET_HTTP_API postWithModule:@"customerDataController"
//                           interface:@"submitCustomerPushAliasMethod"
//                                body:@{ @"alias":deviceToken }
//                            complete:^(id JSONResponse, NSError *error)
//        {
//             if ( error ) {
//                 NSLog(@"服务户端出错 %@", error.localizedDescription);
//             } else {
//                 NSInteger code = [JSONResponse[@"code"] integerValue];
//                 if ( code == ResponseErrorCode_OK ) {
//                     NSLog(@"上传 deviceToken = %@ 成功", deviceToken);
//                 } else {
//                     NSLog(@"上传 deviceToken 失败");
//                 }
//             }
//        }];
//    }
}

- (void)submitCustomerGpsMethod {
    // 获取位置信息
    @weakify(self);
    [self.locationEngine getLocationInformation:NO information:^(LocationInformation *info) {
        @strongify(self);
        self.locationInformation = info;
        
        // 上传友盟位置信息
//        [GET_UM_ANALYTICS setLocation:info.location];
        
        // 上传位置信息
        [GET_HTTP_API postWithModule:@"customerDataController"
                           interface:@"submitCustomerGpsMethod"
                                body:@{
                                       @"longitude":[@(info.longitude) stringValue],
                                       @"latitude":[@(info.latitude) stringValue],
                                       @"address":info.address.firstObject?info.address.firstObject:kNullStr,
                                      }
                            complete:nil];
    } error:^(NSString *error) {
//        id alertAuthorLocation = [UserDefaultsWrapper userDefaultsObject:kAlertAuthorLocation];
//        if ( alertAuthorLocation == nil ) {
//            [UserDefaultsWrapper setUserDefaultsObject:@(YES) forKey:kAlertAuthorLocation];
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                message:@"亲爱的用户，本程序需要使用您的位置信息，如您禁止使用，将无法申请借款。"
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"知道了"
//                                                      otherButtonTitles:nil];
//            [alertView showWithCompletion:nil];
//        }
    }];
}

- (void)getCustomerGpsInformation {
    // 获取位置信息
    @weakify(self);
    [self.locationEngine getLocationInformation:NO information:^(LocationInformation *info) {
        @strongify(self);
        
//        [info.address insertObject:kNullStr atIndex:0];
        self.locationInformation = info;
        
        NSLog(@"getCustomerGpsInformation = %@", info);
        
        // 上传友盟位置信息
//        [GET_UM_ANALYTICS setLocation:info.location];
    } error:^(NSString *error) {
//        id alertAuthorLocation = [UserDefaultsWrapper userDefaultsObject:kAlertAuthorLocation];
//        if ( alertAuthorLocation == nil ) {
//            [UserDefaultsWrapper setUserDefaultsObject:@(YES) forKey:kAlertAuthorLocation];
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                message:@"亲爱的用户，本程序需要使用您的位置信息，如您禁止使用，将无法申请借款。"
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"知道了"
//                                                      otherButtonTitles:nil];
//            [alertView showWithCompletion:nil];
//        }
    }];
}

//- (void)submitMobileContactsMethod {
//    NSArray *increased = self.addressBookManager.increase;
//    if ( increased && increased.count > 0 ) {
//        // 每次程序启动只上传一次通讯录信息,上传完立即释放缓存
//        [self.addressBookManager clearInformation];
//        
//        dispatch_queue_t queue_t = self.addressBookManager.savaQueue.dispatchQueue;
//        dispatch_async(self.addressBookManager.queue.dispatchQueue, ^(){
//            NSMutableArray *mobileContacts = [[NSMutableArray alloc] initWithCapacity:increased.count];
//            [increased enumerateObjectsUsingBlock:^(AddressBookModel *addressBook, NSUInteger idx, BOOL *stop) {
//                NSArray *phoneLabels = [addressBook getPhoneLabels];
//                if ( phoneLabels && phoneLabels.count > 0 ) {
//                    [phoneLabels enumerateObjectsUsingBlock:^(PhoneLableModel *phoneLable, NSUInteger idx, BOOL *stop) {
//                        [mobileContacts addObject:@{ @"recordID":@(addressBook.recordID),
//                                                     @"name":addressBook.name,
//                                                     @"mobile":phoneLable.value }];
//                    }];
//                }
//            }];
//            
//            // 分批上传通讯录
//            NSUInteger count = mobileContacts.count / kAddressBookContactSize;
//            if ( mobileContacts.count % kAddressBookContactSize ) {
//                count++;
//            }
//            
//            dispatch_semaphore_t semaphore_t = dispatch_semaphore_create(0);
//            for (NSInteger idx = 0; idx < count; idx++) {
//                NSUInteger loc = idx * kAddressBookContactSize;
//                NSUInteger len = ((loc + kAddressBookContactSize) > mobileContacts.count)
//                                    ? (mobileContacts.count - loc)
//                                    : kAddressBookContactSize;
//                NSArray *tmp = [mobileContacts subarrayWithRange:NSMakeRange(loc, len)];
//
//                //TODO:此处有个bug:如果某条通讯录电话数超过每批次上传数量(kAddressBookContactSize)，则大于的部分会数据丢失
//                // 准备上传的参数
//                NSMutableArray *tasks = [[NSMutableArray alloc] initWithCapacity:0];
//                NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:0];
//                [tmp enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
//                    NSInteger recordID = [obj[@"recordID"] integerValue];
//                    [items addObject:@{ @"name":obj[@"name"], @"mobile":obj[@"mobile"] }];
//                    [increased enumerateObjectsUsingBlock:^(AddressBookModel *addressBook, NSUInteger idx, BOOL *stop) {
//                        if ( addressBook.recordID == recordID ) {
//                            [tasks addObject:addressBook];
//                            *stop = YES;
//                        }
//                    }];
//                }];
//                
//                [GET_HTTP_API postWithModule:@"customerDataController"
//                                   interface:@"submitMobileContactsMethod"
//                                        body:@{ @"items":items }
//                                    complete:^(id JSONResponse, NSError *error)
//                 {
//                     if ( error ) {
//                     } else {
//                         // 缓存已经上传成功的通讯录至本地plist文件(以追加方式存储)
//                         dispatch_barrier_async(queue_t, ^{
//                             [AddressBookModel appendSava:tasks];
//                         });
//                     }
//                     dispatch_semaphore_signal(semaphore_t);
//                 }];
//                dispatch_semaphore_wait(semaphore_t, DISPATCH_TIME_FOREVER);
//            }
//        });
//    }
//}

- (void)submitMobileRecordsMethod {
    // todo: IPhone 手机不支持获取通话记录信息
}

- (void)getRSAPublicKey:(void(^)(BOOL isSuccessed))completion {
    [GET_HTTP_API postWithModule:@"publicKeyController"
                       interface:@"getPublicKeyMethod"
                            body:nil
                        complete:^(id JSONResponse, NSError *error)
    {
        BOOL isSuccessed = NO;
        if ( error ) {
            NSLog(@"服务户端出错 %@", error.localizedDescription);
        } else {
            NSInteger code = [JSONResponse[@"code"] integerValue];
            if ( code == ResponseErrorCode_OK ) {
                if ([JSONResponse[@"body"] isKindOfClass:[NSDictionary class]] && ((NSDictionary *)JSONResponse[@"body"]).count > 0) {
                    isSuccessed = YES;
                    // 缓存RSA加密公钥
                    NSString *pukey = JSONResponse[@"body"][@"puKey"];
                    if ( pukey ) {
                        [UserDefaultsWrapper setUserDefaultsObject:pukey forKey:kRSAPublicKey];
                    }
                }
            }
        }
         
        if ( completion ) {
            completion(isSuccessed);
        }
    }];
}

- (void)getVersionMethod:(VersionInformationCallBack)completion {
    [GET_HTTP_API postWithModule:@"AppVersion"
                       interface:@"getVersionInfo"
                            body:@{@"version":APP_SERVER_VERSION}
                        complete:^(id JSONResponse, NSError *error)
     {
         VersionInformation *versionInformation = [[VersionInformation alloc] init];
         if ( error ) {
//             versionInformation.memo = error.localizedDescription;
         } else {
             NSInteger code = [JSONResponse[@"code"] integerValue];
             if ( code == ResponseErrorCode_OK ) {
                 if ([JSONResponse[@"body"] isKindOfClass:[NSDictionary class]]  && ((NSDictionary *)JSONResponse[@"body"]).count > 0) {
                     versionInformation = [[VersionInformation alloc] initWithDictionary:JSONResponse[@"body"]];
                 } else {
                     versionInformation.updateDoc = kNetWorkError;
                 }
             } else {
                 versionInformation.updateDoc = JSONResponse[@"msg"] ? JSONResponse[@"msg"] : kNetWorkError;
             }
         }
         
         if ( completion ) {
             completion(versionInformation);
         }
     }];
}

- (void)getSystemTimeMethod:(SystemTimeType)type {
    // 首先获取位置信息
    [self getCustomerGpsInformation];
    
//    @weakify(self);
    // 再获取服务器时间
    [GET_HTTP_API postWithModule:@"systemTimeController"
                       interface:@"getSystemTimeMethod"
                            body:nil
                        complete:^(id JSONResponse, NSError *error)
    {
//        @strongify(self);
        if ( error ) {
            NSLog(@"服务户端出错 %@", error.localizedDescription);
        } else {
            NSInteger code = [JSONResponse[@"code"] integerValue];
            if ( code == ResponseErrorCode_OK ) {
                if ([JSONResponse[@"body"] isKindOfClass:[NSDictionary class]]  && ((NSDictionary *)JSONResponse[@"body"]).count > 0) {
                    // 缓存服务器当前时间
                    NSTimeInterval time = [JSONResponse[@"body"][@"currentTime"] doubleValue];
                    if ( time == 0 ) {
                        time = [[NSDate date] timeIntervalSince1970];
                    }
                }
            }
        }
    }];
}

- (void)getSystemTimeByString:(NSString *)text {
    if ( [text isEqualToString:@"基础"] ) {
        [self getSystemTimeMethod:SystemTimeType_IdentityInformation_base];
    } else if ( [text isEqualToString:@"居住"] ) {
        [self getSystemTimeMethod:SystemTimeType_IdentityInformation_living];
    } else if ( [text isEqualToString:@"资产"] ) {
        [self getSystemTimeMethod:SystemTimeType_IdentityInformation_property];
    } else if ( [text isEqualToString:@"房产"] ) {
        [self getSystemTimeMethod:SystemTimeType_IdentityInformation_house];
    } else if ( [text isEqualToString:@"收入"] ) {
        [self getSystemTimeMethod:SystemTimeType_IdentityInformation_income];
    } else if ( [text isEqualToString:@"经营"] ) {
        [self getSystemTimeMethod:SystemTimeType_IdentityInformation_operate];
    } else {
        
    }
}

// 获取省份信息
- (void)getProvinceMethod:(void(^)(NSArray *provinces, NSString *errMsg))callback {
    [GET_HTTP_API postWithModule:@"systemRegionsDataController"
                       interface:@"getProvinceMethod"
                            body:nil
                        complete:^(id JSONResponse, NSError *error)
     {
         if ( error ) {
             if ( callback ) {
                 callback(nil, kNetWorkError);
             }
         } else {
             NSInteger code = [JSONResponse[@"code"] integerValue];
             if ( code == ResponseErrorCode_OK ) {
                 NSMutableArray *provinceArray = [NSMutableArray array];
                 if ([JSONResponse[@"body"] isKindOfClass:[NSDictionary class]]  && ((NSDictionary *)JSONResponse[@"body"]).count > 0) {
                     for (NSDictionary *provinceDic in JSONResponse[@"body"][@"items"]) {
                         CityModel *provinceModel = [[CityModel alloc] initWithDictionary:provinceDic];
                         [provinceArray insertObject:provinceModel atIndex:0];
                     }
                 }
                 if ( callback ) {
                     callback(provinceArray, nil);
                 }
             } else {
                 if ( callback ) {
                     callback(nil, JSONResponse[@"msg"] ? JSONResponse[@"msg"] : kNetWorkError);
                 }
             }
         }
     }];
}

// 获取城市信息
- (void)getCityMethod:(NSString *)regionsCode
             complete:(void(^)(NSArray *citys, NSString *errMsg))completion
{
    [GET_HTTP_API postWithModule:@"systemRegionsDataController"
                       interface:@"getCityMethod"
                            body:@{ @"provinceCode":regionsCode }
                        complete:^(id JSONResponse, NSError *error)
     {
         if ( error ) {
             if ( completion ) {
                 completion(nil, kNetWorkError);
             }
         } else {
             NSInteger code = [JSONResponse[@"code"] integerValue];
             if ( code == ResponseErrorCode_OK ) {
                 NSMutableArray *cityArray = [NSMutableArray array];
                 if ([JSONResponse[@"body"] isKindOfClass:[NSDictionary class]]  && ((NSDictionary *)JSONResponse[@"body"]).count > 0) {
                     for (NSDictionary *cityDic in JSONResponse[@"body"][@"items"]) {
                         CityModel *cityModel = [[CityModel alloc] initWithDictionary:cityDic];
                         [cityArray insertObject:cityModel atIndex:0];
                     }
                 }
                 if ( completion ) {
                     completion(cityArray, nil);
                 }
             } else {
                 if ( completion ) {
                     completion(nil, JSONResponse[@"msg"] ? JSONResponse[@"msg"] : kNetWorkError);
                 }
             }
         }
     }];
}

// 获取区域信息
- (void)getDistMethod:(NSString *)cityCode
             complete:(void(^)(NSArray *dists, NSString *errMsg))completion
{
    [GET_HTTP_API postWithModule:@"systemRegionsDataController"
                       interface:@"getDistMethod"
                            body:@{ @"cityCode":cityCode }
                        complete:^(id JSONResponse, NSError *error)
     {
         if ( error ) {
             if ( completion ) {
                 completion(nil, kNetWorkError);
             }
         } else {
             NSInteger code = [JSONResponse[@"code"] integerValue];
             if ( code == ResponseErrorCode_OK ) {
                 NSMutableArray *distArray = [NSMutableArray array];
                 for (NSDictionary *distDic in JSONResponse[@"body"][@"items"]) {
                     CityModel *distModel = [[CityModel alloc] initWithDictionary:distDic];
                     [distArray insertObject:distModel atIndex:0];
                 }
                 if ( completion ) {
                     completion(distArray, nil);
                 }
             } else {
                 if ( completion ) {
                     completion(nil, JSONResponse[@"msg"] ? JSONResponse[@"msg"] : kNetWorkError);
                 }
             }
         }
     }];
}

- (void)manualRelogon:(dispatch_block_t)block {
    self.loginManager.status = LoginStatus_logout;
    
    [self clearInformation];
    
    if (block) { block(); }
}


//resetUserAgent(H5需求)
- (void)saveOriginalUserAgent:(NSString *)originalUserAgent {
    [[NSUserDefaults standardUserDefaults] setValue:originalUserAgent forKey:kOriginalUserAgent];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getOriginalUserAgent {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kOriginalUserAgent];
}

- (void)setOriginalUserAgent {
    if ([self getOriginalUserAgent]) {
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":[self getOriginalUserAgent]}];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setIQianJinUserAgent {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":[NSString stringWithFormat:@"%@ %@",[self getOriginalUserAgent],@"puhuiWeath"]}];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)clearCacheTheDocument{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
    }
    self.uid = 0;
}

- (BOOL)isFileExitsAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath isDirectory:NULL]) {
        return YES;
    }
    return NO;
}



#pragma mark -- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex == 1 ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

@end
