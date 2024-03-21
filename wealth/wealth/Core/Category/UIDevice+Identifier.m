//
//  UIDevice+Identifier.m
//  wealth
//
//  Created by wangyingjie on 14/12/17.
//  Copyright (c) 2014年 puhui. All rights reserved.
//

#import "UIDevice+Identifier.h"
#import <CoreTelephony/CTCarrier.h> //添加获取客户端运营商 支持
#import <sys/sysctl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

#define kDeviceIdentifierID    [NSString stringWithFormat:@"%@_deviceIdentifierID", APP_BUNDEL_ID]


#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
                                    @implementation TT_FIX_CATEGORY_BUG_##name @end


static void * const kUIDeviceIdentifierIDKey     = (void*)&kUIDeviceIdentifierIDKey;

@implementation UIDevice (Identifier)

- (void)setDeviceIdentifierID:(NSString *)deviceIdentifierID {
    objc_setAssociatedObject(self, &kUIDeviceIdentifierIDKey, deviceIdentifierID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)deviceIdentifierID {
    NSString *identifierID = objc_getAssociatedObject(self, &kUIDeviceIdentifierIDKey);
    if ( identifierID == nil ) {
        identifierID = [UIDevice deviceIdentifierID];
        self.deviceIdentifierID = identifierID;
    }
    return identifierID;
}

+ (NSString *)deviceIdentifierID {
#if TARGET_IPHONE_SIMULATOR
    NSString *identifierID = [UserDefaultsWrapper userDefaultsObject:kDeviceIdentifierID];
    if ( identifierID == nil || [identifierID isEqualToString:@""] ) {
        identifierID = [Utility getUUID];
        [UserDefaultsWrapper setUserDefaultsObject:identifierID forKey:kDeviceIdentifierID];
    }
    return [identifierID copy];
#else
    NSString *identifierID = nil;
    @try {
        UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:[UICKeyChainStore defaultService]];
        if ( store ) {
            identifierID = store[kDeviceIdentifierID];
            if ( identifierID == nil || [identifierID isEqualToString:@""] ) {
                identifierID = [Utility getUUID];
                store[kDeviceIdentifierID] = identifierID;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"UICKeyChainStore error: %@", exception.reason);
    }
    @finally {
        return identifierID;
    }
#endif
}

+ (void)clearDeviceIdentifierID {
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:[UICKeyChainStore defaultService]];
    if ( store ) {
        NSString *identifierID = store[kDeviceIdentifierID];
        if ( identifierID ) {
            NSLog(@"clear identifierID");
            [store removeItemForKey:kDeviceIdentifierID];
        } else {
            NSLog(@"no identifierID");
        }
    }
}

+ (CGSize)deviceScreenSize {
    return [UIScreen mainScreen].currentMode.size;
}

+ (NSArray *)runningProcesses {
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    u_int miblen = 4;
    
    size_t size = 0;
    int st = sysctl(mib, miblen, NULL, &size, NULL, 0);
    if ( st != 0 ) {
        return nil;
    }
        
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    
    do {
        
        size += size / 10;
        newprocess = realloc(process, size);
        
        if (!newprocess){
            
            if (process){
                free(process);
            }
            
            return nil;
        }
        
        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
        
    } while (st == -1 && errno == ENOMEM);
    
    if (st == 0){
        
        if (size % sizeof(struct kinfo_proc) == 0){
            NSInteger nprocess = size / sizeof(struct kinfo_proc);
            if (nprocess){
                NSMutableArray * array = [[NSMutableArray alloc] init];
                for (NSInteger i = nprocess - 1; i >= 0; i--){
                    NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                    NSString * processCPU = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_estcpu];
                    double t = [[NSDate date] timeIntervalSince1970] - process[i].kp_proc.p_un.__p_starttime.tv_sec;
                    NSString * processUseTime = [[NSString alloc] initWithFormat:@"%f",t];
                    [array addObject:@{ @"ProcessID":processID,
                                        @"ProcessName":processName,
                                        @"ProcessCPU":processCPU,
                                        @"ProcessUseTime":processUseTime }];
                }
                
                free(process);
                return array;
            }
        }
    }
    
    if (process){
        free(process);
    }
    return nil;
}

+ (NSTimeInterval)runningTimeInterval {
    __block NSTimeInterval time = GET_RUNNING_TIME;

//#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
//    NSArray *running = [UIDevice runningProcesses];
//    [running enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ( [obj[@"ProcessName"] isEqualToString:APP_BUNDEL_NAME] ) {
//            time = [obj[@"ProcessUseTime"] doubleValue];
//        }
//    }];
//#endif

    return time;
}

