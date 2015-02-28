#import "ManagedEntity.h"

@implementation ManagedEntity

@synthesize object;
@synthesize action;
@synthesize priority;

- (instancetype)initWithObject:(NSObject *)anObject andAction:(ActionType)anAction {
    self = [super init];

    if (self) {
        self.object = anObject;
        self.action = anAction;
        self.priority = 0;
    }

    return self;
}

+ (instancetype)instantiateWithObject:(NSObject *)anObject andAction:(ActionType)anAction {
    return [[self alloc] initWithObject:anObject andAction:anAction];
}

- (NSString *)table {
    return [DataExtractor getObjectName:[self object]];
}

- (id)primaryKey {
    return [DataExtractor getIdFromObject:[self object]];
}

- (NSMutableArray *)keys {
    return [DataExtractor getKeysFromObject:[self object]];
}

- (NSMutableArray *)values {
    return [DataExtractor getValuesFromObject:[self object] andKeys:[self keys]];
}

- (NSMutableDictionary *)data {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSMutableArray *keys = [self keys];
    NSMutableArray *finalKeys = [NSMutableArray array];

    for (NSString *key in keys) {
        if (![[DataExtractor getType:[[self object] valueForKey:key]] isEqualToString:INVERSED]) {
            [finalKeys addObject:key];
        }
    }

    NSMutableArray *columns = [self columnsNames];
    NSMutableArray *values = [DataExtractor getColumnsValuesFromObject:[self object] andKeys:keys];
    NSUInteger total = [finalKeys count];

    for (unsigned int i = 0; i < total; i++) {
        [data setValue:values[i] forKey:columns[i]];
    }

    return data;
}

- (NSMutableArray *)valuesWithRelations {
    return [DataExtractor getColumnsValuesFromObject:[self object] andKeys:[self keys]];
}

- (NSArray *)dependenciesForAction:(enum ActionType)anAction {
    NSMutableArray *dependencies = [NSMutableArray array];

    NSMutableArray *keys = [self keys];
    NSMutableArray *values = [self values];
    NSUInteger total = [keys count];

    for (unsigned int i = 0; i < total; i++) {
        NSString *type = [DataExtractor getType:values[i]];

        // One to one
        if ([type isEqualToString:FOREIGN_KEY]) {
            ManagedEntity *dependency = [ManagedEntity instantiateWithObject:values[i] andAction:anAction];
            [dependency setPriority:[self priority] + 1];

            [dependencies addObject:dependency];
        }

        // One to many
        else if ([type isEqualToString:INVERSED]) {
            for (id value in values[i]) {
                ManagedEntity *dependency = [ManagedEntity instantiateWithObject:value andAction:anAction];
                [dependency setPriority:[self priority] - 1];

                [dependencies addObject:dependency];
            }
        }
    }

    return dependencies;
}

- (NSMutableArray *)columnsDefinitionsWithConnector:(id<DatabaseConnection>)connector {
    NSMutableArray *definitions = [NSMutableArray array];

    // Primary key
    [definitions addObject:[NSString stringWithFormat:@"%@ INTEGER PRIMARY KEY %@", PRIMARY_KEY, [connector getAutoIncrementKeyword]]];

    // Objects keys and values
    NSMutableArray *keys = [self keys];
    NSMutableArray *values = [self values];

    // Columns definitions
    NSUInteger total = [keys count];

    for (unsigned int i = 0; i < total; i++) {
        NSString *type = [DataExtractor getType:values[i]];

        // OneToMany : foreign key will be set in the other table
        if ([type isEqualToString:INVERSED]) {
            continue;
        }

        // OneToOne, or ManyToOne : set the foreign key
        if ([type isEqualToString:FOREIGN_KEY]) {
            [definitions addObject:[NSString stringWithFormat:@"%@_%@ INTEGER", keys[i], PRIMARY_KEY]];
            [definitions addObject:[NSString stringWithFormat:@"FOREIGN KEY(%1$@_%2$@) REFERENCES %1$@(%2$@)", keys[i], PRIMARY_KEY]];
        }

        // Classic column
        else {
            [definitions addObject:[NSString stringWithFormat:@"%@ %@", keys[i], type]];
        }
    }

    return definitions;
}

- (NSMutableArray *)columnsNames {
    NSMutableArray *names = [NSMutableArray array];

    // Objects keys and values
    NSMutableArray *keys = [self keys];
    NSMutableArray *values = [self values];

    // Columns names
    NSUInteger total = [keys count];

    for (unsigned int i = 0; i < total; i++) {
        NSString *type = [DataExtractor getType:values[i]];

        // OneToMany
        if ([type isEqualToString:INVERSED]) {
            continue;
        }

        // OneToOne or ManyToOne
        if ([type isEqualToString:FOREIGN_KEY]) {
            [names addObject:[NSString stringWithFormat:@"%@_%@", keys[i], PRIMARY_KEY]];
        }

        // Classic column
        else {
            [names addObject:[NSString stringWithFormat:@"%@", keys[i]]];
        }
    }

    return names;
}

@end
