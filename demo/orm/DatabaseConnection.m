#import "DatabaseConnection.h"

@implementation DatabaseConnection

@synthesize database;
@synthesize name;
@synthesize extension;
@synthesize originalPath;
@synthesize finalPath;

- (instancetype)init {
    self = [super init];

    if (self) {
        self.name = @"database";
        self.extension = @"sqlite";

        NSString *file = [NSString stringWithFormat:@"%@.%@", self.name, self.extension];
        self.originalPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:file];

        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.finalPath = [directories[0] stringByAppendingPathComponent:file];

        if (![[NSFileManager defaultManager] fileExistsAtPath:self.finalPath]) {
            [[NSFileManager defaultManager] copyItemAtPath:self.originalPath toPath:self.finalPath error:nil];
        }

        int result;

        if ((result = sqlite3_open([self.finalPath UTF8String], &database)) != SQLITE_OK) {
            [NSException raise:@"Invalid database filename" format:@"Error %d: %s", result, sqlite3_errmsg(database)];
        }

        NSLog(@"database path : %@", self.finalPath);
    }

    return self;
}

+ (instancetype)instantiate {
    return [[self alloc] init];
}

- (void)dealloc {
    sqlite3_close(self.database);
}

- (void)execute:(NSString *)query {
    NSLog(@"executing query : %@", query);

    sqlite3_stmt *stmt;
    int result;

    if((result = sqlite3_prepare_v2(database, [query UTF8String], -1, &stmt, NULL)) != SQLITE_OK) {
        [NSException raise:@"Invalid query" format:@"Error %d: %s", result, sqlite3_errmsg(database)];
    }

    if((result = sqlite3_step(stmt)) != SQLITE_DONE) {
        [NSException raise:@"Invalid request" format:@"Error %d: %s", result, sqlite3_errmsg(database)];
    }

    sqlite3_finalize(stmt);
    NSLog(@"query executed");
}

- (id)getLastInsertId {
    return [NSString stringWithFormat:@"%qi", sqlite3_last_insert_rowid(database)];
}

@end
