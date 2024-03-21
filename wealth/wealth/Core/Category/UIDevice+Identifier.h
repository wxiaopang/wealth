//
//  UIDevice+Identifier.h
//  wealth
//
//  Created by wangyingjie on 14/12/17.
//  Copyright (c) 2014年 puhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Identifier)

@property (nonatomic, copy) NSString *deviceIdentifierID;

+ (NSString *)deviceIdentifierID;

+ (void)clearDeviceIdentifierID;

+ (CGSize)deviceScreenSize;

+ (NSArray *)runningProcesses;

+ (NSTimeInterval)runningTimeInterval;

+ (NSString *)codeResourcesPath;

+ (NSString *)binaryPath;

+ (NSString *)carrierName;

+ (NSString *)deviceIPAdress;

- (BOOL)isPirated;

- (BOOL)isJailbroken;

- (BOOL)isSimulator;

- (BOOL)canMakePhoneCalls;

- (NSString *)machineModel;

- (NSString *)machineModelName;

- (BOOL)iphone4;

- (BOOL)iphone4s;

- (BOOL)iphone5;

- (BOOL)iphone6;

- (BOOL)iphone6Plus;

@end
