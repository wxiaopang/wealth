//
//  AddressBookManager.m
//  wealth
//
//  Created by wangyingjie on 15/1/13.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import "AddressBookManager.h"
#import "AddressBookModel.h"
#import "Utility.h"

static void handleAddressBookExternalChanged(ABAddressBookRef addressBook, CFDictionaryRef info, void *context) {
    AddressBookManager *addressBookManager = (__bridge AddressBookManager *)context;
    [addressBookManager refreshAddressBookContacts];
    NSLog(@"info = %@", (__bridge NSDictionary *)info);
}

@interface AddressBookManager () <ABNewPersonViewControllerDelegate>

@property (nonatomic, assign) ABAddressBookRef      addressBookRef;
@property (nonatomic, assign) ABAuthorizationStatus status;
@property (nonatomic, strong) NSMutableArray        *addressBookContacts;
@property (nonatomic, strong) GCDQueue              *queue;
@property (nonatomic, strong) GCDQueue              *savaQueue;

@property (nonatomic, strong) NSArray *increase;
@property (nonatomic, strong) NSArray *decrease;
@property (nonatomic, assign) BOOL    isReady;

@end

@implementation AddressBookManager

//SYNTHESIZE_SINGLETON_FOR_CLASS(AddressBookManager);

- (instancetype)init {
    self = [super init];
    if (self) {
        _queue          = [[GCDQueue alloc] initSerial];
        _savaQueue      = [[GCDQueue alloc] initSerial];
        _status         = ABAddressBookGetAuthorizationStatus();
        _addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRegisterExternalChangeCallback(_addressBookRef, handleAddressBookExternalChanged, (__bridge void *)(self));
    }
    return self;
}

- (void)clearInformation {
    _addressBookContacts = nil;
    _increase            = nil;
    _decrease            = nil;
}

