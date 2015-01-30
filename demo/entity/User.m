#import "User.h"

@implementation User

    @synthesize id;
    @synthesize username;

- (instancetype)initWithId:(int)anId username:(NSString *)anUsername {
    self = [super init];

    if (self) {
        self.id = anId;
        self.username = anUsername;
    }

    return self;
}

+ (instancetype)userWithId:(int)anId username:(NSString *)anUsername {
    return [[self alloc] initWithId:anId username:anUsername];
}

@end
