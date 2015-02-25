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

    // For each managed entity
    for(ManagedEntity *managedEntity in managedEntities) {
        switch ([managedEntity action]) {
            case ACTION_INSERT:
                // Create table if not exists
                [qb create:[managedEntity table] withFields:[managedEntity keys] andValues:[managedEntity values]];
                [self.databaseConnection execute:[qb query]];
                [qb reset];

                // Generate the insert query
                [[[qb insertInto:[managedEntity table]] fields:[managedEntity keys]] values:[managedEntity values]];
                break;

            case ACTION_UPDATE:
                // Generate the update query
                [[[[qb update:[managedEntity table]] set:[managedEntity data]] where:PRIMARY_KEY] is:managedEntity.primaryKey];
                break;

            case ACTION_REMOVE:
                // Generate the delete query
                [[[[qb delete] from:[managedEntity table]] where:PRIMARY_KEY] is:managedEntity.primaryKey];
                break;

            default:
                break;
        }

        // Execute the query (insert, update or remove)
        [[self databaseConnection] execute:[qb query]];
        [qb reset];

        // Update the primary key if we have performed an insert
        if ([managedEntity action] == ACTION_INSERT) {
            managedEntity.primaryKey = [[self databaseConnection] getLastInsertId];
            [[managedEntity object] setValue:managedEntity.primaryKey forKey:PRIMARY_KEY];
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

@end
