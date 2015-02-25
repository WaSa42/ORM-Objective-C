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
        // Database filename
        self.name = @"database";
        self.extension = @"sqlite";

        NSString *file = [NSString stringWithFormat:@"%@.%@", self.name, self.extension];

        // Original database path
        self.originalPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:file];

        // Final database path
        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.finalPath = [directories[0] stringByAppendingPathComponent:file];

        // Copy the original database on the final path
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.finalPath]) {
            [[NSFileManager defaultManager] copyItemAtPath:self.originalPath toPath:self.finalPath error:nil];
        }

        // Open the database
        int result;

        if ((result = sqlite3_open([self.finalPath UTF8String], &database)) != SQLITE_OK) {
            [NSException raise:@"Invalid database filename" format:@"Error %d: %s", result, sqlite3_errmsg(database)];
        }

        // Log the final database path
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
    // Log the query
    NSLog(@"executing query : %@", query);
    int result;

    // Create the statement
    sqlite3_stmt *stmt;

    // Check the query
    if((result = sqlite3_prepare_v2(database, [query UTF8String], -1, &stmt, NULL)) != SQLITE_OK) {
        [NSException raise:@"Invalid query" format:@"Error %d: %s", result, sqlite3_errmsg(database)];
    }

    // Execute the query
    if((result = sqlite3_step(stmt)) != SQLITE_DONE) {
        [NSException raise:@"Invalid request" format:@"Error %d: %s", result, sqlite3_errmsg(database)];
    }

    // Remove the statement
    sqlite3_finalize(stmt);
    NSLog(@"query executed");
}

- (id)getLastInsertId {
    return [NSString stringWithFormat:@"%qi", sqlite3_last_insert_rowid(database)];
}

- (NSArray *)getResultForQuery:(NSMutableString *)query andClass:entityClass {
    // Log the query
    NSLog(@"executing query : %@", query);
    int result;

    // Create the results array and the statement
    NSMutableArray *results = [NSMutableArray array];
    sqlite3_stmt *stmt;

    // Check the query
    if((result = sqlite3_prepare_v2(database, [query UTF8String], -1, &stmt, NULL)) != SQLITE_OK) {
        [NSException raise:@"Invalid query" format:@"Error %d: %s", result, sqlite3_errmsg(database)];
    }

    // Fetch the results : for each results
    while(sqlite3_step(stmt) == SQLITE_ROW) {
        // Instantiate an object
        id object = [[entityClass alloc] init];

        // For each columns, set the value to the object
        int columns = sqlite3_column_count(stmt);

        for (int i = 0; i < columns; i++) {
            NSString *key = [NSString stringWithUTF8String:sqlite3_column_name(stmt, i)];
            NSString *value = [NSString stringWithUTF8String:(char const *) sqlite3_column_text(stmt, i)];

            [object setValue:value forKey:key];
        }

        // Add the result to the results array
        [results addObject:object];
    }

    // Remove the statement
    sqlite3_finalize(stmt);
    NSLog(@"query executed");

    // Return the results
    return results;
}

@end
