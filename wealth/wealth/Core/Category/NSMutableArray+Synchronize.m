//
//  NSMutableArray+Synchronize.m
//  wealth
//
//  Created by wangyingjie on 15/1/16.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import "NSMutableArray+Synchronize.h"

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
                                    @implementation TT_FIX_CATEGORY_BUG_##name @end

@implementation NSMutableArray (Synchronize)

-(void)insertObjectSynchronize:(id)anObject atIndex:(NSUInteger)index {
    @synchronized(self) {
        [self insertObject:anObject atIndex:index];
    }
}

-(void)addObjectSynchronize:(id)obj {
    @synchronized(self) {
        [self addObject:obj];
    }
}

-(void)addOnlyObject:(id)obj {
    if ( ![self containsObject:obj] ) {
        [self addObjectSynchronize:obj];
    }
}

-(void)removeObjectSynchronize:(id)obj {
    @synchronized(self) {
        if (obj && [self containsObject:obj]) {
            [self removeObject:obj];
        }
    }
}

-(void)removeFirstObjectSynchronize {
    @synchronized(self) {
        if (self.count > 1) {
            [self removeObjectAtIndex:0];
        }
    }
}

-(void)removeLastObjectSynchronize {
    @synchronized(self) {
        [self removeLastObject];
    }
}

- (void)removeObjectsInArraySycnronize:(NSArray*)array {
    @synchronized(self) {
        [self removeObjectsInArray:array];
    }
}

-(void)removeAllObjectsSynchronize {
    @synchronized(self) {
        [self removeAllObjects];
    }
}

-(id)objectSyncAtIndex:(NSInteger)index {
    @synchronized(self) {
        return  [self objectAtIndex:index];
    }
}

@end

@implementation NSMutableArray (Stack)

-(void)push:(id)obj {
    [self insertObjectSynchronize:obj atIndex:0];
}

-(id)pop {
    id obj = nil;
    if (self.count > 1) {
        obj = self.firstObject;
        [self removeFirstObjectSynchronize];
    }
    return obj;
}

@end

@implementation NSMutableArray (Queue)

-(void)enqueued:(id)obj {
    [self addObjectSynchronize:obj];
}

-(id)dequeue {
    return [self pop];
}

@end

@implementation NSArray (Print)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@ (\n", @(self.count)];
    for (id obj in self) {
        [str appendFormat:@"\t%@, \n", obj];
    }
    [str appendString:@")"];
    return str;
}

@end
