#import "ManagedEntity.h"

@implementation ManagedEntity

@synthesize object;
@synthesize action;
@synthesize table;
@synthesize data;
@synthesize keys;
@synthesize values;
@synthesize primaryKey;

- (instancetype)initWithObject:(NSObject *)anObject andAction:(ActionType)anAction {
    self = [super init];

    if (self) {
        self.action = anAction;
        self.object = anObject;
        self.table = [DataExtractor getObjectName:[self object]];
        self.data = [NSMutableDictionary dictionary];

        if (self.action != ACTION_INSERT) {
            self.primaryKey = [DataExtractor getIdFromObject:[self object]];
        }

        if (self.action != ACTION_REMOVE) {
            self.keys = [DataExtractor getKeysFromObject:[self object]];
            self.values = [DataExtractor getValuesFromObject:[self object] andKeys:[self keys]];
        }

        if (self.action == ACTION_UPDATE) {
            for (unsigned int i = 0; i < [self.keys count]; i++) {
                [self.data setValue:self.values[i] forKey:self.keys[i]];
            }
        }
    }

    return self;
}

+ (instancetype)objectWithObject:(NSObject *)anObject andAction:(ActionType)anAction {
    return [[self alloc] initWithObject:anObject andAction:anAction];
}

@end
