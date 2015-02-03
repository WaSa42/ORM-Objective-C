#import "EntityManager.h"

@implementation EntityManager

    @synthesize managedObjects;

- (instancetype)init {
    self = [super init];

    if (self) {
        self.managedObjects = [NSMutableArray array];
    }

    return self;
}

+ (instancetype)instantiate {
    return [[self alloc] init];
}

- (void)insert:(id)anObject {
    [managedObjects addObject:[ManagedObject objectWithObject:anObject andAction: ACTION_INSERT]];
}

- (void)update:(id)anObject {
    [managedObjects addObject:[ManagedObject objectWithObject:anObject andAction: ACTION_UPDATE]];
}

- (void)remove:(id)anObject {
    [managedObjects addObject:[ManagedObject objectWithObject:anObject andAction: ACTION_REMOVE]];
}

- (void)flush {
    QueryBuilder *qb = [QueryBuilder instantiate];

    for(ManagedObject *managedObject in managedObjects) {
        NSString *table = [DataExtractor getTableFromObject:[managedObject object]];
        NSArray *keys, *values;

        switch (managedObject.action) {
            case ACTION_INSERT:
                keys = [DataExtractor getKeysFromObject:[managedObject object]];
                values = [DataExtractor getValuesFromObject:[managedObject object] andKeys:keys];

                [[[qb insertInto:table] fields:keys] values: values];
                break;

            case ACTION_UPDATE:

                break;

            case ACTION_REMOVE:

                break;

            default:
                break;
        }

        NSLog(@"%@", [qb query]);
        [qb reset];
    }
}

@end
