#import "Article.h"

@implementation Article

@synthesize id;
@synthesize user;
@synthesize title;

- (instancetype)init {
    self = [super init];

    if (self) {
        self.user = [User instantiateWithUsername:@"" andPassword:@""];
    }

    return self;
}

- (instancetype)initWithContent:(NSString *)aTitle {
    self = [self init];

    if (self) {
        self.title = aTitle;
    }

    return self;
}

+ (instancetype)instantiateWithTitle:(NSString *)aTitle {
    return [[self alloc] initWithContent:aTitle];
}

@end
