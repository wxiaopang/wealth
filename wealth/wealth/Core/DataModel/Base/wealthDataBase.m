//
//  wealthDataBase.m
//  wealth
//
//  Created by puhui on 14/12/10.
//  Copyright (c) 2014年 puhui. All rights reserved.
//

#import "wealthDataBase.h"
#import "DataModel.h"

#define ENABLE_SQLLITE_ENCRYPT
#define kEnableDataBaseLog  NO
//#define kEnableDataBaseLog  YES

static NSString *const kwealthDataBaseName = @"wealthDataBase.sqlite3";

@interface wealthDataBase ()

@property (nonatomic, strong) NSMutableArray *models;

-(NSUInteger)databaseVersion;
-(void)setDatabaseVersion:(NSUInteger)newVersionNumber;

-(void)createApplicationPropertiesTable;

@end

@implementation wealthDataBase

- (instancetype)initWithMigrations:(NSString *)dir {
    return [self initWithMigrations:kEnableDataBaseLog withDir:dir];
}

- (instancetype)initWithMigrations:(BOOL)loggingEnabled withDir:(NSString *)dir {
    // 数据库路径
    NSString *fileName = kwealthDataBaseName;
    if ( dir.length > 0 ) {
        [PathEngine createPath:[[PathEngine getDocumentPath] stringByAppendingPathComponent:dir]];
        fileName = [dir stringByAppendingPathComponent:fileName];
    }
    self = [super initWithFileName:fileName];
    if ( self ) {
        _dataBaseQueue = [[GCDQueue alloc] initConcurrent];
        // 配置数据库
        [MojoModel setDatabase:self];
        // 开启数据库log
        [self setLogging:loggingEnabled];
        // 初始化数据库
        [self runMigrations];
        _isInitialized = YES;
    }
    return self;
}

-(void)runMigrations {
    [self beginTransaction];
    
    // Turn on Foreign Key support
    [self executeSql:@"PRAGMA foreign_keys = ON"];
    
    NSArray *tableNames = [self tableNames];
    
    if (![tableNames containsObject:@"ApplicationProperties"]) {
        [self createApplicationPropertiesTable];
    }
    
//    [self updateToDatabaseV2:tableNames];

//    [self updateToDatabaseV3:tableNames];
//
//    [self updateToDatabaseV4:tableNames];
//
//    [self updateToDatabaseV5:tableNames];
//
//    [self updateToDatabaseV6:tableNames];
    
    [self commit];
}

#pragma mark - Migration Steps

- (void)createApplicationPropertiesTable {
    [self executeSql:@"create table ApplicationProperties (primaryKey integer primary key autoincrement, name text, value integer)"];
    [self executeSql:@"insert into ApplicationProperties (name, value) values('databaseVersion', 1)"];
}


#pragma mark - Convenience Methods

-(void)updateApplicationProperty:(NSString *)propertyName value:(id)value {
    [self executeSqlWithParameters:@"UPDATE ApplicationProperties SET value = ? WHERE name = ?", value, propertyName, nil];
}

-(id)getApplicationProperty:(NSString *)propertyName {
    NSArray *rows = [self executeSqlWithParameters:@"SELECT value FROM ApplicationProperties WHERE name = ?", propertyName, nil];
    if ([rows count] == 0) {
        return nil;
    }
    id object = [[rows lastObject] objectForKey:@"value"];
    if ([object isKindOfClass:[NSString class]]) {
        object = [NSNumber numberWithInteger:[(NSString *)object integerValue]];
    }
    return object;
}

-(void)setDatabaseVersion:(NSUInteger)newVersionNumber {
    return [self updateApplicationProperty:@"databaseVersion" value:[NSNumber numberWithUnsignedInteger:newVersionNumber]];
}

-(NSUInteger)databaseVersion {
    return [[self getApplicationProperty:@"databaseVersion"] unsignedIntegerValue];
}

#ifdef ENABLE_SQLLITE_ENCRYPT

