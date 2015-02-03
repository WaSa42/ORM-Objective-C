#import "main.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        demoQueryBuilder();
        demoEntityManager();
    };

    return 0;
}

void demoQueryBuilder() {
    NSLog(@"DEMO QUERY BUILDER :");

    QueryBuilder *qb = [QueryBuilder instantiate];

    [[[[[[[qb select] all] from:@"users"] where:@"username"] is:@"bob"] andWhere:@"password"] is:@"bob"];
    NSLog(@"query 1 : %@", [qb query]);

    [qb reset];

    [[[[[qb select] fields:@[@"id", @"email", @"password"]] from:@"users"] where:@"username"] isNot:@"bob"];
    NSLog(@"query 2 : %@", [qb query]);

    [qb reset];

    [[[[[qb select] field:@"id"] from:@"users"] where:@"username"] isNotIn:@[@"bob11", @"joe22", @"john33"]];
    NSLog(@"query 3 : %@", [qb query]);

    [qb reset];

    [[[[[[[qb select] all] from:@"users"] where:@"username"] is:@"bob"] orWhere:@"id"] isIn:@[@"1", @"2", @"3"]];
    NSLog(@"query 4 : %@", [qb query]);

    NSLog(@"---");
}

void demoEntityManager() {
    NSLog(@"DEMO ENTITY MANAGER :");

    User *user = [User instantiateWithUsername:@"bob" andPassword:@"bob"];
    EntityManager *em = [EntityManager instantiate];
    [em insert: user];
    [em flush];

    NSLog(@"---");
}
