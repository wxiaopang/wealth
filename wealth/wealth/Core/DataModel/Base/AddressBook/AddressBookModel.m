
//  AddressBookModel.m
//  wealth
//
//  Created by wangyingjie on 15/1/13.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import "AddressBookModel.h"
#import "Utility.h"

#define kAddressBookBackupFile   @"AddressBook.plist"

@interface AddressBookModel () <NSCoding> {
    NSMutableArray *_phones;
    NSMutableArray *_emails;
    NSMutableArray *_address;
}

@end

@implementation AddressBookModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.recordID) forKey:@"recordID"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:@(self.birthday) forKey:@"birthday"];
    [aCoder encodeObject:self.job forKey:@"job"];
    [aCoder encodeObject:self.organization forKey:@"organization"];
    [aCoder encodeObject:self.department forKey:@"department"];
    if ( _phones ) {
        [aCoder encodeObject:_phones forKey:@"phones"];
    }
    if ( _emails ) {
        [aCoder encodeObject:_emails forKey:@"emails"];
    }
    if ( _address ) {
        [aCoder encodeObject:_address forKey:@"address"];
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if ( self ) {
        self.recordID = [[aDecoder decodeObjectForKey:@"recordID"] intValue];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.birthday = [[aDecoder decodeObjectForKey:@"birthday"] doubleValue];
        self.job = [aDecoder decodeObjectForKey:@"job"];
        self.organization = [aDecoder decodeObjectForKey:@"organization"];
        self.department = [aDecoder decodeObjectForKey:@"department"];
        _phones = [aDecoder decodeObjectForKey:@"phones"];
        _emails = [aDecoder decodeObjectForKey:@"emails"];
        _address = [aDecoder decodeObjectForKey:@"address"];
    }
    return self;
}

- (instancetype)initWithABRecordRef:(ABRecordRef)record {
    self = [super init];
    if ( self ) {
        // 初始化通讯录信息
        _recordID = ABRecordGetRecordID(record);
        
        // 名字
        NSString *tmp = (__bridge_transfer NSString *)(ABRecordCopyCompositeName(record));
        _name = tmp ? tmp : kNullStr;
        
        // 昵称
        tmp = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonNicknameProperty);
        _nickName = tmp ? tmp : kNullStr;
        
        // 生日
        NSDate *tmpDate = (__bridge_transfer NSDate *)(ABRecordCopyValue(record, kABPersonBirthdayProperty));
        _birthday = tmpDate ? [tmpDate timeIntervalSince1970] : 0;
        
        // 工作
        tmp = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonJobTitleProperty);
        _job = tmp ? tmp : kNullStr;
        
        // 公司
        tmp = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonOrganizationProperty);
        _organization = tmp ? tmp : kNullStr;
        
        // 部门
        tmp = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonDepartmentProperty);
        _department = tmp ? tmp : kNullStr;
        
        // 手机号表
        _phones = [self getMutiLableValueFrom:record propertyID:kABPersonPhoneProperty model:[PhoneLableModel class]];
        
        // 邮箱表
        _emails = [self getMutiLableValueFrom:record propertyID:kABPersonEmailProperty model:[EmailLableModel class]];
        
        // 地址
        ABMultiValueRef multiValueRef = ABRecordCopyValue(record, kABPersonAddressProperty);
        if ( multiValueRef && ABMultiValueGetCount(multiValueRef) > 0 ) {
            _address = [[NSMutableArray alloc] initWithCapacity:ABMultiValueGetCount(multiValueRef)];
            for ( NSInteger i = 0; i < ABMultiValueGetCount(multiValueRef); i++ ) {
                //获取地址Label
                NSString *lable = (__bridge_transfer NSString *)(ABMultiValueCopyLabelAtIndex(multiValueRef, i));
                NSDictionary *value = (__bridge_transfer NSDictionary *)(ABMultiValueCopyValueAtIndex(multiValueRef, i));
                NSString *smallLable = [[lable stringByReplacingOccurrencesOfString:@"_$!<" withString:@""]
                                        stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
                NSString *smallValue = [Utility toJSONString:value];
                [_address addObject:[[AddressLableModel alloc] initWithRecordId:_recordID
                                                                          lable:(smallLable?smallLable:kNullStr)
                                                                          value:(smallValue?smallValue:kNullStr)]];
            }
        }
        if ( multiValueRef ) {
            CFRelease(multiValueRef);
        }
    }
    return self;
}

