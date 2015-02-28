#import "SQLiteDatabaseConnection.h"

@implementation SQLiteDatabaseConnection

@synthesize database;
@synthesize filePath;

+ (id)initWithParameters:(NSDictionary *)parameters {
    SQLiteDatabaseConnection *instance = [[self alloc] init];

    // Original database path
    NSString *originalPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"database.sqlite"];

    // Final database path
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    instance.filePath = [directories[0] stringByAppendingPathComponent:[parameters valueForKey:@"fileName"]];

    // Copy the original database on the final path
    if (![[NSFileManager defaultManager] fileExistsAtPath:instance.filePath]) {
        [[NSFileManager defaultManager] copyItemAtPath:originalPath toPath:instance.filePath error:nil];
    }

    return instance;
}

- (void)connect {
    // Open the database
    int code;

    if ((code = sqlite3_open([self.filePath UTF8String], &database)) != SQLITE_OK) {
        [NSException raise:@"Invalid database filename" format:@"Error %d: %s", code, sqlite3_errmsg(self.database)];
    }

    // Log the database path
    NSLog(@"database path : %@", self.filePath);
}

- (NSString *)getAutoIncrementKeyword {
    return @"AUTOINCREMENT";
}

- (void)dealloc {
    sqlite3_close(self.database);
}

- (void)execute:(NSString *)query {
    // Log the query
    NSLog(@"%@", query);
    int code;

    // Create the statement
    sqlite3_stmt *stmt;

    // Check the query
    if ((code = sqlite3_prepare_v2(self.database, [query UTF8String], -1, &stmt, NULL)) != SQLITE_OK) {
        [NSException raise:@"Invalid query" format:@"Error %d: %s", code, sqlite3_errmsg(self.database)];
    }

    // Execute the query
    if ((code = sqlite3_step(stmt)) != SQLITE_DONE) {
        [NSException raise:@"Invalid request" format:@"Error %d: %s", code, sqlite3_errmsg(self.database)];
    }

    // Remove the statement
    sqlite3_finalize(stmt);
}

- (id)getLastInsertId {
    return [NSString stringWithFormat:@"%qi", sqlite3_last_insert_rowid(self.database)];
}

- (NSArray *)getResultForQuery:(NSMutableString *)query {
    // Log the query
    NSLog(@"%@", query);
    int code;

    // Create the results array and the statement
    NSMutableArray *results = [NSMutableArray array];
    sqlite3_stmt *stmt;

    // Check the query
    if ((code = sqlite3_prepare_v2(self.database, [query UTF8String], -1, &stmt, NULL)) != SQLITE_OK) {
        [NSException raise:@"Invalid query" format:@"Error %d: %s", code, sqlite3_errmsg(self.database)];
    }

    // Fetch the results : for each results
    int columns = sqlite3_column_count(stmt);

    while (sqlite3_step(stmt) == SQLITE_ROW) {
        // Save the row inside a dictionary
        NSMutableDictionary *result = [NSMutableDictionary dictionary];

        // For each columns, set the value to the object
        for (int i = 0; i < columns; i++) {
            NSString *key = [NSString stringWithUTF8String:sqlite3_column_name(stmt, i)];
            NSString *value = [NSString stringWithUTF8String:(char const *) sqlite3_column_text(stmt, i)];

            [result setValue:value forKey:key];
        }

        // Add the result to the results array
        [results addObject:result];
    }

    // Remove the statement
    sqlite3_finalize(stmt);

    // Return the results
    return results;
}

@end
