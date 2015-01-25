//
//  AppDelegate.m
//  BranchInviteExample
//
//  Created by Graham Mueller on 1/23/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "AppDelegate.h"
#import "Branch.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[Branch getInstance] initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        NSLog(@"Deep Link Data: %@", params);
    }];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[Branch getInstance] handleDeepLink:url];
}

@end
