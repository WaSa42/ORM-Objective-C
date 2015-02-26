#import <Foundation/Foundation.h>

@interface Profile : NSObject {
    NSInteger id;
    NSString *biography;
    NSString *location;
}

@property (nonatomic) NSInteger id;
@property (nonatomic) NSString *biography;
@property (nonatomic) NSString *location;

- (instancetype)initWithBiography:(NSString *)aBiography andLocation:(NSString *)aLocation;
+ (instancetype)instantiateWithBiography:(NSString *)aBiography andLocation:(NSString *)aLocation;

@end
