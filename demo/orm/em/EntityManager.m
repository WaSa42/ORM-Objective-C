#import "EntityManager.h"

@implementation EntityManager

    @synthesize managedEntities;

- (instancetype)init {
    self = [super init];

    if (self) {
        self.managedEntities = [NSMutableArray array];
    }

    return self;
}

+ (instancetype)instantiate {
    return [[self alloc] init];
}

- (void)insert:(id)anObject {
    [managedEntities addObject:[ManagedEntity objectWithObject:anObject andAction:ACTION_INSERT]];
}

- (void)update:(id)anObject {
    [managedEntities addObject:[ManagedEntity objectWithObject:anObject andAction:ACTION_UPDATE]];
}

- (void)remove:(id)anObject {
    [managedEntities addObject:[ManagedEntity objectWithObject:anObject andAction:ACTION_REMOVE]];
}

- (void)flush {
    QueryBuilder *qb = [QueryBuilder instantiate];
    NSMutableArray *queries = [NSMutableArray array];

    for(ManagedEntity *managedObject in managedEntities) {
        NSString *table = [DataExtractor getTableFromObject:[managedObject object]];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        NSArray *keys, *values;
        id primaryKey;

        if (managedObject.action != ACTION_REMOVE) {
            keys = [DataExtractor getKeysFromObject:[managedObject object]];
            values = [DataExtractor getValuesFromObject:[managedObject object] andKeys:keys];
        }

        if (managedObject.action != ACTION_INSERT) {
            primaryKey = [DataExtractor getIdFromObject:[managedObject object]];
        }

        switch (managedObject.action) {
            case ACTION_INSERT:
                [[[qb insertInto:table] fields:keys] values: values];
                break;

            case ACTION_UPDATE:
                for(unsigned int i = 0; i < [keys count]; i++){
                    [data setValue:values[i] forKey:keys[i]];
                }

                [[[[qb update:table] set:data] where:PRIMARY_KEY] is:primaryKey];
                break;

            case ACTION_REMOVE:
                [[[[qb delete] from:table] where:PRIMARY_KEY] is:primaryKey];
                break;

            default:
                break;
        }

        [queries addObject:[qb query]];
        [qb reset];
    }

    NSLog(@"%@", [queries componentsJoinedByString:@";\n"]);
}

@end