- (NSMutableArray *)getMutiLableValueFrom:(ABRecordRef)record propertyID:(ABPropertyID)property model:(Class)class {
    NSMutableArray *result = nil;
    ABMultiValueRef multiValueRef = ABRecordCopyValue(record, property);
    if ( multiValueRef && ABMultiValueGetCount(multiValueRef) > 0) {
        result = [[NSMutableArray alloc] initWithCapacity:ABMultiValueGetCount(multiValueRef)];
        for (NSInteger i = 0; i < ABMultiValueGetCount(multiValueRef); i++) {
            NSString *lable = (__bridge_transfer NSString *)(ABMultiValueCopyLabelAtIndex(multiValueRef, i));
            NSString *value = (__bridge_transfer NSString *)(ABMultiValueCopyValueAtIndex(multiValueRef, i));
            NSString *smallLable = [[lable stringByReplacingOccurrencesOfString:@"_$!<" withString:@""]
                                    stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
            NSString *smallValue = [value stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [result addObject:[[class alloc] initWithRecordId:_recordID
                                                         lable:(smallLable?smallLable:kNullStr)
                                                         value:(smallValue?smallValue:kNullStr)]];
        }
    }
    if ( multiValueRef ) {
        CFRelease(multiValueRef);
    }
    return result;
}

- (BOOL)isEqualArrayValue:(NSArray *)array1 other:(NSArray *)array2 {
    __block BOOL result = (array1 == nil && array2 == nil)
                            || ( array1 && array1.count > 0
                                && array2 && array2.count > 0
                                && array1.count == array2.count );
    if ( !result ) {
        return result;
    }
    
    [array1 enumerateObjectsUsingBlock:^(BaseLableValueModel *selfModel, NSUInteger idx, BOOL *stop1) {
        result = NO;
        [array2 enumerateObjectsUsingBlock:^(BaseLableValueModel *model, NSUInteger idx, BOOL *stop2) {
            if ( [selfModel isEqualLableValueModel:model] ) {
                result = YES;
                *stop2 = YES;
            }
        }];
    }];
    return result;
}

- (NSString *)getAddressBookName {
    if ( self.name.length > 0 ) {
        return self.name;
    } else if ( self.nickName.length > 0 ) {
        return self.nickName;
    } else {
        return [NSString stringWithFormat:@"%@", @(self.recordID)];
    }
}

- (NSArray *)getPhoneLabels {
    return _phones;
}

- (void)setPhoneLabels:(NSArray *)phoneLabels {
    _phones = [NSMutableArray arrayWithArray:phoneLabels];
}

- (NSArray *)getEmailLabels {
    return _emails;
}

- (void)setEmailLabels:(NSArray *)emailLabels {
    _emails = [NSMutableArray arrayWithArray:emailLabels];
}

- (NSArray *)getAddressLabels {
    return _address;
}

- (void)setAddressLabels:(NSArray *)addressLabels {
    _address = [NSMutableArray arrayWithArray:addressLabels];
}

- (BOOL)isEqualAddressBookModel:(AddressBookModel *)model {
    // 匹配基本信息
    __block BOOL result = (_recordID == model.recordID
                           && [_name isEqualToString:model.name]
                           && [_nickName isEqualToString:model.nickName]
                           && _birthday == model.birthday
                           && [_job isEqualToString:model.job]
                           && [_organization isEqualToString:model.organization]
                           && [_department isEqualToString:model.department]);
    if ( !result ) {
        return result;
    }
    
    // 匹配手机号
    result = [self isEqualArrayValue:_phones other:[model getPhoneLabels]];
    if ( !result ) {
        return result;
    }
    
    // 匹配邮箱
    result = [self isEqualArrayValue:_emails other:[model getEmailLabels]];
    if ( !result ) {
        return result;
    }
    
    // 匹配地址
    result = [self isEqualArrayValue:_address other:[model getAddressLabels]];
    if ( !result ) {
        return result;
    }
    
    return result;
}

// ******************************************************************************************
// **       以下代码适用于 通讯录存储配置文件中
// ******************************************************************************************

+ (NSArray *)findAll {
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *plistPath = [documentPath stringByAppendingPathComponent:kAddressBookBackupFile];
    if ( [[NSFileManager defaultManager] fileExistsAtPath:plistPath] ) {
        NSArray *addressBookArray = [[NSArray alloc ] initWithContentsOfFile:plistPath];
        [addressBookArray enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idx, BOOL *stop) {
            if ( data ) {
                NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
                [result addObject:[unArchiver decodeObject]];
                [unArchiver finishDecoding];
            }
        }];
    }
    return result;
}

+ (void)saveAll:(NSArray *)addressBookArray {
    if ( addressBookArray == nil || addressBookArray.count == 0 ) {
        return;
    }
    [Utility testFunctionTimes:@"saveAll addressBookArray" tast:^{
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *plistPath = [documentPath stringByAppendingPathComponent:kAddressBookBackupFile];
        if ( [[NSFileManager defaultManager] fileExistsAtPath:plistPath] ) {
            [[NSFileManager defaultManager] removeItemAtPath:plistPath error:nil];
        }
        
        NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:0];
        [addressBookArray enumerateObjectsUsingBlock:^(AddressBookModel *addressBook, NSUInteger idx, BOOL *stop) {
            NSMutableData *addressBookData = [[NSMutableData alloc] init];
            NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:addressBookData];
            [archiver encodeObject:addressBook];
            [archiver finishEncoding];
            [tmp addObject:addressBookData];
        }];
        [tmp writeToFile:plistPath atomically:YES];
    }];
}

