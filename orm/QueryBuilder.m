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
    [self wrap:[fields componentsJoinedByString:JOINER] withParenthesis:YES];

    return self;
}

- (instancetype)from:(NSString *)table {
    [self spaceOut:FROM];
    [self spaceOut:table];

    return self;
}

- (instancetype)insertInto:(NSString *)table {
    [self spaceOut:INSERT];
    [self spaceOut:table];

    return self;
}

- (instancetype)create:(NSString *)table withColumns:(NSArray *)values {
    [self spaceOut:CREATE];
    [self spaceOut:table];
    [self wrap:[values componentsJoinedByString:JOINER] withParenthesis:YES];

    return self;
}

- (instancetype)update:(NSString *)table {
    [self spaceOut:UPDATE];
    [self spaceOut:table];

    return self;
}

- (instancetype)values:(NSArray *)values {
    [self spaceOut:VALUES];
    [self wrap:[[[self class] wrapValues:values] componentsJoinedByString:JOINER] withParenthesis:YES];

    return self;
}

- (instancetype)set:(NSDictionary *)data {
    [self spaceOut:SET];
    BOOL first = YES;

    for (NSString* key in data) {
        // TODO: use componentsJoinedByString
        if (first) {
            first = NO;
        } else {
            [[self query] appendString:JOINER];
        }

        [self spaceOut:[NSString stringWithFormat:FORMAT_AFFECT, key, [QueryBuilder wrap:data[key]]]];
    }

    return self;
}

- (instancetype)delete {
    [self spaceOut:DELETE];

    return self;
}

- (instancetype)where:(NSString *)field {
    [self spaceOut:WHERE];
    [self spaceOut:field];

    return self;
}

- (instancetype)andWhere:(NSString *)field {
    [self spaceOut:AND];
    [self spaceOut:field];

    return self;
}

- (instancetype)orWhere:(NSString *)field {
    [self spaceOut:OR];
    [self spaceOut:field];

    return self;
}

- (instancetype)is:(id)value {
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
    [self wrap:[[[self class] wrapValues:values] componentsJoinedByString:JOINER] withParenthesis:YES];

    return self;
}

- (instancetype)isNotIn:(NSArray *)values {
    [self spaceOut:NOT_IN];
    [self wrap:[[[self class] wrapValues:values] componentsJoinedByString:JOINER] withParenthesis:YES];

    return self;
}

+ (NSString *)wrap:(NSString *)value withParenthesis:(BOOL)withParenthesis {
    return [NSString stringWithFormat:withParenthesis ? FORMAT_WRAP_PARENTHESIS : FORMAT_WRAP_QUOTES, value];
}

+ (NSString *)wrap:(NSString *)value {
    return [QueryBuilder wrap:value withParenthesis:NO];
}

+ (NSArray *)wrapValues:(NSArray *)values {
    NSMutableArray *results = [NSMutableArray array];

    for(id value in values){
        [results addObject:[QueryBuilder wrap:value]];
    }

    return results;
}

- (void)spaceOut:(NSString *)value {
    [query appendFormat:@"%@ ", value];
}

- (void)wrap:(NSString *)value withParenthesis:(BOOL)withParenthesis {
    [query appendString:[[self class] wrap:value withParenthesis:withParenthesis]];
}

- (void)wrap:(NSString *)value {
    [query appendString:[[self class] wrap:value withParenthesis:NO]];
}

- (void)reset {
    self.query = [NSMutableString string];
}

@end
