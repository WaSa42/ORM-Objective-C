#import <Foundation/Foundation.h>

#import "Action.h"

@interface ManagedEntity : NSObject {
    NSObject *object;
    ActionType action;
}

@property NSObject *object;
@property ActionType action;

- (instancetype)initWithObject:(NSObject *)anObject andAction:(ActionType)anAction;
+ (instancetype)objectWithObject:(NSObject *)anObject andAction:(ActionType)anAction;

@end
