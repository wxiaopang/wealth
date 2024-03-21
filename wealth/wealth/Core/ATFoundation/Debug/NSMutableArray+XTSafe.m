//
//  NSMutableArray+XTSafe.m
//  wealth
//
//  Created by wangyingjie on 15/11/14.
//  Copyright © 2015年 普惠金融. All rights reserved.
//

#import "NSMutableArray+XTSafe.h"
#import "NSObject+DTRuntime.h"

#if __has_feature(objc_arc)
#define SK_AUTORELEASE(exp) exp
#define SK_RELEASE(exp) exp
#define SK_RETAIN(exp) exp
#else
#define SK_AUTORELEASE(exp) [exp autorelease]
#define SK_RELEASE(exp) [exp release]
#define SK_RETAIN(exp) [exp retain]
#endif

#pragma mark - 容器类异常处理

#define XT_SC_LOG 0

#if (XT_SC_LOG)
#define XTSCLOG(...) safeCollectionLog(__VA_ARGS__)
#else
#define XTSCLOG(...)
#endif

void safeCollectionLog(NSString *fmt, ...) NS_FORMAT_FUNCTION(1, 2);

void safeCollectionLog(NSString *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    NSString *content = [[NSString alloc] initWithFormat:fmt arguments:ap];
    NSLog(@"%@", content);
    va_end(ap);
    SK_RELEASE(content);
    NSLog(@" ============= call stack ========== \n%@", [NSThread callStackSymbols]);
}

#pragma mark - NSArray

@interface NSArray (XTSafe)

@end

@implementation NSArray (XTSafe)

+ (Method)methodOfSelector:(SEL)selector {
    return class_getInstanceMethod(NSClassFromString(@"__NSArrayI"), selector);
}

- (id)tn_objectAtIndexI:(NSUInteger)index {
    if (index >= self.count) {
        XTSCLOG(@"[%@ %@] index {%lu} beyond bounds [0...%lu]",
                NSStringFromClass([self class]),
                NSStringFromSelector(_cmd),
                (unsigned long)index,
                MAX((unsigned long)self.count - 1, 0));
        return nil;
    }

    return [self tn_objectAtIndexI:index];
}

+ (id)tn_arrayWithObjects:(const id [])objects count:(NSUInteger)cnt {
    id         validObjects[cnt];
    NSUInteger count = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        if (objects[i]) {
            validObjects[count] = objects[i];
            count++;
        }
        else {
            XTSCLOG(@"[%@ %@] NIL object at index {%lu}",
                    NSStringFromClass([self class]),
                    NSStringFromSelector(_cmd),
                    (unsigned long)i);

        }
    }

    return [self tn_arrayWithObjects:validObjects count:count];
}

@end

#pragma mark - NSMutableArray

@implementation NSMutableArray (XTSafe)

+ (Method)methodOfSelector:(SEL)selector {
    return class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), selector);
}

- (id)tn_objectAtIndexM:(NSUInteger)index {
    if (index >= self.count) {
        XTSCLOG(@"[%@ %@] index {%lu} beyond bounds [0...%lu]",
                NSStringFromClass([self class]),
                NSStringFromSelector(_cmd),
                (unsigned long)index,
                MAX((unsigned long)self.count - 1, 0));
        return nil;
    }

    return [self tn_objectAtIndexM:index];
}

- (void)tn_addObject:(id)anObject {
    if (!anObject) {
        XTSCLOG(@"[%@ %@], NIL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }
    [self tn_addObject:anObject];
}

- (void)tn_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= self.count) {
        XTSCLOG(@"[%@ %@] index {%lu} beyond bounds [0...%lu].",
                NSStringFromClass([self class]),
                NSStringFromSelector(_cmd),
                (unsigned long)index,
                MAX((unsigned long)self.count - 1, 0));
        return;
    }

    if (!anObject) {
        XTSCLOG(@"[%@ %@] NIL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }

    [self tn_replaceObjectAtIndex:index withObject:anObject];
}

- (void)tn_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > self.count) {
        XTSCLOG(@"[%@ %@] index {%lu} beyond bounds [0...%lu].",
                NSStringFromClass([self class]),
                NSStringFromSelector(_cmd),
                (unsigned long)index,
                MAX((unsigned long)self.count - 1, 0));
        return;
    }

    if (!anObject) {
        XTSCLOG(@"[%@ %@] NIL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }

    [self tn_insertObject:anObject atIndex:index];
}

@end

#pragma mark - NSDictionary

@interface NSDictionary (XTSafe)

@end

@implementation NSDictionary (XTSafe)

+ (instancetype)tn_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id            validObjects[cnt];
    id<NSCopying> validKeys[cnt];
    NSUInteger    count = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        if (objects[i] && keys[i]) {
            validObjects[count] = objects[i];
            validKeys[count]    = keys[i];
            count++;
        }
        else {
            XTSCLOG(@"[%@ %@] NIL object or key at index{%lu}.",
                    NSStringFromClass(self),
                    NSStringFromSelector(_cmd),
                    (unsigned long)i);
        }
    }

    return [self tn_dictionaryWithObjects:validObjects forKeys:validKeys count:count];
}

