#import "EntityManager.h"

@implementation EntityManager

    @synthesize managedObjects;

- (instancetype)init {
    self = [super init];

    if (self) {
        self.managedObjects = [NSMutableArray array];
    }

    return self;
}

+ (instancetype)instantiate {
    return [[self alloc] init];
}

- (void)insert:(id)anObject {
    [managedObjects addObject:[ManagedObject objectWithObject:anObject andAction: INSERT]];
}

- (void)update:(id)anObject {
    [managedObjects addObject:[ManagedObject objectWithObject:anObject andAction: UPDATE]];
}

- (void)remove:(id)anObject {
    [managedObjects addObject:[ManagedObject objectWithObject:anObject andAction: REMOVE]];
}

- (void)flush {
    for(ManagedObject *managedObject in managedObjects) {
        switch (managedObject.action) {
            case INSERT:

                break;

            case UPDATE:

                break;

            case REMOVE:

                break;
        }
    }
}

@end
