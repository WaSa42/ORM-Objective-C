#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define PRIMARY_KEY         @"id"
#define FOREIGN_KEY         @"FOREIGN KEY"
#define FOREIGN_KEY_SUFFIX  @"_id"

@interface DataExtractor : NSObject

+ (NSString *)getObjectName:(id)object;
+ (NSString *)getClassName:(Class)name;
+ (NSMutableArray *)getKeysFromObject:(id)object;
+ (NSMutableArray *)getValuesFromObject:(id)object andKeys:(NSMutableArray *)keys;
+ (id)getIdFromObject:(id)object;
+ (NSString *)getType:(id)object;
+ (NSMutableArray *)getColumnsValuesFromObject:(id)object andKeys:(NSMutableArray *)keys;

@end
