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
                // Generate the delete query
//                [[[[qb delete] from:[managedEntity table]] where:PRIMARY_KEY] is:managedEntity.primaryKey];
                break;

            default:
                break;
        }
    }

    // Empty the managed entities list
    self.managedEntities = [NSMutableArray array];
}

- (NSArray *)find:(Class)entityClass withCondition:(NSString *)condition {
    QueryBuilder *qb = [QueryBuilder instantiate];

    // Generate the select query
    [[[[qb select] all] from:[DataExtractor getClassName:entityClass]] spaceOut:condition];

    // Execute the query and return the result
    return [[self databaseConnection] getResultForQuery:[qb query] andClass:entityClass];
}

- (void)insertManagedEntity:(ManagedEntity *)managedEntity {
    QueryBuilder *qb = [QueryBuilder instantiate];
    NSMutableArray *entities = [@[managedEntity] mutableCopy];

    // Create tables
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

    // Update values
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

    for (ManagedEntity *entity in [entities reverseObjectEnumerator]) {
        [[[[qb update:[entity table]] set:[entity data]] where:PRIMARY_KEY] is:entity.primaryKey];

        [[self databaseConnection] execute:[qb query]];
        [qb reset];
    }
}

@end
