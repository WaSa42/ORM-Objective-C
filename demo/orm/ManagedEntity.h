#import <Foundation/Foundation.h>

#import "Action.h"
#import "DataExtractor.h"

@interface ManagedEntity : NSObject {
    NSObject *object;
    ActionType action;
}

@property (nonatomic) NSObject *object;
@property (nonatomic) ActionType action;

- (instancetype)initWithObject:(NSObject *)anObject andAction:(ActionType)anAction;
+ (instancetype)instantiateWithObject:(NSObject *)anObject andAction:(ActionType)anAction;

- (NSString *)table;
- (id)primaryKey;
- (NSMutableArray *)keys;
- (NSMutableArray *)values;
- (NSMutableDictionary *)data;
- (NSArray *)dependenciesForAction:(enum ActionType)anAction;
- (NSMutableArray *)columnsDefinitions;
- (NSMutableArray *)columnsNames;

@end
