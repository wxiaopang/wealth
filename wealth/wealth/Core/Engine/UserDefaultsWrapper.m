//
//  UserDefaultsWrapper.m
//  wealth
//
//  Created by wangyingjie on 14/12/17.
//  Copyright (c) 2014年 puhui. All rights reserved.
//

#import "UserDefaultsWrapper.h"

@implementation UserDefaultsWrapper

+ (void)setUserDefaults:(NSDictionary *)dic {
    NSAssert(dic != nil, nil);
    NSAssert(dic.count > 0, nil);
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [def setObject:obj forKey:key];
    }];
    [def synchronize];
}

+ (void)setUserDefaultsObject:(id)obj forKey:(NSString *)key {
    NSAssert(obj != nil, nil);
    NSAssert(key != nil, nil);
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)userDefaultsObject:(NSString *)key {
    NSAssert(key != nil, nil);
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)removeUserDefaults:(NSString *)key {
    NSAssert(key != nil, nil);
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setDictionary:(NSDictionary *)dic forPlist:(NSString *)plist {
    NSAssert(dic != nil, nil);
    NSAssert(dic.count > 0, nil);

    NSLog(@"dic = %@", dic);
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *file = [[PathEngine getDocumentPath] stringByAppendingPathComponent:plist];
        @synchronized([UIApplication sharedApplication]) {
            if ( ![PathEngine isExistFile:file] ) {
                [PathEngine createPath:[file stringByDeletingLastPathComponent]];
                [dic writeToFile:file atomically:YES];
            } else {
                NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithContentsOfFile:file];
                [tmp addEntriesFromDictionary:dic];
                [tmp writeToFile:file atomically:YES];
            }
        }
//    });
}

+ (NSDictionary *)getDictionary:(NSString *)plist {
    @synchronized([UIApplication sharedApplication]) {
        return [NSDictionary dictionaryWithContentsOfFile:[[PathEngine getDocumentPath] stringByAppendingPathComponent:plist]];
    }
}

+ (void)removeDictionary:(NSDictionary *)dic forPlist:(NSString *)plist {
    NSAssert(dic != nil, nil);
    NSAssert(dic.count > 0, nil);

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *file = [[PathEngine getDocumentPath] stringByAppendingPathComponent:plist];
        @synchronized([UIApplication sharedApplication]) {
            if ( [PathEngine isExistFile:file] ) {
                NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithContentsOfFile:file];
                [tmp removeObjectsForKeys:dic.allKeys];
                [tmp writeToFile:file atomically:YES];
            }
        }
//    });
}

+ (void)archiver:(id)object forFile:(NSString *)fileName {
    //1.创建一个可变的二进制流
    NSMutableData *data = [[NSMutableData alloc] init];
    //2.创建一个归档对象(有将自定义类转化为二进制流的功能)
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //3.用该归档对象，把自定义类的对象，转为二进制流
    [archiver encodeObject:object forKey:@"data"];
    //4.归档完毕
    [archiver finishEncoding];

    NSString *file = [[PathEngine getDocumentPath] stringByAppendingPathComponent:fileName];
    if ( [PathEngine createPath:[file stringByDeletingLastPathComponent]] ) {
        BOOL ret = [data writeToFile:file atomically:YES];
        if ( !ret ) {
            NSLog(@"archiver %@ failed", file);
        } else {
            NSLog(@"archiver %@ successed", file);
        }
    }
}

+ (id)unarchiver:(NSString *)fileName {
    //1.创建一个可变的二进制流
    NSMutableData *mData = [NSMutableData dataWithContentsOfFile:[[PathEngine getDocumentPath] stringByAppendingPathComponent:fileName]];
    //2.创建一个反归档对象，将二进制数据解成正行的oc数据
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:mData];
    return [unArchiver decodeObjectForKey:@"data"];
}

@end
