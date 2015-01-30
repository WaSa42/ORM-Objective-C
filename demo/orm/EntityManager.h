#import <Foundation/Foundation.h>

#import "ManagedObject.h"

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