+ (NSString *)codeResourcesPath {
    NSString *excutableName = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
    NSString *dirStr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *tmpPath = [dirStr stringByDeletingLastPathComponent];
    NSString *appPath = [[tmpPath stringByAppendingPathComponent:excutableName] stringByAppendingPathExtension:@"app"];
    NSString *sigPath = [[appPath stringByAppendingPathComponent:@"_CodeSignature"] stringByAppendingPathComponent:@"CodeResources"];
    return sigPath;
}

+ (NSString *)binaryPath {
    NSString *excutableName = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
    NSString *dirStr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *tmpPath = [dirStr stringByDeletingLastPathComponent];
    NSString *appPath = [[tmpPath stringByAppendingPathComponent:excutableName] stringByAppendingPathExtension:@"app"];
    NSString *binaryPath = [appPath stringByAppendingPathComponent:excutableName];
    return binaryPath;
}

+ (NSString *)carrierName {
    CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc] init];  //创建一个CTTelephonyNetworkInfo对象
    return networkStatus.subscriberCellularProvider.carrierName; //获取当前运营商描述
}

+ (NSString *)deviceIPAdress {
    NSString *address = @"0.0.0.0";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;

    success = getifaddrs(&interfaces);

    if (success == 0) { // 0 表示获取成功

        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }

            temp_addr = temp_addr->ifa_next;
        }
    }

    freeifaddrs(interfaces);
    return address;  
}

- (BOOL)isPad {
    static dispatch_once_t one;
    static BOOL pad;
    dispatch_once(&one, ^{
        pad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    });
    return pad;
}

- (BOOL)isSimulator {
    static dispatch_once_t one;
    static BOOL simu;
    dispatch_once(&one, ^{
        simu = NSNotFound != [[self model] rangeOfString:@"Simulator"].location;
    });
    return simu;
}

- (BOOL)isPirated {
    NSString * bundlePath = [[NSBundle mainBundle] bundlePath];
    /* SC_Info */
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/SC_Info", bundlePath]]) {
        return YES;
    }
    
    /* iTunesMetadata.​plist */
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/iTunesMetadata.​plist", bundlePath]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isJailbroken {
    static BOOL jailbroken = YES;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([self isSimulator]) { // Dont't check simulator
            jailbroken = NO;
            return;
        }
        
        // 尝试打开cydia应用注册的URL scheme
        NSURL *cydiaURL = [NSURL URLWithString:@"cydia://package/com.saurik.cydia"];
        if ([[UIApplication sharedApplication] canOpenURL:cydiaURL]) return;
        
        // 判断设备是否安装了如下越狱常用工具
        NSArray *paths = @[@"/Applications/Cydia.app",
                           @"/bin/bash",
                           @"/usr/sbin/sshd",
                           @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                           @"/private/var/lib/apt/",
                           @"/private/var/lib/cydia",
                           @"/private/var/stash"];
        for (NSString *path in paths) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return;
        }
        
        // 尝试读取应用列表
        NSArray *applist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/User/Applications/" error:nil];
        if (applist && applist.count > 0) return;
        
        // 尝试执行bash命令
        FILE *bash = fopen("/bin/bash", "r");
        if (bash != NULL) {
            fclose(bash);
            return;
        }
        
        // 尝试获取写权限
        NSString *path = [NSString stringWithFormat:@"/private/%@", [Utility getUUID]];
        if ([@"test" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:NULL]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            return;
        }
        
        jailbroken = NO;
    });
    return jailbroken;
}

- (BOOL)canMakePhoneCalls {
    __block BOOL can;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        can = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    });
    return can;
}

