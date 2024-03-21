//
//  NSObject+Property.m
//  wealth
//
//  Created by wangyingjie on 15/7/22.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

@import ObjectiveC.runtime;

#import "NSObject+Property.h"

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end

@implementation NSObject (Property)

//
// Code from: http://stackoverflow.com/questions/754824/get-an-object-properties-list-in-objective-c
//

static const char *hay_getPropertyType(objc_property_t property)
{
    const char *attributes = property_getAttributes(property);

    char buffer[1 + strlen(attributes)];
    strcpy (buffer, attributes);
    char *state = buffer, *attribute;

    while ((attribute = strsep(&state, ",")) != NULL)
    {
        if (attribute[0] == 'T' && attribute[1] != '@')
        {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2)
        {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@')
        {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }

    return "";
}

- (NSDictionary *)hay_properties
{
    return [[self class] hay_classPropsFor:[self class]];
}

+ (NSDictionary *)hay_properties
{
    return [self hay_classPropsFor:self];
}

+ (NSDictionary *)hay_classPropsFor:(Class)class
{
    if (class == NULL)
    {
        return nil;
    }

    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];

    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);

    for (unsigned int i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        const char *propType = hay_getPropertyType(property);

        if (propName && propType)
        {
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            NSString *propertyType = [NSString stringWithUTF8String:propType];

            results[propertyName] = propertyType;
        }
    }

    free (properties);

    // returning a copy here to make sure the dictionary is immutable
    return [results copy];
}

- (BOOL)hay_isPropertyList
{
    return [[self class] isObjectPropertyListItem:self];
}

+ (BOOL)isObjectPropertyListItem:(id)object
{
    //
    // Recursively search for an element that could not be a property list.
    //
    if ([object isKindOfClass:[NSArray class]])
    {
        //
        // All items in array should be a property list
        //
        for (id value in object)
        {
            if (![self isObjectPropertyListItem:value])
            {
                return NO;
            }
        }

        return YES;
    }
    else if ([object isKindOfClass:[NSDictionary class]])
    {
        NSArray* keys = [object allKeys];

        //
        // All keys in dictionary must be strings
        //
        for (id key in keys)
        {
            if (![key isKindOfClass:[NSString class]])
            {
                return NO;
            }
        }

        //
        // All objects in dictionary must also be property lists.
        //

        NSArray* values = [object allValues];

        for (id value in values)
        {
            if (![self isObjectPropertyListItem:value])
            {
                return NO;
            }
        }

        return YES;
    }
    else if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSData class]] || [object isKindOfClass:[NSDate class]] || [object isKindOfClass:[NSNumber class]])
    {
        return YES;
    }

    return NO;
}

@end
