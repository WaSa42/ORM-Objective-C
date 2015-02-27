#import <Foundation/Foundation.h>

#import "Action.h"
#import "DataExtractor.h"
#import "ManagedEntity.h"
#import "QueryBuilder.h"
#import "DatabaseConnection.h"

@interface EntityManager : NSObject {
    NSMutableArray *managedEntities;
    DatabaseConnection *databaseConnection;
}

@property (nonatomic) NSMutableArray *managedEntities;
@property (nonatomic) DatabaseConnection *databaseConnection;

- (instancetype)init;
+ (instancetype)instantiate;

- (void)insert:(id)anObject;
- (void)update:(id)anObject;
- (void)remove:(id)anObject;
- (void)flush;

- (NSArray *)find:(Class)entityClass withCondition:(NSString *)condition;

- (void)insertManagedEntity:(ManagedEntity *)managedEntity;
- (void)updateManagedEntity:(ManagedEntity *)managedEntity;
- (void)removeManagedEntity:(ManagedEntity *)managedEntity;

@end
