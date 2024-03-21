//
//  DataBaseManager.m
//  wealth
//
//  Created by wangyingjie on 15/3/5.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import "DataBaseManager.h"

@interface DataBaseManager () {
    wealthDataBase *_appDataBase;
}

@end

@implementation DataBaseManager

- (instancetype)init {
    self = [super init];
    if ( self ) {

    }
    return self;
}

- (wealthDataBase *)appDataBase {
    if ( _appDataBase == nil ) { [self initInformation]; }
    return _appDataBase;
}

- (void)initInformation {
    if ( _appDataBase == nil ) {
        long long uid = kClientManagerUid;
        if ( uid > 0 ) {
            _appDataBase = [[wealthDataBase alloc] initWithMigrations:[NSString stringWithFormat:@"%@", @(uid)]];
            // 初始化数据库
            [_appDataBase runMigrations];
        } else {
            _appDataBase = nil;
        }
    }
}

- (void)initInformationWithUid:(long long)userId {
    if ( _appDataBase == nil ) {
        long long uid = userId;
        if ( uid > 0 ) {
            _appDataBase = [[wealthDataBase alloc] initWithMigrations:[NSString stringWithFormat:@"%@", @(uid)]];
            // 初始化数据库
            [_appDataBase runMigrations];
        } else {
            _appDataBase = nil;
        }
    }
}

- (void)clearInformation {
    _appDataBase = nil;
}

@end
