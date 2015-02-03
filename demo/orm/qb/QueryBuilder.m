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

- (instancetype)select {
    [self spaceOut:SELECT];

    return self;
}

- (instancetype)all {
    [self spaceOut:ALL];

    return self;
}

- (instancetype)field:(NSString *)field {
    [self wrap:field];

    return self;
}

- (instancetype)fields:(NSArray *)fields {
    [self wrap:[fields componentsJoinedByString:JOINER]];

    return self;
}


- (instancetype)from:(NSString *)table {
    [self spaceOut:FROM];
    [self wrap:table];

    return self;
}


- (instancetype)insertInto:(NSString *)table {
    [self spaceOut:INSERT];
    [self wrap:table];

    return self;
}

- (instancetype)values:(NSArray *)values {
    [self spaceOut:VALUES];
    [self wrap:[values componentsJoinedByString:JOINER]];

    return self;
}

- (instancetype)where:(NSString *)field {
    [self spaceOut:WHERE];
    [self wrap:field];

    return self;
}

- (instancetype)andWhere:(NSString *)field {
    [self spaceOut:AND];
    [self wrap:field];

    return self;
}

- (instancetype)orWhere:(NSString *)field {
    [self spaceOut:OR];
    [self wrap:field];

    return self;
}

- (instancetype)is:(NSString *)value {
    [self spaceOut:IS];
    [self wrap:value];

    return self;
}

- (instancetype)isNot:(NSString *)value {
    [self spaceOut:IS_NOT];
    [self wrap:value];

    return self;
}

- (instancetype)isIn:(NSArray *)values {
    [self spaceOut:IN];
    [self wrap:[values componentsJoinedByString:JOINER]];

    return self;
}

- (instancetype)isNotIn:(NSArray *)values {
    [self spaceOut:NOT_IN];
    [self wrap:[values componentsJoinedByString:JOINER]];

    return self;
}

- (void)spaceOut:(NSString *)value {
    [query appendFormat:@"%@ ", value];
}

- (void)wrap:(NSString *)value {
    [query appendFormat:@"('%@') ", value];
}

- (void)reset {
    self.query = [NSMutableString string];
}

@end
