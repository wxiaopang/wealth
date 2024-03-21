//
//  NSMutableArray+Synchronize.h
//  wealth
//
//  Created by wangyingjie on 15/1/16.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Synchronize)

-(void)insertObjectSynchronize:(id)anObject atIndex:(NSUInteger)index;

-(void)addObjectSynchronize:(id)obj;

-(void)addOnlyObject:(id)obj;

-(void)removeObjectSynchronize:(id)obj;

-(void)removeLastObjectSynchronize;

- (void)removeObjectsInArraySycnronize:(NSArray*)array;

-(void)removeAllObjectsSynchronize;

-(id)objectSyncAtIndex:(NSInteger)index ;
@end

@interface NSMutableArray (Stack)

-(void)push:(id)obj;

-(id)pop;

@end

@interface NSMutableArray (Queue)

-(void)enqueued:(id)obj;

-(id)dequeue;

@end

@interface NSArray (Print)

@end

