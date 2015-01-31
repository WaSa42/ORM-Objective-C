#import <Foundation/Foundation.h>

@interface QueryBuilder : NSObject {
    NSMutableString *query;
}

@property NSMutableString *query;

- (instancetype)init;
+ (instancetype)instantiate;

- (instancetype)selectField:(NSString *)field;
- (instancetype)selectFields:(NSArray *)fields;
- (instancetype)selectAll;
- (instancetype)from:(NSString *)table;

- (instancetype)where:(NSString *)field;
- (instancetype)andWhere:(NSString *)field;
- (instancetype)orWhere:(NSString *)field;

- (instancetype)is:(NSString *)value;
- (instancetype)isNot:(NSString *)value;
- (instancetype)isIn:(NSArray *)values;
- (instancetype)isNotIn:(NSArray *)values;

- (void)reset;

@end
