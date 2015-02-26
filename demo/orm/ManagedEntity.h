#import <Foundation/Foundation.h>

#import "Action.h"
#import "DataExtractor.h"

@interface ManagedEntity : NSObject {
    NSObject *object;
    ActionType action;
    NSString *table;
    NSMutableDictionary *data;
    NSMutableArray *keys, *values;
    id primaryKey;
}

@property (nonatomic) NSObject *object;
@property (nonatomic) ActionType action;
@property (nonatomic) NSString *table;
@property (nonatomic) NSMutableDictionary *data;
@property (nonatomic) NSMutableArray *keys, *values;
@property (nonatomic) id primaryKey;

- (instancetype)initWithObject:(NSObject *)anObject andAction:(ActionType)anAction;
+ (instancetype)instantiateWithObject:(NSObject *)anObject andAction:(ActionType)anAction;

- (NSArray *)getColumnsDefinitions;
- (NSArray *)getDependencies;

@end
