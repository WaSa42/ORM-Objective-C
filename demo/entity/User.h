#import <Foundation/Foundation.h>

@interface User : NSObject {
    int id;
    NSString *username;
}

@property int id;
@property NSString *username;
@property NSString *password;

- (instancetype)initWithUsername:(NSString *)aUsername andPassword:(NSString *)aPassword;
+ (instancetype)instantiateWithUsername:(NSString *)username andPassword:(NSString *)password;

@end
