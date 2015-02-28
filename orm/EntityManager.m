#import "EntityManager.h"

@implementation EntityManager

@synthesize managedEntities;
@synthesize databaseConnection;

- (instancetype)initWithConnector:(Class)connector andParameters:(NSMutableDictionary *)parameters {
    self = [super init];

    if (self) {
        self.managedEntities = [NSMutableArray array];

        if (![connector conformsToProtocol:@protocol(DatabaseConnection)]) {
            [NSException raise:@"Invalid connector" format:@"The connector must be conform to the DatabaseConnection protocol"];
        }

        self.databaseConnection = [connector initWithParameters:parameters];
        [[self databaseConnection] connect];
    }

    return self;
}

+ (instancetype)instantiateWithConnector:(Class)connector andParameters:(NSMutableDictionary *)parameters {
    return [[self alloc] initWithConnector:connector andParameters:parameters];
}

- (void)persist:(id)anObject {
    [self.managedEntities addObject:[ManagedEntity instantiateWithObject:anObject andAction:ACTION_PERSIST]];
}

- (void)remove:(id)anObject {
    [self.managedEntities addObject:[ManagedEntity instantiateWithObject:anObject andAction:ACTION_REMOVE]];
}

- (void)flush {
    // For each managed entity
    for(ManagedEntity *managedEntity in self.managedEntities) {
        switch ([managedEntity action]) {
            case ACTION_PERSIST:
                [self persistManagedEntity:managedEntity];
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

- (void)persistManagedEntity:(ManagedEntity *)managedEntity {
    QueryBuilder *qb = [QueryBuilder instantiate];
    NSMutableArray *entities = [@[managedEntity] mutableCopy];
    NSMutableArray *tables = [NSMutableArray array];

    // Find dependencies
    NSMutableArray *queries = [NSMutableArray array];
    NSUInteger i = 0;

    while (i < [entities count]) {
        // Generate CREATE TABLE query
        if (![tables containsObject:[entities[i] table]]) {
            NSArray *columns = [entities[i] columnsDefinitionsWithConnector:self.databaseConnection];

            [qb create:[entities[i] table] withColumns:columns];
            [queries addObject:[qb query]];
            [qb reset];

            [tables addObject:[entities[i] table]];
        }

        // Find dependencies
        NSArray *dependencies = [entities[i] dependenciesForAction:ACTION_PERSIST];

        for (ManagedEntity *dependency in dependencies) {
            BOOL new = YES;

            for (ManagedEntity *entity in entities) {
                if ([dependency object] == [entity object]) {
                    new = NO;
                    break;
                }
            }

            if (new) {
                [entities addObject:dependency];
            }
        }

        i++;
    }

    // Create tables
    for (NSString *query in [queries reverseObjectEnumerator]) {
        [[self databaseConnection] execute:query];
    }

    // Sort entities
    NSArray *sortedEntities;

    sortedEntities = [entities sortedArrayUsingComparator:^NSComparisonResult(ManagedEntity *a, ManagedEntity *b) {
        return (NSComparisonResult) ([a priority] < [b priority]);
    }];

    // Persist entities
    for (ManagedEntity *entity in sortedEntities) {
        BOOL insert = [[NSString stringWithFormat:@"%@", [entity primaryKey]] isEqualToString:@"0"];

        // Generate INSERT query
        if (insert) {
            [[[qb insertInto:[entity table]] fields:[entity columnsNames]] values:[entity valuesWithRelations]];
        }

        // Generate UPDATE query
        else {
            [[[[qb update:[entity table]] set:[entity data]] where:PRIMARY_KEY] is:entity.primaryKey];
        }

        // Execute the query
        [[self databaseConnection] execute:[qb query]];
        [qb reset];

        // Update the primary key
        if (insert) {
            [[entity object] setValue:[[self databaseConnection] getLastInsertId] forKey:PRIMARY_KEY];
        }
    }
}

- (void)removeManagedEntity:(ManagedEntity *)managedEntity {
    QueryBuilder *qb = [QueryBuilder instantiate];
    NSMutableArray *entities = [@[managedEntity] mutableCopy];

    // Find dependencies
    NSUInteger i = 0;

    while (i < [entities count]) {
        NSArray *dependencies = [entities[i] dependenciesForAction:ACTION_REMOVE];

        for (ManagedEntity *dependency in dependencies) {
            BOOL new = YES;

            for (ManagedEntity *entity in entities) {
                if ([dependency object] == [entity object]) {
                    new = NO;
                    break;
                }
            }

            if (new) {
                [entities addObject:dependency];
            }
        }

        i++;
    }

    // Sort entities
    NSArray *sortedEntities;

    sortedEntities = [entities sortedArrayUsingComparator:^NSComparisonResult(ManagedEntity *a, ManagedEntity *b) {
        return (NSComparisonResult) ([a priority] > [b priority]);
    }];

    // Remove values
    for (ManagedEntity *entity in sortedEntities) {
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
