#import "ManagedEntity.h"

@implementation ManagedEntity

@synthesize object;
@synthesize action;
@synthesize table;
@synthesize data;
@synthesize keys;
@synthesize values;
@synthesize primaryKey;

- (instancetype)initWithObject:(NSObject *)anObject andAction:(ActionType)anAction {
    self = [super init];

    if (self) {
        self.object = anObject;
        self.action = anAction;
        self.table = [DataExtractor getObjectName:[self object]];
        self.data = [NSMutableDictionary dictionary];

        if (self.action != ACTION_INSERT) {
            self.primaryKey = [DataExtractor getIdFromObject:[self object]];
        }

        if (self.action != ACTION_REMOVE) {
            self.keys = [DataExtractor getKeysFromObject:[self object]];
            self.values = [DataExtractor getValuesFromObject:[self object] andKeys:[self keys]];
        }

        if (self.action == ACTION_UPDATE) {
            for (unsigned int i = 0; i < [self.keys count]; i++) {
                [self.data setValue:self.values[i] forKey:self.keys[i]];
            }
        }
    }

    return self;
}

+ (instancetype)instantiateWithObject:(NSObject *)anObject andAction:(ActionType)anAction {
    return [[self alloc] initWithObject:anObject andAction:anAction];
}

- (NSArray *)getColumnsDefinitions {
    NSMutableArray *columns = [NSMutableArray array];

    [columns addObject:[NSString stringWithFormat:@"%@ INTEGER PRIMARY KEY AUTOINCREMENT", PRIMARY_KEY]];

    for (unsigned int i = 0; i < [[self keys] count]; i++) {
        NSString *type = [DataExtractor getType:self.values[i]];

        if ([type isEqualToString:FOREIGN_KEY]) {
            [columns addObject:[NSString stringWithFormat:@"%@_%@ INTEGER", self.keys[i], PRIMARY_KEY]];
            [columns addObject:[NSString stringWithFormat:@"FOREIGN KEY(%@_%@) REFERENCES %@(%@)", self.keys[i], PRIMARY_KEY, self.keys[i], PRIMARY_KEY]];
        }

        else {
            [columns addObject:[NSString stringWithFormat:@"%@ %@", self.keys[i], type]];
        }
    }

    return columns;
}

- (NSArray *)getDependencies {
    NSMutableArray *dependencies = [NSMutableArray array];

    for (unsigned int i = 0; i < [[self keys] count]; i++) {
        NSString *type = [DataExtractor getType:self.values[i]];

        if ([type isEqualToString:FOREIGN_KEY]) {
            [dependencies addObject:self.values[i]];
        }
    }

    return dependencies;
}

@end
