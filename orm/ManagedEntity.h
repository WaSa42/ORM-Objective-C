#import <Foundation/Foundation.h>

#import "Action.h"
#import "DataExtractor.h"
#import "DatabaseConnection.h"

@interface ManagedEntity : NSObject {
    NSObject *object;
    ActionType action;
    NSInteger priority;
}

@property (nonatomic) NSObject *object;
@property (nonatomic) ActionType action;
@property (nonatomic) NSInteger priority;

- (instancetype)initWithObject:(NSObject *)anObject andAction:(ActionType)anAction;
+ (instancetype)instantiateWithObject:(NSObject *)anObject andAction:(ActionType)anAction;

- (NSString *)table;
- (id)primaryKey;
- (NSMutableArray *)keys;
- (NSMutableArray *)values;
- (NSMutableDictionary *)data;
- (NSMutableArray *)valuesWithRelations;
- (NSArray *)dependenciesForAction:(enum ActionType)anAction;
- (NSMutableArray *)columnsDefinitionsWithConnector:(id<DatabaseConnection>)connector;
- (NSMutableArray *)columnsNames;

@end