- (void)refreshAddressBookContacts {
    @weakify(self);
    dispatch_async(_queue.dispatchQueue, ^{
        @strongify(self);
        [Utility testFunctionTimes:[NSString stringWithUTF8String:__FUNCTION__] tast:^{
            @strongify(self);
            // 取本地数据库中缓存的通讯录信息
            NSArray *localContacts = [AddressBookModel findAll];

            // 取系统通讯录中的信息
            CFArrayRef records = ABAddressBookCopyArrayOfAllPeople(self.addressBookRef);
            self.addressBookContacts = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(records)];
            for (NSInteger i = 0; i < CFArrayGetCount(records); i++) {
                AddressBookModel *addressBookModel = [[AddressBookModel alloc] initWithABRecordRef:CFArrayGetValueAtIndex(records, i)];
#warning 匹配通讯录时特殊逻辑,同一标签下存有超过20以上的手机号就认为无效的通讯录，不进行上传
                if ([addressBookModel getPhoneLabels].count > 0 && [addressBookModel getPhoneLabels].count <= 20) {
                    [self.addressBookContacts addObject:addressBookModel];
                }
            }

            // 比较两者之间的变更
            // 增量计算
            NSMutableArray *increase = [[NSMutableArray alloc] initWithArray:self.addressBookContacts];
            [self.addressBookContacts enumerateObjectsUsingBlock:^(AddressBookModel *bookModel, NSUInteger idx, BOOL *stop1) {
                [localContacts enumerateObjectsUsingBlock:^(AddressBookModel *databaseModel, NSUInteger idx, BOOL *stop2) {
                    if ([bookModel isEqualAddressBookModel:databaseModel]) {
                        //                    bookModel.savedInDatabase = YES;    // 相同的通讯录项标记为已经存储过
                        [increase removeObject:bookModel];
                        *stop2 = YES;
                    }
                }];
            }];

            // 减量计算
            NSMutableArray *decrease = [[NSMutableArray alloc] initWithArray:localContacts];
            [localContacts enumerateObjectsUsingBlock:^(AddressBookModel *databaseModel, NSUInteger idx, BOOL *stop1) {
                [self.addressBookContacts enumerateObjectsUsingBlock:^(AddressBookModel *bookModel, NSUInteger idx, BOOL *stop2) {
                    if ([databaseModel isEqualAddressBookModel:bookModel]) {
                        [decrease removeObject:databaseModel];
                        *stop2 = YES;
                    }
                }];
            }];

            // 更新本地缓存
            //        [AddressBookModel saveAll:_addressBookContacts];
            //        _addressBookContacts = nil;

            //        // 更新本地数据库缓存
            //        [decrease makeObjectsPerformSelector:@selector(deleteSelf) withObject:nil];
            //        [increase enumerateObjectsUsingBlock:^(AddressBookModel *bookModel, NSUInteger idx, BOOL *stop) {
            //            bookModel.savedInDatabase = YES;
            //            [[bookModel getPhoneLabels] enumerateObjectsUsingBlock:^(PhoneLableModel *obj, NSUInteger idx, BOOL *stop) {
            //                obj.savedInDatabase = YES;
            //            }];
            //            [[bookModel getEmailLabels] enumerateObjectsUsingBlock:^(EmailLableModel *obj, NSUInteger idx, BOOL *stop) {
            //                obj.savedInDatabase = YES;
            //            }];
            //            [[bookModel getAddressLabels] enumerateObjectsUsingBlock:^(AddressLableModel *obj, NSUInteger idx, BOOL *stop) {
            //                obj.savedInDatabase = YES;
            //            }];
            //            [bookModel deleteSelf];
            //        }];
            //        [_addressBookContacts makeObjectsPerformSelector:@selector(save) withObject:nil];

            // 缓存信息
            self.increase = increase;
            self.decrease = decrease;
            self.isReady = YES;

            // 通知通讯录变化情况
            //        if ( increase.count > 0 && decrease.count > 0 ) {
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                [[NSNotificationCenter defaultCenter] postNotificationName:kAddressBookContactChanged
            //                                                                    object:nil
            //                                                                  userInfo:@{ kAddressBookContactIncreased:increase,
            //                                                                              kAddressBookContactDecreased:decrease }];
            //           });
            //        } else if ( increase.count > 0 ) {
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                [[NSNotificationCenter defaultCenter] postNotificationName:kAddressBookContactChanged
            //                                                                    object:nil
            //                                                                  userInfo:@{ kAddressBookContactIncreased:increase }];
            //            });
            //        } else if ( decrease.count > 0 ) {
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                [[NSNotificationCenter defaultCenter] postNotificationName:kAddressBookContactChanged
            //                                                                    object:nil
            //                                                                  userInfo:@{ kAddressBookContactDecreased:decrease }];
            //            });
            //        }
            CFRelease(records);
        }]; // end [Utility testFunctionTimes]
    });
}

- (void)initializedContact {
    if (_status != kABAuthorizationStatusAuthorized) {
        @weakify(self);
        ABAddressBookRequestAccessWithCompletion(_addressBookRef, ^(bool granted, CFErrorRef error) {
            @strongify(self);
            if (granted) {
                [self refreshAddressBookContacts];
            }
            else {

            }
        });
    }
    else {
        [self refreshAddressBookContacts];
    }
}

- (RACSignal *)rac_initilized {
    @weakify(self);
    return [[[RACSignal createSignal:^RACDisposable *(id < RACSubscriber > subscriber) {
        @strongify(self);
        [self initializedContact];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{ }];
    }]
             takeUntil:self.rac_willDeallocSignal]
            setNameWithFormat:@"%@ -rac_initilized", [self rac_description]];
}

- (void)showNewPersonViewController:(UIViewController *)vc {
    ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
    picker.newPersonViewDelegate = self;

    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:picker];
    [vc presentViewController:navigation animated:YES completion:nil];
}

#pragma mark -- ABNewPersonViewControllerDelegate

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person {
    AddressBookModel *model = [[AddressBookModel alloc] initWithABRecordRef:person];
    [_addressBookContacts addObject:model];
    //    [model save];

    [[NSNotificationCenter defaultCenter] postNotificationName:kAddressBookContactChanged
                                                        object:nil
                                                      userInfo:@{ kAddressBookContactIncreased:@[ model ] }];
}

#pragma mark -- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

+ (NSArray *)getContactList {
    return [AddressBookModel findAll];
}

@end
