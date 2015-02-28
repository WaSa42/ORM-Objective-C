#import "main.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"DEMO QUERY BUILDER :");
        demoQueryBuilder();

        NSLog(@"---");

        NSLog(@"DEMO ENTITY MANAGER :");
        demoEntityManager();
    };

    return 0;
}

void demoQueryBuilder() {
    QueryBuilder *qb = [QueryBuilder instantiate];

    [[[[[[[qb select] all] from:@"user"] where:@"username"] is:@"bob"] andWhere:@"password"] is:@"bob"];
    NSLog(@"query 1 : %@", [qb query]);

    [qb reset];

    [[[[[qb select] fields:@[@"id", @"email", @"password"]] from:@"user"] where:@"username"] isNot:@"bob"];
    NSLog(@"query 2 : %@", [qb query]);

    [qb reset];

    [[[[[qb select] field:@"id"] from:@"user"] where:@"username"] isNotIn:@[@"bob11", @"joe22", @"john33"]];
    NSLog(@"query 3 : %@", [qb query]);

    [qb reset];

    [[[[[[[qb select] all] from:@"user"] where:@"username"] is:@"bob"] orWhere:@"id"] isIn:@[@"1", @"2", @"3"]];
    NSLog(@"query 4 : %@", [qb query]);
}

void demoEntityManager() {
    @try {
        // SQLite :
//        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//        [parameters setValue:@"orm.sqlite" forKey:@"fileName"];
//
//        EntityManager *em = [EntityManager instantiateWithConnector:[SQLiteDatabaseConnection class] andParameters:parameters];

        // MySQL :
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"/Applications/MAMP/tmp/mysql/mysql.sock" forKey:@"socket"];
        [parameters setValue:@"localhost" forKey:@"address"];
        [parameters setValue:@"root" forKey:@"username"];
        [parameters setValue:@"root" forKey:@"password"];
        [parameters setValue:@"orm" forKey:@"database"];
        [parameters setValue:@8889 forKey:@"port"];

        EntityManager *em = [EntityManager instantiateWithConnector:[MySQLDatabaseConnection class] andParameters:parameters];

        // Insert :
        NSLog(@"insert a user :");
        User *user = [User instantiateWithUsername:@"bob" andPassword:@"bob"];
        user.profile = [Profile instantiateWithBiography:@"#teamObjectiveC" andLocation:@"Lyon"];

        [em insert:user];
        [em flush];
        NSLog(@"user inserted : id = %li, profile id = %li", [user id], [[user profile] id]);
        waitForEnter();

        // Update :
        user.username = @"new_username";

        [em update:user];
        [em flush];
        NSLog(@"user updated");
        waitForEnter();

        // Remove :
        [em remove:user];
        [em flush];
        NSLog(@"user removed");
        waitForEnter();

        // Find :
        QueryBuilder *qb = [QueryBuilder instantiate];
        [[[[qb where:@"username"] is:@"bob"] orWhere:@"id"] isIn:@[@"1", @"2", @"3", @"4", @"5"]];

        NSLog(@"find users :");
        NSArray *results = [em find:[User class] withCondition:[qb query]];
        NSLog(@"%lu results", [results count]);

        for (User *result in results) {
            NSLog(@"User id = %li, username = %@, profile id = %li", [result id], [result username], [[result profile] id]);
        }
    }

    @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
    }
}

void waitForEnter() {
    NSLog(@"Press enter to continue... ");
    while(getchar() != '\n');
}
