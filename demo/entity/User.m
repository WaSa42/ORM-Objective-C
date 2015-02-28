#import "User.h"

@implementation User

@synthesize id;
@synthesize username;
@synthesize password;
@synthesize profile;
@synthesize articles;

- (instancetype)init {
    self = [super init];

    if (self) {
        self.profile = [Profile instantiateWithBiography:@"" andLocation:@""];
        self.articles = [NSMutableArray array];
    }

    return self;
}

- (instancetype)initWithUsername:(NSString *)aUsername andPassword:(NSString *)aPassword {
    self = [self init];

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
