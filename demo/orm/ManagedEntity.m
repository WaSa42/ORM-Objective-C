#import "ManagedEntity.h"

@implementation ManagedEntity

@synthesize object;
@synthesize action;

- (instancetype)initWithObject:(NSObject *)anObject andAction:(ActionType)anAction {
    self = [super init];

    if (self) {
        self.object = anObject;
        self.action = anAction;
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
    NSMutableArray *values = [self values];
    NSUInteger total = [keys count];

    for (unsigned int i = 0; i < total; i++) {
        [data setValue:values[i] forKey:keys[i]];
    }

    return data;
}

- (NSArray *)dependenciesForAction:(enum ActionType)anAction {
    NSMutableArray *dependencies = [NSMutableArray array];

    NSMutableArray *values = [self values];
    NSUInteger total = [[self keys] count];

    for (unsigned int i = 0; i < total; i++) {
        if ([[DataExtractor getType:values[i]] isEqualToString:FOREIGN_KEY]) {
            [dependencies addObject:[ManagedEntity instantiateWithObject:values[i] andAction:anAction]];
        }
    }

    return dependencies;
}

- (NSMutableArray *)columnsDefinitions {
    NSMutableArray *definitions = [NSMutableArray array];

    [definitions addObject:[NSString stringWithFormat:@"%@ INTEGER PRIMARY KEY AUTOINCREMENT", PRIMARY_KEY]];

    NSMutableArray *keys = [self keys];
    NSUInteger total = [keys count];

    for (unsigned int i = 0; i < total; i++) {
        NSString *type = [DataExtractor getType:self.values[i]];

        if ([type isEqualToString:FOREIGN_KEY]) {
            [definitions addObject:[NSString stringWithFormat:@"%@_%@ INTEGER", keys[i], PRIMARY_KEY]];
            [definitions addObject:[NSString stringWithFormat:@"FOREIGN KEY(%1$@_%2$@) REFERENCES %1$@(%2$@)", keys[i], PRIMARY_KEY]];
        }

        else {
            [definitions addObject:[NSString stringWithFormat:@"%@ %@", keys[i], type]];
        }
    }

    return definitions;
}

- (NSMutableArray *)columnsNames {
    NSMutableArray *names = [NSMutableArray array];

    NSMutableArray *keys = [self keys];
    NSMutableArray *values = [self values];
    NSUInteger total = [keys count];

    for (unsigned int i = 0; i < total; i++) {
        NSString *type = [DataExtractor getType:values[i]];

        if ([type isEqualToString:FOREIGN_KEY]) {
            [names addObject:[NSString stringWithFormat:@"%@_%@", keys[i], PRIMARY_KEY]];
        }

        else {
            [names addObject:[NSString stringWithFormat:@"%@", keys[i]]];
        }
    }

    return names;
}

@end
