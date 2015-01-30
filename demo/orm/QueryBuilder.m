#import "QueryBuilder.h"

@implementation QueryBuilder

    @synthesize query;

- (instancetype)init {
    self = [super init];

    if (self) {
        self.query = [NSMutableString string];
    }

    return self;
}

+ (instancetype)instantiate {
    return [[self alloc] init];
}

- (void)select:(NSArray *)fields {
    [query appendString:@"SELECT '"];
    [query appendString:[fields componentsJoinedByString:@"', '"]];
    [query appendString:@"'"];
}

@end
