#import <Foundation/Foundation.h>

@interface User : NSObject {
    NSInteger id;
    NSString *username;
    NSString *password;
}

@property (nonatomic) NSInteger id;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;

- (instancetype)initWithUsername:(NSString *)aUsername andPassword:(NSString *)aPassword;
+ (instancetype)instantiateWithUsername:(NSString *)username andPassword:(NSString *)password;

@end
