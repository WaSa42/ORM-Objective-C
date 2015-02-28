#import "MySQLDatabaseConnection.h"

@implementation MySQLDatabaseConnection

@synthesize database;
@synthesize parameters;

+ (id)initWithParameters:(NSDictionary *)parameters {
    MySQLDatabaseConnection *instance = [[self alloc] init];
    instance.parameters = parameters;

    if (mysql_library_init(0, NULL, NULL)) {
        [NSException raise:@"Initialization error" format:@"An error occurred during initialization"];
    }

    return instance;
}

- (void)connect {
    // Open the database
    self.database = mysql_init(NULL);

    if (!mysql_real_connect(
        self.database,
        [[[self parameters] valueForKey:@"address"] UTF8String],
        [[[self parameters] valueForKey:@"username"] UTF8String],
        [[[self parameters] valueForKey:@"password"] UTF8String],
        [[[self parameters] valueForKey:@"database"] UTF8String],
        [[[self parameters] valueForKey:@"port"] unsignedIntValue],
        [[[self parameters] valueForKey:@"socket"] UTF8String],
        0
    )) {
        [NSException raise:@"Invalid parameters" format:@"Error %d : %@", mysql_errno(self.database), [NSString stringWithUTF8String:mysql_error(self.database)]];
    }

    if(mysql_set_character_set(self.database, "utf8")) {
        [NSException raise:@"Charset error" format:@"Error %d : %@", mysql_errno(self.database), [NSString stringWithUTF8String:mysql_error(self.database)]];
    }
}

- (NSString *)getAutoIncrementKeyword {
    return @"AUTO_INCREMENT";
}

- (void)dealloc {
    if (self.database){
        mysql_close(self.database);
        self.database = nil;
    }

    mysql_library_end();
}

- (void)execute:(NSString *)query {
    // Log the query
    NSLog(@"executing query : %@", query);

    // Create the statement
    MYSQL_STMT *stmt;

    if (!(stmt = mysql_stmt_init(self.database))) {
        [NSException raise:@"Invalid statement" format:@"Error %d : %@", mysql_errno(self.database), [NSString stringWithUTF8String:mysql_error(self.database)]];
    }

    // Check the query
    if (mysql_stmt_prepare(stmt, [query UTF8String], [query length])) {
        [NSException raise:@"Invalid query" format:@"Error %d : %@", mysql_errno(self.database), [NSString stringWithUTF8String:mysql_error(self.database)]];
    }

    // Execute the query
    if (mysql_stmt_execute(stmt)) {
        [NSException raise:@"Invalid request" format:@"Error %d : %@", mysql_errno(self.database), [NSString stringWithUTF8String:mysql_error(self.database)]];
    }

    // Remove the statement
    mysql_stmt_close(stmt);
    NSLog(@"query executed");
}

- (id)getLastInsertId {
    return [NSString stringWithFormat:@"%qi", mysql_insert_id(self.database)];
}

- (NSArray *)getResultForQuery:(NSMutableString *)query {
    // Log the query
    NSLog(@"executing query : %@", query);

    if (mysql_query(self.database, query.UTF8String)) {
        [NSException raise:@"Invalid query" format:@"Error %d : %@", mysql_errno(self.database), [NSString stringWithUTF8String:mysql_error(self.database)]];
    }

    NSMutableArray *results = [NSMutableArray array];
    MYSQL_RES *mysqlResult = mysql_use_result(self.database);

    if (mysqlResult) {
        unsigned int columns = mysql_num_fields(mysqlResult);
        MYSQL_ROW row;

        // Columns names
        MYSQL_FIELD *field;
        char *columnsNames[columns];

        for (unsigned int i = 0; (field = mysql_fetch_field(mysqlResult)); i++) {
            columnsNames[i] = field->name;
        }

        while ((row = mysql_fetch_row(mysqlResult))) {
            // Save the row inside a dictionary
            NSMutableDictionary *result = [NSMutableDictionary dictionary];

            // For each columns, set the value to the object
            for (unsigned int i = 0; i < columns; i++) {
                NSString *key = [NSString stringWithUTF8String:columnsNames[i]];
                NSString *value = (row[i]) ? [NSString stringWithUTF8String:row[i]] : @"";

                [result setValue:value forKey:key];
            }

            // Add the result to the results array
            [results addObject:result];
        }

        mysql_free_result(mysqlResult);
    }

    NSLog(@"query executed");

    // Return the results
    return results;
}

@end
