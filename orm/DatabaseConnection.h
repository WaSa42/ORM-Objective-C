#import <Foundation/Foundation.h>

@protocol DatabaseConnection <NSObject>

+ (id)initWithParameters:(NSDictionary *)parameters;

- (NSString *)getAutoIncrementKeyword;
- (void)connect;
- (void)execute:(NSString *)query;
- (id)getLastInsertId;
- (NSArray *)getResultForQuery:(NSMutableString *)query;

@optional
- (void)dealloc;

@end
