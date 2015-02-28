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

- (void)persist:(id)anObject;
- (void)remove:(id)anObject;
- (void)flush;

- (void)persistManagedEntity:(ManagedEntity *)managedEntity;
- (void)removeManagedEntity:(ManagedEntity *)managedEntity;

- (NSArray *)find:(Class)entityClass withCondition:(NSString *)condition;

@end