-(void)open {
    NSLog(@"sqlite3 lib version: %s", sqlite3_libversion());

    if (sqlite3_threadsafe() > 0) {
        int retCode = sqlite3_config(SQLITE_CONFIG_SERIALIZED);
        if (retCode == SQLITE_OK) {
            NSLog(@"Can now use sqlite on multiple threads, using the same connection");
        } else {
            NSLog(@"setting sqlite thread safe mode to serialized failed!!! return code: %d", retCode);
        }
    } else {
        NSLog(@"Your SQLite database is not compiled to be threadsafe.");
    }

    // opens database, creating the file if it does not already exist
    if (sqlite3_open([self.pathToDatabase UTF8String], &database) == SQLITE_OK) {
        //TODO:调试完成后发包要加密
        const char* key = [@"WWW.PUHUI.WEALTH.COM" UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        if (sqlite3_exec(database, (const char*) "SELECT count(*) FROM sqlite_master;", NULL, NULL, NULL) == SQLITE_OK) {
            NSLog(@"password is correct, or, database has been initialized!");
        } else {
            NSLog(@"incorrect password!");
            sqlite3_close(database);
        }
    } else {
        NSLog(@"Failed to open database");
        sqlite3_close(database);
    }
}

#endif

#pragma mark - Update database version Methods

//- (void)updateToDatabaseV2:(NSArray *)tableNames {
//    if ([self databaseVersion] < 2) {
//        // Migrations for database version 1 will run here
//        [self setDatabaseVersion:2];
//        
//        long long userid = kClientManagerUid;
//        if ( userid > 0 ) {
//            // 删除所有附件信息
//            NSString *document = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//            NSString *photoPicturePath = [NSString stringWithFormat:@"%@/%@/%@", document, @(userid), kPhotoPicture];
//            [[NSFileManager defaultManager] removeItemAtPath:photoPicturePath error:nil];
//            
//            // 删除旧版本数据库表
//            [tableNames enumerateObjectsUsingBlock:^(NSString *tableName, NSUInteger idx, BOOL *stop) {
//                if ( ![tableName isEqualToString:@"ApplicationProperties"] && ![tableName isEqualToString:@"sqlite_sequence"] ) {
//                    [self executeSql:[NSString stringWithFormat:@"DROP TABLE %@", tableName]];
//                }
//            }];
//        }
//    }
//}
//
//- (void)updateToDatabaseV3:(NSArray *)tableNames {
//    if ([self databaseVersion] < 3) {
//        // Migrations for database version 3 will run here
//        [self setDatabaseVersion:3];
//
//        // V_2.1.0 DetailItemStatus增加 detailClass (附件类别) 字段: 1:填写资料项 2:附件资料项
//        [DetailItemStatus upgradeTable];
//    }
//}
//
//- (void)updateToDatabaseV4:(NSArray *)tableNames {
//    if ([self databaseVersion] < 4) {
//        @try {
//            /*
//             V_2.2.0 CustomerInformation增加:
//             pictureId;                  // 头像
//             filePath;                   // 大图URL
//             iconPath;                   // 缩略图url
//             fileName;                   // 图片名称
//             */
//            [CustomerInformation upgradeTable];
//
//            /**
//             *    V_2.2.0 
//             *        CustomerInformation增加:
//             *                                    staffCount;                  // 员工数
//             *        SalesAccountInformation增加:
//             *                                    isEnabled;           // 是否在职
//             *                                    filePath;         // 缩略图路径
//             *                                    iconPath          // 大图路径
//             */
//            [OfficeWorkerInformation upgradeTable];
//            [SalesAccountInformation upgradeTable];
//
//            // Migrations for database version 4 will run here
//            [self setDatabaseVersion:4];
//        }
//        @catch (NSException *exception) {
//            NSLog(@"exception = %@", exception);
//        }
//        @finally {
//            
//        }
//    }
//}
//
//- (void)updateToDatabaseV5:(NSArray *)tableNames {
//    if ([self databaseVersion] < 5) {
//        @try {
//            /*
//             V_2.3.0 IdentityInformation增加:
//             customerName;           // 用户名
//             gender;                  // 1(男),2(女)
//             marriage;                // 婚姻状况
//             isExistChildren;         // 有无子女 1(有),2(无)
//             childrenNumber;          // 子女数量
//             isProvideHouseProperty;  // 本地有无房产
//             */
//            [IdentityInformation upgradeTable];
//
//            // 从customer表中导入历史数据
//            NSArray *customerInformations = [CustomerInformation findAll];
//            NSArray *identityInformations = [IdentityInformation findAll];
//            [identityInformations enumerateObjectsUsingBlock:^(IdentityInformation *identityInformation, NSUInteger idx, BOOL * _Nonnull stop) {
//                [customerInformations enumerateObjectsUsingBlock:^(CustomerInformation *customerInformation, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if ( identityInformation.userid == customerInformation.userid ) {
//                        identityInformation.customerName = customerInformation.customerName;
//                        identityInformation.gender = customerInformation.gender;
//                        identityInformation.marriage = customerInformation.marriage;
//                        identityInformation.isExistChildren = customerInformation.isExistChildren;
//                        identityInformation.childrenNumber = customerInformation.childrenNumber;
//                        identityInformation.isProvideHouseProperty = customerInformation.isProvideHouseProperty;
//                        [identityInformation save];
//                    }
//                }];
//            }];
//
//            /**
//             *    V_2.3.0 OfficeWorkerInformation增加:
//             *      salaryGetForm;          // 工资发放形式
//             *      accumulationFund;       // 公积金是否缴纳
//             *        SalesAccountInformation增加:
//             *                                    isEnabled;           // 是否在职
//             *                                    filePath;         // 缩略图路径
//             *                                    iconPath          // 大图路径
//             */
//            [OfficeWorkerInformation upgradeTable];
//
//            // 从customer表中导入历史数据
//            NSArray *officeWorkerInformations = [OfficeWorkerInformation findAll];
//            [officeWorkerInformations enumerateObjectsUsingBlock:^(OfficeWorkerInformation *officeWorkerInformation, NSUInteger idx, BOOL * _Nonnull stop) {
//                [customerInformations enumerateObjectsUsingBlock:^(CustomerInformation *customerInformation, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if ( officeWorkerInformation.userid == customerInformation.userid ) {
//                        officeWorkerInformation.salaryGetForm = customerInformation.salaryGetForm;
//                        officeWorkerInformation.accumulationFund = customerInformation.accumulationFund;
//                        [officeWorkerInformation save];
//                    }
//                }];
//            }];
//
//            // Migrations for database version 5 will run here
//            [self setDatabaseVersion:5];
//        }
//        @catch (NSException *exception) {
//            NSLog(@"exception = %@", exception);
//        }
//        @finally {
//
//        }
//    }
//}
//
//- (void)updateToDatabaseV6:(NSArray *)tableNames {
//    if ([self databaseVersion] < 6) {
//        @try {
//            /*
//             V_3.0.0 IdentityInformation增加:
//             *          monthlyIncomeType  收入来源
//             *
//             * AccountInformation增加
//             *          stepType 借款步骤
//             */
//            [IdentityInformation upgradeTable];
//            [AccountInformation upgradeTable];
//
//            // 从IdentityInformation表中导入历史数据
//            NSArray *customerInformations = [CustomerInformation findAll];
//            NSArray *identityInformations = [IdentityInformation findAll];
//            [customerInformations enumerateObjectsUsingBlock:^(CustomerInformation *customerInformation, NSUInteger idx, BOOL * _Nonnull stop) {
//                [identityInformations enumerateObjectsUsingBlock:^(IdentityInformation *identityInformation, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if ( customerInformation.userid == identityInformation.userid ) {
//                        customerInformation.customerName = identityInformation.customerName;
//                        [customerInformation save];
//                    }
//                }];
//            }];
//
//            // Migrations for database version 5 will run here
//            [self setDatabaseVersion:6];
//        }
//        @catch (NSException *exception) {
//            NSLog(@"exception = %@", exception);
//        }
//        @finally {
//            
//        }
//    }
//}

@end