- (NSString *)machineModel {
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

- (NSString *)machineModelName {
    static dispatch_once_t one;
    static NSString *name;
    dispatch_once(&one, ^{
        NSString *model = [self machineModel];
        if ([model isEqualToString:@"iPhone1,1"]) name = @"iPhone 1G";
        else if ([model isEqualToString:@"iPhone1,2"]) name = @"iPhone 3G";
        else if ([model isEqualToString:@"iPhone2,1"]) name = @"iPhone 3GS";
        else if ([model isEqualToString:@"iPhone3,1"]) name = @"iPhone 4 (GSM)";
        else if ([model isEqualToString:@"iPhone3,2"]) name = @"iPhone 4";
        else if ([model isEqualToString:@"iPhone3,3"]) name = @"iPhone 4 (CDMA)";
        else if ([model isEqualToString:@"iPhone4,1"]) name = @"iPhone 4S";
        else if ([model isEqualToString:@"iPhone5,1"]) name = @"iPhone 5";
        else if ([model isEqualToString:@"iPhone5,2"]) name = @"iPhone 5";
        else if ([model isEqualToString:@"iPhone5,3"]) name = @"iPhone 5c";
        else if ([model isEqualToString:@"iPhone5,4"]) name = @"iPhone 5c";
        else if ([model isEqualToString:@"iPhone6,1"]) name = @"iPhone 5s";
        else if ([model isEqualToString:@"iPhone6,2"]) name = @"iPhone 5s";
        else if ([model isEqualToString:@"iPhone7,1"]) name = @"iPhone 6 Plus";
        else if ([model isEqualToString:@"iPhone7,2"]) name = @"iPhone 6";
        else if ([model isEqualToString:@"iPhone8,1"]) name = @"iPhone 6s";
        else if ([model isEqualToString:@"iPhone8,2"]) name = @"iPhone 6s Plus";
        
        else if ([model isEqualToString:@"iPod1,1"]) name = @"iPod 1";
        else if ([model isEqualToString:@"iPod2,1"]) name = @"iPod 2";
        else if ([model isEqualToString:@"iPod3,1"]) name = @"iPod 3";
        else if ([model isEqualToString:@"iPod4,1"]) name = @"iPod 4";
        else if ([model isEqualToString:@"iPod5,1"]) name = @"iPod 5";
        
        else if ([model isEqualToString:@"iPad1,1"]) name = @"iPad 1";
        else if ([model isEqualToString:@"iPad2,1"]) name = @"iPad 2 (WiFi)";
        else if ([model isEqualToString:@"iPad2,2"]) name = @"iPad 2 (GSM)";
        else if ([model isEqualToString:@"iPad2,3"]) name = @"iPad 2 (CDMA)";
        else if ([model isEqualToString:@"iPad2,4"]) name = @"iPad 2";
        else if ([model isEqualToString:@"iPad2,5"]) name = @"iPad mini 1";
        else if ([model isEqualToString:@"iPad2,6"]) name = @"iPad mini 1";
        else if ([model isEqualToString:@"iPad2,7"]) name = @"iPad mini 1";
        else if ([model isEqualToString:@"iPad3,1"]) name = @"iPad 3 (WiFi)";
        else if ([model isEqualToString:@"iPad3,2"]) name = @"iPad 3 (4G)";
        else if ([model isEqualToString:@"iPad3,3"]) name = @"iPad 3 (4G)";
        else if ([model isEqualToString:@"iPad3,4"]) name = @"iPad 4";
        else if ([model isEqualToString:@"iPad3,5"]) name = @"iPad 4";
        else if ([model isEqualToString:@"iPad3,6"]) name = @"iPad 4";
        else if ([model isEqualToString:@"iPad4,1"]) name = @"iPad Air";
        else if ([model isEqualToString:@"iPad4,2"]) name = @"iPad Air";
        else if ([model isEqualToString:@"iPad4,3"]) name = @"iPad Air";
        else if ([model isEqualToString:@"iPad4,4"]) name = @"iPad mini 2";
        else if ([model isEqualToString:@"iPad4,5"]) name = @"iPad mini 2";
        else if ([model isEqualToString:@"iPad4,6"]) name = @"iPad mini 2";
        else if ([model isEqualToString:@"iPad4,7"]) name = @"iPad mini 3";
        else if ([model isEqualToString:@"iPad4,8"]) name = @"iPad mini 3";
        else if ([model isEqualToString:@"iPad4,9"]) name = @"iPad mini 3";
        else if ([model isEqualToString:@"iPad5,3"]) name = @"iPad Air 2";
        else if ([model isEqualToString:@"iPad5,4"]) name = @"iPad Air 2";
        
        else if ([model isEqualToString:@"i386"]) name = @"Simulator x86";
        else if ([model isEqualToString:@"x86_64"]) name = @"Simulator x64";
        else name = model;
    });
    return name;
}

- (BOOL)iphone4 {
    return [self.machineModel isEqualToString:@"iPhone3,1"]
            || [self.machineModel isEqualToString:@"iPhone3,2"]
            || [self.machineModel isEqualToString:@"iPhone3,3"]
            || [self.machineModel isEqualToString:@"iPod4,1"];
}

- (BOOL)iphone4s {
    return [self.machineModel isEqualToString:@"iPhone4,1"];
}

- (BOOL)iphone5 {
    return [self.machineModel isEqualToString:@"iPhone5,1"]
            || [self.machineModel isEqualToString:@"iPhone5,2"]
            || [self.machineModel isEqualToString:@"iPhone5,3"]
            || [self.machineModel isEqualToString:@"iPhone5,4"]
            || [self.machineModel isEqualToString:@"iPhone6,1"]
            || [self.machineModel isEqualToString:@"iPhone6,2"]
            || [self.machineModel isEqualToString:@"iPod5,1"];;
}

- (BOOL)iphone6 {
    return [self.machineModel isEqualToString:@"iPhone7,2"]||[self.machineModel isEqualToString:@"iPhone8,1"];
}

- (BOOL)iphone6Plus {
    return [self.machineModel isEqualToString:@"iPhone7,1"]||[self.machineModel isEqualToString:@"iPhone8,2"];
}
@end
