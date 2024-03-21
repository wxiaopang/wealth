//
//  NSObject+DTDebug.h
//  wealth
//
//  Created by wangyingjie on 15/12/18.
//  Copyright © 2015年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (DTDebug)

+ (void)replaceClassMethodWithClass:(Class)clazz
                       originMethod:(SEL)originMethodSEL
                         withMethod:(SEL)newMethodSEL;

@end

@interface NSString (DTDebug)

+ (NSString*)stringByReplaceUnicode:(NSString*)string;

@end

@interface NSDictionary (DTDebug)
@end

@interface NSArray (DTDebug)
@end

@interface NSSet (DTDebug)
@end
