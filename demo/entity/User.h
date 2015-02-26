#import <Foundation/Foundation.h>

#import "Profile.h"

@interface User : NSObject {
    NSInteger id;
    NSString *username;
    NSString *password;
    Profile *profile;
}

@property (nonatomic) NSInteger id;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;
@property (nonatomic) Profile *profile;

- (instancetype)initWithUsername:(NSString *)aUsername andPassword:(NSString *)aPassword;
+ (instancetype)instantiateWithUsername:(NSString *)username andPassword:(NSString *)password;

@end
