#import <Foundation/Foundation.h>

#import "ORM.h"
#import "User.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Update a user
        User *user = [User instantiateWithId:1 andUsername:@"bob"];
        EntityManager *em = [EntityManager instantiate];
        [em insert: user];
        // TODO: flush

        // Generate queries
        QueryBuilder *qb = [QueryBuilder instantiate];

        [[[[[[qb selectAll] from:@"users"] where:@"username"] is:@"bob"] andWhere:@"password"] is:@"bob"];
        NSLog(@"query 1 : %@", [qb query]);

        [qb reset];

        [[[[qb selectFields:@[@"id", @"email", @"password"]] from:@"users"] where:@"username"] isNot:@"bob"];
        NSLog(@"query 2 : %@", [qb query]);

        [qb reset];

        [[[[qb selectField:@"id"] from:@"users"] where:@"username"] isNotIn:@[@"bob11", @"joe22", @"john33"]];
        NSLog(@"query 3 : %@", [qb query]);

        [qb reset];

        [[[[[[qb selectAll] from:@"users"] where:@"username"] is:@"bob"] orWhere:@"id"] isIn:@[@"1", @"2", @"3"]];
        NSLog(@"query 4 : %@", [qb query]);
    };

    return 0;
}
