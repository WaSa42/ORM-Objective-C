#import <Foundation/Foundation.h>

#import "User.h"

@interface Article : NSObject {
    NSInteger id;
    User *user;
    NSString *title;
}

@property (nonatomic) NSInteger id;
@property (nonatomic) User *user;
@property (nonatomic) NSString *title;

- (instancetype)initWithContent:(NSString *)aTitle;
+ (instancetype)instantiateWithTitle:(NSString *)aTitle;

@end
