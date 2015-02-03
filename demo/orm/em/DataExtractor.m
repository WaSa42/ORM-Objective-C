#import "DataExtractor.h"

@implementation DataExtractor

+ (NSString *)getTableFromObject:(id)object {
    return [NSStringFromClass([object class]) lowercaseString];
}

+ (NSArray *)getKeysFromObject:(id)object {
    unsigned int totalProperties;
    NSMutableArray *keys = [NSMutableArray array];
    objc_property_t *properties = class_copyPropertyList([object class], &totalProperties);

    for(unsigned int i = 0; i < totalProperties; i++) {
        objc_property_t currentProperty = properties[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(currentProperty)];

        if (![key isEqualToString:PRIMARY_KEY]) {
            [keys addObject:key];
        }
    }

    free(properties);

    return keys;
}

+ (NSArray *)getValuesFromObject:(id)object andKeys:(NSArray *)keys {
    NSMutableArray *values = [NSMutableArray array];

    for(NSString *key in keys) {
        [values addObject:[object valueForKey:key]];
    }

    return values;
}

+ (id)getIdFromObject:(id)object {
    return [object valueForKey:PRIMARY_KEY];
}

@end
