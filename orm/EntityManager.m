#import "EntityManager.h"

@implementation EntityManager

@synthesize managedEntities;
@synthesize databaseConnection;

- (instancetype)init {
    self = [super init];

    if (self) {
        self.managedEntities = [NSMutableArray array];
        self.databaseConnection = [DatabaseConnection instantiate];
    }

    return self;
}

+ (instancetype)instantiate {
    return [[self alloc] init];
}

- (void)insert:(id)anObject {
    [managedEntities addObject:[ManagedEntity instantiateWithObject:anObject andAction:ACTION_INSERT]];
}

- (void)update:(id)anObject {
    [managedEntities addObject:[ManagedEntity instantiateWithObject:anObject andAction:ACTION_UPDATE]];
}

- (void)remove:(id)anObject {
    [managedEntities addObject:[ManagedEntity instantiateWithObject:anObject andAction:ACTION_REMOVE]];
}

- (void)flush {
    // For each managed entity
    for(ManagedEntity *managedEntity in managedEntities) {
        switch ([managedEntity action]) {
            case ACTION_INSERT:
                [self insertManagedEntity:managedEntity];
                break;

            case ACTION_UPDATE:
                [self updateManagedEntity:managedEntity];
                break;

            case ACTION_REMOVE:
                [self removeManagedEntity:managedEntity];
                break;

            default:
                break;
        }
    }

    // Empty the managed entities list
    self.managedEntities = [NSMutableArray array];
}

- (void)insertManagedEntity:(ManagedEntity *)managedEntity {
    QueryBuilder *qb = [QueryBuilder instantiate];
    NSMutableArray *entities = [@[managedEntity] mutableCopy];

    // Find dependencies
    NSMutableArray *queries = [NSMutableArray array];
    NSUInteger i = 0;

    while (i < [entities count]) {
        NSArray *columns = [entities[i] columnsDefinitions];

        [qb create:[entities[i] table] withColumns:columns];
        [queries addObject:[qb query]];
        [qb reset];

        NSArray *dependencies = [entities[i] dependenciesForAction:ACTION_INSERT];

        for (ManagedEntity *dependency in dependencies) {
            if (![entities containsObject:dependency]) {
                [entities addObject:dependency];
            }
        }

        i++;
    }

    // Create tables
    for (NSString *query in [queries reverseObjectEnumerator]) {
        [[self databaseConnection] execute:query];
    }

    // Insert values
    for (ManagedEntity *entity in [entities reverseObjectEnumerator]) {
        [[[qb insertInto:[entity table]] fields:[entity columnsNames]] values:[DataExtractor getColumnsValuesFromObject:[entity object] andKeys:[entity keys]]];
        [[self databaseConnection] execute:[qb query]];
        [qb reset];

        [[entity object] setValue:[[self databaseConnection] getLastInsertId] forKey:PRIMARY_KEY];
    }
}

- (void)updateManagedEntity:(ManagedEntity *)managedEntity {
    QueryBuilder *qb = [QueryBuilder instantiate];
    NSMutableArray *entities = [@[managedEntity] mutableCopy];

    // Find dependencies
    NSUInteger i = 0;

    while (i < [entities count]) {
        NSArray *dependencies = [entities[i] dependenciesForAction:ACTION_INSERT];

        for (ManagedEntity *dependency in dependencies) {
            if (![entities containsObject:dependency]) {
                [entities addObject:dependency];
            }
        }

        i++;
    }

    // Update values
    for (ManagedEntity *entity in [entities reverseObjectEnumerator]) {
        [[[[qb update:[entity table]] set:[entity data]] where:PRIMARY_KEY] is:entity.primaryKey];

        [[self databaseConnection] execute:[qb query]];
        [qb reset];
    }
}

- (void)removeManagedEntity:(ManagedEntity *)managedEntity {
    QueryBuilder *qb = [QueryBuilder instantiate];
    NSMutableArray *entities = [@[managedEntity] mutableCopy];

    // Find dependencies
    NSUInteger i = 0;

    while (i < [entities count]) {
        NSArray *dependencies = [entities[i] dependenciesForAction:ACTION_INSERT];

        for (ManagedEntity *dependency in dependencies) {
            if (![entities containsObject:dependency]) {
                [entities addObject:dependency];
            }
        }

        i++;
    }

    // Remove values
    for (ManagedEntity *entity in [entities reverseObjectEnumerator]) {
        [[[[qb delete] from:[entity table]] where:PRIMARY_KEY] is:entity.primaryKey];
        [[self databaseConnection] execute:[qb query]];
        [qb reset];
    }
}

- (NSArray *)find:(Class)entityClass withCondition:(NSString *)condition {
    QueryBuilder *qb = [QueryBuilder instantiate];

    // Generate the select query
    [[[[qb select] all] from:[DataExtractor getClassName:entityClass]] spaceOut:condition];

    // Execute the query and return the result
    NSArray *results = [[self databaseConnection] getResultForQuery:[qb query]];
    [qb reset];

    NSMutableArray *entities = [NSMutableArray array];
    NSString* suffix = [NSString stringWithFormat:@"_%@", PRIMARY_KEY];

    for (NSDictionary *result in results) {
        id entity = [[entityClass alloc] init];

        for (NSString *key in [result allKeys]) {
            id value = [result valueForKey:key];

            if ([key hasSuffix:suffix]) {
                NSString *dependencyName = [key stringByReplacingOccurrencesOfString:suffix withString:@""];
                Class dependencyClass = [[entity valueForKey:dependencyName] class];

                NSArray *dependency = [self find:dependencyClass withCondition:[[[qb where:PRIMARY_KEY] is:value] query]];
                [qb reset];

                [entity setValue:dependency[0] forKey:dependencyName];
            }

            else {
                [entity setValue:value forKey:key];
            }
        }

        [entities addObject:entity];
    }

    return entities;
}

@end
