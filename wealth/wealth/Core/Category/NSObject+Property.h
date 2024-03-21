//
//  NSObject+Property.h
//  wealth
//
//  Created by wangyingjie on 15/7/22.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)

/*!
 *  Returns key value pair of property strings, where the key is property hay_name,
 *  and value is the type of key.
 *
 *  @return dictionary of key-value mapped object properties
 */
- (NSDictionary *)hay_properties;

+ (NSDictionary *)hay_properties;

/*!
 * Returns YES if the object is a valid property list
 *
 * @return BOOL YES when object is property list
 */
- (BOOL)hay_isPropertyList;

@end
