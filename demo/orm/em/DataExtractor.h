#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define PRIMARY_KEY @"id"

@interface DataExtractor : NSObject

+ (NSString *)getTableFromObject:(id)object;
+ (NSArray *)getKeysFromObject:(id)object;
+ (NSArray *)getValuesFromObject:(id)object andKeys:(NSArray *)keys;
+ (id)getIdFromObject:(id)object;

@end
