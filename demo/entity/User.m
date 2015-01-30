#import "User.h"

@implementation User

    @synthesize id;
    @synthesize username;

- (instancetype)initWithId:(int)anId andUsername:(NSString *)anUsername {
    self = [super init];

    if (self) {
        self.id = anId;
        self.username = anUsername;
    }

    return self;
}

+ (instancetype)instantiateWithId:(int)anId andUsername:(NSString *)anUsername {
    return [[self alloc] initWithId:anId andUsername:anUsername];
}

@end
