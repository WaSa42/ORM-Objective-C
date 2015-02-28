#import <Foundation/Foundation.h>
#import "mysql/mysql.h"

#import "DatabaseConnection.h"

@interface MySQLDatabaseConnection : NSObject<DatabaseConnection> {
    MYSQL *database;
    NSDictionary *parameters;
}

@property (nonatomic) MYSQL *database;
@property (nonatomic) NSDictionary *parameters;

+ (id)initWithParameters:(NSDictionary *)parameters;
- (void)connect;
- (void)dealloc;

- (NSString *)getAutoIncrementKeyword;
- (void)execute:(NSString *)query;
- (id)getLastInsertId;
- (NSArray *)getResultForQuery:(NSMutableString *)query;

@end
