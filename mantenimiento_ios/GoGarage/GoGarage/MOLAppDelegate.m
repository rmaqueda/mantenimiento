    //
//  MOLAppDelegate.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 30/12/15.
//  Copyright © 2015 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLAppDelegate.h"
#import "MOLNetworkManager.h"
#import "MOLCoreDataStack.h"

@implementation MOLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [[MOLCoreDataStack sharedInstance] zapAllData];
    
    [[MOLNetworkManager sharedInstance] loginWithLastUserNameWithCompletionBlock:^(NSError *error) {
        if (error) {
            NSLog(@"Login error: %@", error.localizedDescription);
            UIViewController *rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
            self.window.rootViewController = rootController;
        }
    }];
    
    return YES;
}

@end
