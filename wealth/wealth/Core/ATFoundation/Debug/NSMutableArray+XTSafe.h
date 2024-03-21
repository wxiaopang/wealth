//
//  NSMutableArray+XTSafe.h
//  wealth
//
//  Created by wangyingjie on 15/11/14.
//  Copyright © 2015年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SafeKitObjectPerformExceptionCatch) {
    SafeKitObjectPerformExceptionCatchOn,//When Object invoke the method named performSelector,it will add try .. catch
    SafeKitObjectPerformExceptionCatchOff
};

/*
 * Set method
 */
void setSafeKitObjectPerformExceptionCatch(SafeKitObjectPerformExceptionCatch type);

/*
 * Get method
 */
SafeKitObjectPerformExceptionCatch getSafeKitObjectPerformExceptionCatch();

@interface NSMutableArray (XTSafe)

@end
