#import "User.h"

@implementation User

    @synthesize id;
    @synthesize username;

- (instancetype)initWithUsername:(NSString *)aUsername andPassword:(NSString *)aPassword {
    self = [super init];

    if (self) {
        self.username = aUsername;
        self.password = aPassword;
    }

    return self;
}

+ (instancetype)instantiateWithUsername:(NSString *)username andPassword:(NSString *)password {
    return [[self alloc] initWithUsername:username andPassword:password];
}

@end
