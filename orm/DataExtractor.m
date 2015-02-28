#import "DataExtractor.h"

@implementation DataExtractor

+ (NSString *)getObjectName:(id)object {
    return [self getClassName:[object class]];
}

+ (NSString *)getClassName:(Class)name {
    return [NSStringFromClass(name) lowercaseString];
}

+ (NSMutableArray *)getKeysFromObject:(id)object {
    unsigned int totalProperties;
    NSMutableArray *keys = [NSMutableArray array];
    objc_property_t *properties = class_copyPropertyList([object class], &totalProperties);

    for (unsigned int i = 0; i < totalProperties; i++) {
        objc_property_t currentProperty = properties[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(currentProperty)];

        if (![key isEqualToString:PRIMARY_KEY]) {
            [keys addObject:key];
        }
    }

    free(properties);

    return keys;
}

+ (NSMutableArray *)getValuesFromObject:(id)object andKeys:(NSMutableArray *)keys {
    NSMutableArray *values = [NSMutableArray array];

    for (NSString *key in keys) {
        [values addObject:[object valueForKey:key]];
    }

    return values;
}

+ (id)getIdFromObject:(id)object {
    return [object valueForKey:PRIMARY_KEY];
}

+ (NSString *)getType:(id)object {
    if ([object isKindOfClass:[NSString class]]) {
        return @"TEXT";
    }

    if ([object isKindOfClass:[NSNumber class]]) {
        return @"INTEGER";
    }

    return FOREIGN_KEY;
}

+ (NSMutableArray *)getColumnsValuesFromObject:(id)object andKeys:(NSMutableArray *)keys {
    NSMutableArray *values = [NSMutableArray array];

    for (NSString *key in keys) {
        if ([[self getType:[object valueForKey:key]] isEqualToString:FOREIGN_KEY]) {
            [values addObject:[self getIdFromObject:[object valueForKey:key]]];
        }

        else {
            [values addObject:[object valueForKey:key]];
        }
    }

    return values;
}

@end