+ (void)appendSava:(NSArray *)addressBookArray {
    NSArray *oldArray = [AddressBookModel findAll];
    NSArray *newArray = [oldArray arrayByAddingObjectsFromArray:addressBookArray];
    [AddressBookModel saveAll:newArray];
}

+ (void)deleteAll {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *plistPath = [documentPath stringByAppendingPathComponent:kAddressBookBackupFile];
    if ( [[NSFileManager defaultManager] fileExistsAtPath:plistPath] ) {
        [[NSFileManager defaultManager] removeItemAtPath:plistPath error:nil];
    }
}

// ******************************************************************************************
// **       以下代码适用于 通讯录存储数据库里的场景
// ******************************************************************************************

//+ (NSArray *)findAll {
//    NSArray *result = [super findAll];
//    [result enumerateObjectsUsingBlock:^(AddressBookModel *model, NSUInteger idx, BOOL *stop) {
//        // 手机号
//        [model setPhoneLabels:[PhoneLableModel findByColumn:@"recordID" integerValue:model.recordID]];
//
//        // email
//        [model setEmailLabels:[EmailLableModel findByColumn:@"recordID" integerValue:model.recordID]];
//
//        // 地址
//        [model setAddressLabels:[AddressLableModel findByColumn:@"recordID" integerValue:model.recordID]];
//    }];
//    return result;
//}
//
//- (void)saveWithComplete:(dispatch_block_t)complete {
//    // 手机号
//    if ( _phones ) {
//        [_phones enumerateObjectsUsingBlock:^(PhoneLableModel *model, NSUInteger idx, BOOL *stop) {
//            [model saveWithComplete:nil];
//        }];
//    }
//    
//    // email
//    if ( _emails ) {
//        [_emails enumerateObjectsUsingBlock:^(EmailLableModel *model, NSUInteger idx, BOOL *stop) {
//            [model saveWithComplete:nil];
//        }];
//    }
//    
//    // 地址
//    if ( _address ) {
//        [_address enumerateObjectsUsingBlock:^(AddressLableModel *model, NSUInteger idx, BOOL *stop) {
//            [model saveWithComplete:nil];
//        }];
//    }
//    
//    [super saveWithComplete:complete];
//}
//
//- (void)deleteSelfComplete:(dispatch_block_t)complete {
//    // 手机号
//    if ( _phones ) {
//        [_phones enumerateObjectsUsingBlock:^(PhoneLableModel *model, NSUInteger idx, BOOL *stop) {
//            [model deleteSelfComplete:nil];
//        }];
//    }
//    
//    // email
//    if ( _emails ) {
//        [_emails enumerateObjectsUsingBlock:^(EmailLableModel *model, NSUInteger idx, BOOL *stop) {
//            [model deleteSelfComplete:nil];
//        }];
//    }
//    
//    // 地址
//    if ( _address ) {
//        [_address enumerateObjectsUsingBlock:^(AddressLableModel *model, NSUInteger idx, BOOL *stop) {
//            [model deleteSelfComplete:nil];
//        }];
//    }
//    
//    [super deleteSelfComplete:complete];
//}

@end
