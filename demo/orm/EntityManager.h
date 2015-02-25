#import <Foundation/Foundation.h>

#import "DataExtractor.h"
#import "ManagedEntity.h"
#import "QueryBuilder.h"
#import "DatabaseConnection.h"

#define SEPARATOR @";"

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

@end
