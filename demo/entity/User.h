#import <Foundation/Foundation.h>

@interface User : NSObject {
    int id;
    NSString *username;
}

@property int id;
@property NSString *username;

- (instancetype)initWithId:(int)anId andUsername:(NSString *)anUsername;
+ (instancetype)instantiateWithId:(int)anId andUsername:(NSString *)anUsername;

@end