@end

#pragma mark - NSMutableDictionary

@interface NSMutableDictionary (XTSafe)

@end

@implementation NSMutableDictionary (XTSafe)

+ (Method)methodOfSelector:(SEL)selector {
    return class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), selector);
}

- (void)tn_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!aKey) {
        XTSCLOG(@"[%@ %@] NIL key.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }
    if (!anObject) {
        XTSCLOG(@"[%@ %@] NIL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }

    [self tn_setObject:anObject forKey:aKey];
}

@end

#pragma mark - Mama

@interface XTSafeCollection : NSObject

@end

@implementation XTSafeCollection

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // NSArray
        [self exchangeOriginalMethod:[NSArray methodOfSelector:@selector(objectAtIndex:)] withNewMethod:[NSArray methodOfSelector:@selector(tn_objectAtIndexI:)]];
        [self exchangeOriginalMethod:class_getClassMethod([NSArray class], @selector(arrayWithObjects:count:))
                       withNewMethod:class_getClassMethod([NSArray class], @selector(tn_arrayWithObjects:count:))];
        // NSMutableArray
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(objectAtIndex:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(tn_objectAtIndexM:)]];
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(replaceObjectAtIndex:withObject:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(tn_replaceObjectAtIndex:withObject:)]];
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(addObject:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(tn_addObject:)]];
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(insertObject:atIndex:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(tn_insertObject:atIndex:)]];
        // NSDictionary
        [self exchangeOriginalMethod:class_getClassMethod([NSDictionary class], @selector(dictionaryWithObjects:forKeys:count:))
                       withNewMethod:class_getClassMethod([NSDictionary class], @selector(tn_dictionaryWithObjects:forKeys:count:))];
        // NSMutableDictionary
        [self exchangeOriginalMethod:[NSMutableDictionary methodOfSelector:@selector(setObject:forKey:)] withNewMethod:[NSMutableDictionary methodOfSelector:@selector(tn_setObject:forKey:)]];
    });
}

+ (void)exchangeOriginalMethod:(Method)originalMethod withNewMethod:(Method)newMethod {
    method_exchangeImplementations(originalMethod, newMethod);
}

@end


#pragma mark - NSMutableString

@interface NSMutableString (XTSafe)

@end

@implementation NSMutableString (XTSafe)

//- (void)deleteCharactersInRange:(NSRange)range{}
//- (void)appendFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

- (void)SKappendString:(NSString *)aString {
    if (!aString) {
        XTSCLOG(@"aString is nil");
        return;
    }
    [self SKappendString:aString];
}

- (void)SKappendFormat:(NSString *)format, ...NS_FORMAT_FUNCTION(1, 2){
    if (!format) {
        XTSCLOG(@"format is nil");
        return;
    }
    va_list arguments;
    va_start(arguments, format);
    NSString *formatStr = [[NSString alloc]initWithFormat:format arguments:arguments];
    formatStr = SK_AUTORELEASE(formatStr);
    [self SKappendFormat:@"%@", formatStr];
    va_end(arguments);
}

- (void)SKsetString:(NSString *)aString {
    if (!aString) {
        XTSCLOG(@"aString is nil");
        return;
    }
    [self SKsetString:aString];
}

- (void)SKinsertString:(NSString *)aString atIndex:(NSUInteger)index {
    if (index > [self length]) {
        XTSCLOG(@"%@", [NSString stringWithFormat:@"index[%ld] > length[%ld]", (long)index, (long)[self length]]);
        return;
    }
    if (!aString) {
        XTSCLOG(@"aString is nil");
        return;
    }

    [self SKinsertString:aString atIndex:index];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(SKappendString:) tarClass:@"__NSCFConstantString" tarSel:@selector(appendString:)];
        [self swizzleMethod:@selector(SKappendFormat:) tarClass:@"__NSCFConstantString" tarSel:@selector(appendFormat:)];
        [self swizzleMethod:@selector(SKsetString:) tarClass:@"__NSCFConstantString" tarSel:@selector(setString:)];
        [self swizzleMethod:@selector(SKinsertString:atIndex:) tarClass:@"__NSCFConstantString" tarSel:@selector(insertString:atIndex:)];
    });
}

@end

#pragma mark - NSMutableString

@interface NSNumber (XTSafe)

@end

@implementation NSNumber (XTSafe)

- (BOOL)SKisEqualToNumber:(NSNumber *)number {
    if (!number) {
        XTSCLOG(@"number is nil");
        return NO;
    }
    return [self SKisEqualToNumber:number];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(SKisEqualToNumber:) tarClass:@"__NSCFNumber" tarSel:@selector(isEqualToNumber:)];
    });
}

