#import <Foundation/Foundation.h>

#import "Action.h"
#import "DataExtractor.h"
#import "ManagedEntity.h"
#import "QueryBuilder.h"
#import "DatabaseConnection.h"
#import "SQLiteDatabaseConnection.h"
#import "MySQLDatabaseConnection.h"

@interface EntityManager : NSObject {
    NSMutableArray *managedEntities;
    id<DatabaseConnection> databaseConnection;
}

@property (nonatomic) NSMutableArray *managedEntities;
@property (nonatomic) id<DatabaseConnection> databaseConnection;

- (instancetype)initWithConnector:(Class)connector andParameters:(NSMutableDictionary *)parameters;
+ (instancetype)instantiateWithConnector:(Class)connector andParameters:(NSMutableDictionary *)parameters;

- (void)insert:(id)anObject;
- (void)update:(id)anObject;
- (void)remove:(id)anObject;
- (void)flush;

- (void)insertManagedEntity:(ManagedEntity *)managedEntity;
- (void)updateManagedEntity:(ManagedEntity *)managedEntity;
- (void)removeManagedEntity:(ManagedEntity *)managedEntity;

- (NSArray *)find:(Class)entityClass withCondition:(NSString *)condition;

@end
