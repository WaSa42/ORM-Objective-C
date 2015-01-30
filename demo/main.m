#import <Foundation/Foundation.h>

#import "ORM.h"
#import "User.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        id user = [User userWithId:1 username:@"bob"];
        NSLog(@"the username is : %@", [user username]);

        // TODO: persist the user
    }

    return 0;
}
