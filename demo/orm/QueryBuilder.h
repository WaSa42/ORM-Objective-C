#import <Foundation/Foundation.h>

@interface QueryBuilder : NSObject {
    NSMutableString *query;
}

@property NSMutableString *query;

- (instancetype)init;
+ (instancetype)instantiate;

- (void)select:(NSArray *)fields;

@end
