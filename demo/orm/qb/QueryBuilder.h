#import <Foundation/Foundation.h>

#define SELECT      @"SELECT"
#define ALL         @"*"
#define FROM        @"FROM"
#define INSERT      @"INSERT INTO"
#define UPDATE      @"UPDATE"
#define VALUES      @"VALUES"
#define SET         @"SET"
#define DELETE      @"DELETE"
#define WHERE       @"WHERE"
#define AND         @"AND"
#define OR          @"OR"
#define IS          @"="
#define IS_NOT      @"IS NOT"
#define IN          @"IN"
#define NOT_IN      @"NOT IN"
#define JOINER      @", "

#define FORMAT_AFFECT           @"%@ = %@"
#define FORMAT_WRAP_PARENTHESIS @"(%@) "
#define FORMAT_WRAP_QUOTES      @"'%@' "


@interface QueryBuilder : NSObject {
    NSMutableString *query;
}

@property NSMutableString *query;

- (instancetype)init;
+ (instancetype)instantiate;

- (instancetype)select;
- (instancetype)all;

- (instancetype)field:(NSString *)field;
- (instancetype)fields:(NSArray *)fields;

- (instancetype)from:(NSString *)table;
- (instancetype)insertInto:(NSString *)table;
- (instancetype)update:(NSString *)table;
- (instancetype)values:(NSArray *)values;
- (instancetype)set:(NSDictionary *)data;
- (instancetype)delete;

- (instancetype)where:(NSString *)field;
- (instancetype)andWhere:(NSString *)field;
- (instancetype)orWhere:(NSString *)field;

- (instancetype)is:(NSString *)value;
- (instancetype)isNot:(NSString *)value;
- (instancetype)isIn:(NSArray *)values;
- (instancetype)isNotIn:(NSArray *)values;

+ (NSString *)wrap:(NSString *)value withParenthesis:(BOOL)withParenthesis;
+ (NSString *)wrap:(NSString *)value;
+ (NSArray *)wrapValues:(NSArray *)values;

- (void)spaceOut:(NSString *)value;
- (void)wrap:(NSString *)value withParenthesis:(BOOL)withParenthesis;
- (void)wrap:(NSString *)value;

- (void)reset;

@end
