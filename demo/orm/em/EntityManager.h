#import <Foundation/Foundation.h>

#import "DataExtractor.h"
#import "ManagedEntity.h"
#import "QueryBuilder.h"

@interface EntityManager : NSObject {
    NSMutableArray *managedEntities;
}

@property NSMutableArray *managedEntities;

- (instancetype)init;
+ (instancetype)instantiate;

- (void)insert:(id)anObject;
- (void)update:(id)anObject;
- (void)remove:(id)anObject;
- (void)flush;

@end
