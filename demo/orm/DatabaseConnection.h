#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseConnection : NSObject {
    sqlite3 *database;
    NSString *name, *extension, *originalPath, *finalPath;
}

@property (nonatomic) sqlite3 *database;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *extension;
@property (nonatomic) NSString *originalPath;
@property (nonatomic) NSString *finalPath;

- (instancetype)init;
+ (instancetype)instantiate;

- (void)dealloc;

- (void)execute:(NSString *)query;
- (id)getLastInsertId;

@end
