#import "Profile.h"

@implementation Profile

@synthesize id;
@synthesize biography;
@synthesize location;

- (instancetype)initWithBiography:(NSString *)aBiography andLocation:(NSString *)aLocation {
    self = [super init];

    if (self) {
        self.biography = aBiography;
        self.location = aLocation;
    }

    return self;
}

+ (instancetype)instantiateWithBiography:(NSString *)aBiography andLocation:(NSString *)aLocation {
    return [[self alloc] initWithBiography:aBiography andLocation:aLocation];
}

@end