@end

#pragma mark - NSObject

static SafeKitObjectPerformExceptionCatch safeKitObjectPerformExceptionCatchValue = SafeKitObjectPerformExceptionCatchOn;

void setSafeKitObjectPerformExceptionCatch(SafeKitObjectPerformExceptionCatch type) {
    safeKitObjectPerformExceptionCatchValue = type;
}

SafeKitObjectPerformExceptionCatch getSafeKitObjectPerformExceptionCatch() {
    return safeKitObjectPerformExceptionCatchValue;
}

@interface NSObject (XTSafe)

@end

@implementation NSObject (XTSafe)

- (id)SKperformSelector:(SEL)aSelector {
    if ([self respondsToSelector:aSelector]) {
        if (getSafeKitObjectPerformExceptionCatch() == SafeKitObjectPerformExceptionCatchOn) {
            if ([self isSelectorReturnType:aSelector]) {
                typedef id (*MethodType)(id, SEL);
                MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
                return methodToCall(self, aSelector);
            }
            else {
                typedef void (*MethodType)(id, SEL);
                MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
                methodToCall(self, aSelector);
                return nil;
            }
        }
        else {
            if ([self isSelectorReturnType:aSelector]) {
                typedef id (*MethodType)(id, SEL);
                MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
                return methodToCall(self, aSelector);
            }
            else {
                typedef void (*MethodType)(id, SEL);
                MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
                methodToCall(self, aSelector);
                return nil;
            }
        }
    }
    else {
        XTSCLOG(@"%@", [NSString stringWithFormat:@"[%@ %@] unrecognized selector sent to instance ", [[self class]description], NSStringFromSelector(aSelector)]);
    }
    return nil;
}

- (id)SKperformSelector:(SEL)aSelector withObject:(id)object {
    if ([self respondsToSelector:aSelector]) {
        if (getSafeKitObjectPerformExceptionCatch() == SafeKitObjectPerformExceptionCatchOn) {
            SK_TRY_BODY(
                if ([self isSelectorReturnType:aSelector]) {
                    typedef id (*MethodType)(id, SEL, id);
                    MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
                    return methodToCall(self, aSelector, object);
                }
                else {
                    typedef void (*MethodType)(id, SEL, id);
                    MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
                    methodToCall(self, aSelector, object);
                    return nil;
                })
        }
        else {
            if ([self isSelectorReturnType:aSelector]) {
                typedef id (*MethodType)(id, SEL, id);
                MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
                return methodToCall(self, aSelector, object);
            }
            else {
                typedef void (*MethodType)(id, SEL, id);
                MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
                methodToCall(self, aSelector, object);
                return nil;
            }
        }
    }
    else {
        XTSCLOG(@"%@", [NSString stringWithFormat:@"[%@ %@] unrecognized selector sent to instance ", [[self class]description], NSStringFromSelector(aSelector)]);
    }
    return nil;
}

- (id)SKperformSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2 {
    if ([self respondsToSelector:aSelector]) {
        if (getSafeKitObjectPerformExceptionCatch() == SafeKitObjectPerformExceptionCatchOn) {
            SK_TRY_BODY(
                if ([self isSelectorReturnType:aSelector]) {
                    typedef id (*MethodType)(id, SEL, id, id);
                    MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
                    return methodToCall(self, aSelector, object1, object2);
                }
                else {
                    typedef void (*MethodType)(id, SEL, id, id);
                    MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
                    methodToCall(self, aSelector, object1, object2);
                    return nil;
                })
        }
        else {
            if ([self isSelectorReturnType:aSelector]) {
                typedef id (*MethodType)(id, SEL, id, id);
                MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
                return methodToCall(self, aSelector, object1, object2);
            }
            else {
                typedef void (*MethodType)(id, SEL, id, id);
                MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
                methodToCall(self, aSelector, object1, object2);
                return nil;
            }
        }
    }
    else {
        XTSCLOG(@"%@", [NSString stringWithFormat:@"[%@ %@] unrecognized selector sent to instance ", [[self class]description], NSStringFromSelector(aSelector)]);
    }
    return nil;
}

- (BOOL)isSelectorReturnType:(SEL)aSelector {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    if (signature) {
        const char *returnType = signature.methodReturnType;
        if (!strcmp(returnType, @encode(void))) {
            return NO;
        }
        else {
            return YES;
        }
    }
    return NO;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleClassMethod:@selector(performSelector:) withMethod:@selector(SKperformSelector:)];
        [self swizzleClassMethod:@selector(performSelector:withObject:) withMethod:@selector(SKperformSelector:withObject:)];
        [self swizzleClassMethod:@selector(performSelector:withObject:withObject:) withMethod:@selector(SKperformSelector:withObject:withObject:)];
    });
}

@end

