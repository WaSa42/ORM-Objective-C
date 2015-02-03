#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface DataExtractor : NSObject

+ (NSString *)getTableFromObject:(id)object;
+ (NSArray *)getKeysFromObject:(id)object;
+ (NSArray *)getValuesFromObject:(id)object andKeys:(NSArray *)keys;

@end
