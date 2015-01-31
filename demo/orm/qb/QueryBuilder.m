#import "QueryBuilder.h"

@implementation QueryBuilder

    @synthesize query;

- (instancetype)init {
    self = [super init];

    if (self) {
        [self reset];
    }

    return self;
}

+ (instancetype)instantiate {
    return [[self alloc] init];
}

- (instancetype)selectField:(NSString *)field {
    [query appendString:@"SELECT '"];
    [query appendString:field];
    [query appendString:@"' "];

    return self;
}

- (instancetype)selectFields:(NSArray *)fields {
    [query appendString:@"SELECT '"];
    [query appendString:[fields componentsJoinedByString:@"', '"]];
    [query appendString:@"' "];

    return self;
}

- (instancetype)selectAll {
    [query appendString:@"SELECT * "];

    return self;
}


- (instancetype)from:(NSString *)table {
    [query appendString:@"FROM '"];
    [query appendString:table];
    [query appendString:@"' "];

    return self;
}

- (instancetype)where:(NSString *)field {
    [query appendString:@"WHERE '"];
    [query appendString:field];
    [query appendString:@"' "];

    return self;
}

- (instancetype)andWhere:(NSString *)field {
    [query appendString:@"AND '"];
    [query appendString:field];
    [query appendString:@"' "];

    return self;
}

- (instancetype)orWhere:(NSString *)field {
    [query appendString:@"OR '"];
    [query appendString:field];
    [query appendString:@"' "];

    return self;
}

- (instancetype)is:(NSString *)value {
    [query appendString:@"= '"];
    [query appendString:value];
    [query appendString:@"' "];

    return self;
}

- (instancetype)isNot:(NSString *)value {
    [query appendString:@"!"];

    return [self is:value];
}

- (instancetype)isIn:(NSArray *)values {
    [query appendString:@"IN ('"];
    [query appendString:[values componentsJoinedByString:@"', '"]];
    [query appendString:@"') "];

    return self;
}

- (instancetype)isNotIn:(NSArray *)values {
    [query appendString:@"NOT "];

    return [self isIn:values];
}

- (instancetype)select:(NSArray *)fields from:(NSString *)from {
    return nil;
}

- (void)reset {
    self.query = [NSMutableString string];
}


@end
