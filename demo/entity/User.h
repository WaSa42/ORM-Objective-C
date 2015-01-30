#import <Foundation/Foundation.h>

@interface User : NSObject {
    int id;
    NSString *username;
}

@property int id;
@property NSString *username;

- (instancetype)initWithId:(int)anId username:(NSString *)anUsername;
+ (instancetype)userWithId:(int)anId username:(NSString *)anUsername;

@end
