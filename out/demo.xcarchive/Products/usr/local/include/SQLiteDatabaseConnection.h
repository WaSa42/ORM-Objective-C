#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "DatabaseConnection.h"

@interface SQLiteDatabaseConnection : NSObject<DatabaseConnection> {
    sqlite3 *database;
    NSString *filePath;
}

@property (nonatomic) sqlite3 *database;
@property (nonatomic) NSString *filePath;

+ (id)initWithParameters:(NSDictionary *)parameters;
- (void)connect;
- (void)dealloc;

- (NSString *)getAutoIncrementKeyword;
- (void)execute:(NSString *)query;
- (id)getLastInsertId;
- (NSArray *)getResultForQuery:(NSMutableString *)query;

@end
