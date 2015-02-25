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

    for(ManagedEntity *managedEntity in managedEntities) {
        if (managedEntity.action != ACTION_REMOVE) {
            [qb create:[managedEntity table] withFields:[managedEntity keys] andValues:[managedEntity values]];
            [self.databaseConnection execute:[qb query]];
            [qb reset];
        }

        switch (managedEntity.action) {
            case ACTION_INSERT:
                [[[qb insertInto:[managedEntity table]] fields:[managedEntity keys]] values:[managedEntity values]];
                break;

            case ACTION_UPDATE:
                [[[[qb update:[managedEntity table]] set:[managedEntity data]] where:PRIMARY_KEY] is:managedEntity.primaryKey];
                break;

            case ACTION_REMOVE:
                [[[[qb delete] from:[managedEntity table]] where:PRIMARY_KEY] is:managedEntity.primaryKey];
                break;

            default:
                break;
        }

        [self.databaseConnection execute:[qb query]];
        [qb reset];
        
        if (managedEntity.action == ACTION_INSERT) {
            managedEntity.primaryKey = [[self databaseConnection] getLastInsertId];
            [[managedEntity object] setValue:managedEntity.primaryKey forKey:PRIMARY_KEY];
        }
    }

    self.managedEntities = [NSMutableArray array];
}

@end
