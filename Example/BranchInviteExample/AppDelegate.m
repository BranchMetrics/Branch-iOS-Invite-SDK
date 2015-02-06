//
//  AppDelegate.m
//  BranchInviteExample
//
//  Created by Graham Mueller on 1/23/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "AppDelegate.h"
#import "Branch.h"
#import "BranchWelcomeViewController.h"
#import "ExampleWelcomeScreen.h"

@interface AppDelegate () <BranchWelcomeControllerDelegate>

@property (weak, nonatomic) UIViewController *presentingController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[Branch getInstance] initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        NSLog(@"Deep Link Data: %@", params);

        if ([BranchWelcomeViewController shouldShowWelcome:params]) {
            //Comment these two lines in and the comment active controller line out to see example usage of custom view for welcome
//            ExampleWelcomeScreen *customView = [[[NSBundle mainBundle] loadNibNamed:@"ExampleWelcomeScreen" owner:nil options:nil] firstObject];
//            BranchWelcomeViewController *welcomeController = [BranchWelcomeViewController branchWelcomeViewControllerWithCustomView:customView delegate:self branchOpts:params];
            BranchWelcomeViewController *welcomeController = [BranchWelcomeViewController branchWelcomeViewControllerWithDelegate:self branchOpts:params];

            self.presentingController = self.window.rootViewController;
            
            [self.presentingController presentViewController:welcomeController animated:YES completion:NULL];
        }
    }];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[Branch getInstance] handleDeepLink:url];
}

#pragma mark - BranchWelcomeControllerDelegate methods
- (void)welcomeControllerConfirmedInvite {
    [self.presentingController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Great -- glad you get to join your friend");
    }];
}

- (void)welcomeControllerWasCanceled {
    [self.presentingController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Sorry about that, guess we had the wrong person");
    }];
}

// Comment these lines in to see customization of the Welcome screen
//- (NSString *)welcomeTitleTextForFullname:(NSString *)invitingUserFullname shortName:(NSString *)invitingUserShortName {
//    return [NSString stringWithFormat:@"Hey there, you were invited by %@", invitingUserFullname];
//}
//
//- (NSString *)welcomeBodyTextForFullname:(NSString *)invitingUserFullname shortName:(NSString *)invitingUserShortName {
//    return [NSString stringWithFormat:@"Come join %@ in our demo app", invitingUserShortName];
//}
//
//- (NSString *)welcomeContinueButtonTextForFullname:(NSString *)invitingUserFullname shortName:(NSString *)invitingUserShortName {
//    return @"Continue";
//}
//- (UIColor *)welcomeSchemeColor {
//    return [UIColor redColor];
//}
//
//- (UIColor *)welcomeBodyTextColor {
//    return [UIColor blackColor]; // Yeah, this looks bad on red, but it gets the idea across
//}

@end
