#import "ManagedObject.h"

@implementation ManagedObject

    @synthesize object;
    @synthesize action;

- (instancetype)initWithObject:(NSObject *)anObject andAction:(ActionType)anAction {
    self = [super init];

    if (self) {
        self.action = anAction;
        self.object = anObject;
    }

    return self;
}

+ (instancetype)objectWithObject:(NSObject *)anObject andAction:(ActionType)anAction {
    return [[self alloc] initWithObject:anObject andAction:anAction];
}

@end
