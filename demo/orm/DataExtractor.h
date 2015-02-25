#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define PRIMARY_KEY @"id"

@interface DataExtractor : NSObject

+ (NSString *)getObjectName:(id)object;
+ (NSMutableArray *)getKeysFromObject:(id)object;
+ (NSMutableArray *)getValuesFromObject:(id)object andKeys:(NSMutableArray *)keys;
+ (id)getIdFromObject:(id)object;
+ (NSString *)getType:(id)object;

@end
