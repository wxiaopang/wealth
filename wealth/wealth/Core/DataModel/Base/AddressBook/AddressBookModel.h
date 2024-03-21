//
//  AddressBookModel.h
//  wealth
//
//  Created by wangyingjie on 15/1/13.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import "BaseModel.h"

@interface AddressBookModel : NSObject //BaseModel

@property (nonatomic, assign) ABRecordID recordID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, assign) NSTimeInterval birthday;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *organization;
@property (nonatomic, copy) NSString *department;

- (instancetype)initWithABRecordRef:(ABRecordRef)record;

+ (NSArray *)findAll;

+ (void)saveAll:(NSArray *)addressBookArray;

+ (void)appendSava:(NSArray *)addressBookArray;

+ (void)deleteAll;

- (BOOL)isEqualAddressBookModel:(AddressBookModel *)model;

- (NSString *)getAddressBookName;

- (NSArray *)getPhoneLabels;

- (NSArray *)getEmailLabels;

- (NSArray *)getAddressLabels;

@end
