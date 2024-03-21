//
//  wealthDataBase.h
//  wealth
//
//  Created by puhui on 14/12/10.
//  Copyright (c) 2014年 puhui. All rights reserved.
//

#import "AppDatabase.h"
#import "DataModel.h"

@interface wealthDataBase : AppDatabase

@property (nonatomic, strong) GCDQueue *dataBaseQueue;

@property (nonatomic, readonly) BOOL isInitialized;

- (instancetype)initWithMigrations:(NSString *)dir;

- (instancetype)initWithMigrations:(BOOL)loggingEnabled withDir:(NSString *)dir;

- (void)runMigrations;

@end
