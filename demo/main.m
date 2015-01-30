#import <Foundation/Foundation.h>

#import "ORM.h"
#import "User.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Create an user
        User *user = [User instantiateWithId:1 andUsername:@"bob"];
        NSLog(@"username : %@", [user username]);

        // Insert the user
        EntityManager *em = [EntityManager instantiate];
        [em insert: user];

        // Generate a query
        QueryBuilder *qb = [QueryBuilder instantiate];

        NSArray *fields = @[@"field1", @"field2", @"field3"];
        [qb select: fields];

        NSLog(@"query : %@", [qb query]);
    };

    return 0;
}
