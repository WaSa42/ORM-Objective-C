#import <Foundation/Foundation.h>

#import "DataExtractor.h"
#import "ManagedObject.h"
#import "QueryBuilder.h"

@interface EntityManager : NSObject {
    NSMutableArray *managedObjects;
}

@property NSMutableArray *managedObjects;

- (instancetype)init;
+ (instancetype)instantiate;

- (void)insert:(id)anObject;
- (void)update:(id)anObject;
- (void)remove:(id)anObject;
- (void)flush;

@end
