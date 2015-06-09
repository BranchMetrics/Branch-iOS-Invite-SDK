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
#import "BranchSharing.h"
#import "ExampleWelcomeScreen.h"
#import "ExampleSharingScreen.h"
#import "ExampleSharingScreenController.h"
#import "BranchReferralController.h"
#import "ExampleWelcomeScreen.h"
#import "ExampleReferralScreen.h"
#import "CurrentUserModel.h"

@interface AppDelegate () <BranchWelcomeControllerDelegate, BranchReferralControllerDelegate, BranchSharingViewStyleDelegate, BranchSharingControllerDelegate>

@property (weak, nonatomic) UIViewController *presentingController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Register for sharing any time the branch options contain the sharing text key
    [BranchSharing registerForSharingEventsWithKey:BRANCH_SHARING_SHARE_TEXT];
    
    // Customize sharing view appearance
//    [BranchSharing registerForSharingEventsWithKey:BRANCH_SHARING_SHARE_TEXT styleDelegate:self];
    
    // Use a complete custom sharing view
//    ExampleSharingScreen *sharingScreen = [[[NSBundle mainBundle] loadNibNamed:@"ExampleSharingScreen" owner:nil options:nil] firstObject];
//    [BranchSharing registerForSharingEventsWithKey:BRANCH_SHARING_SHARE_TEXT view:sharingScreen];

    // Use a custom sharing controller
//    ExampleSharingScreenController *controller = [[ExampleSharingScreenController alloc] initWithNibName:@"ExampleSharingScreen" bundle:[NSBundle mainBundle]];
//    [BranchSharing registerForSharingEventsWithKey:BRANCH_SHARING_SHARE_TEXT controller:controller];
    
    Branch *branch = [Branch getInstance];
    [branch setDebug];
    [branch initSessionWithLaunchOptions:launchOptions isReferrable:YES andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        NSLog(@"Deep Link Data: %@", params);

        if ([BranchWelcomeViewController shouldShowWelcome:params]) {
            //Comment these two lines in and the comment active controller line out to see example usage of custom view for welcome
//            ExampleWelcomeScreen *customView = [[[NSBundle mainBundle] loadNibNamed:@"ExampleWelcomeScreen" owner:nil options:nil] firstObject];
//            BranchWelcomeViewController *welcomeController = [BranchWelcomeViewController branchWelcomeViewControllerWithCustomView:customView delegate:self branchOpts:params];
            BranchWelcomeViewController *welcomeController = [BranchWelcomeViewController branchWelcomeViewControllerWithDelegate:self branchOpts:params];

            self.presentingController = self.window.rootViewController;
            
            [self.presentingController presentViewController:welcomeController animated:YES completion:NULL];
        }
        
        UIViewController *sharingController = [BranchSharing sharingControllerForBranchOpts:params delegate:self];
        if (sharingController) {
            self.presentingController = self.window.rootViewController;

            [self.presentingController presentViewController:sharingController animated:YES completion:NULL];
        }
    }];
    
    //Comment these two lines in and the comment active controller line out to see example usage of custom view for referrals
//    ExampleReferralScreen *customView = [[[NSBundle mainBundle] loadNibNamed:@"ExampleReferralScreen" owner:nil options:nil] firstObject];
//    BranchReferralController *referralController = [BranchReferralController branchReferralControllerWithView:customView delegate:self];
    BranchReferralController *referralController = [BranchReferralController branchReferralControllerWithDelegate:self];
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    [tabBarController addChildViewController:referralController];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[Branch getInstance] handleDeepLink:url];
}


#pragma mark - BranchReferralControllerDelegate methods

- (NSString *)referringUserId {
    return [CurrentUserModel sharedModel].userId;
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

- (BOOL)welcomeControllerShouldShowReferredCredits {
    return YES;
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
//- (NSString *)welcomeEarnedCreditsTextForAmount:(NSInteger)creditAmount {
//    return [NSString stringWithFormat:@"Sweet! You got %lld credits for being referred.", (long long)creditAmount];
//}
//
//- (NSString *)welcomeContinueButtonTextForFullname:(NSString *)invitingUserFullname shortName:(NSString *)invitingUserShortName {
//    return @"Continue";
//}
//
//- (UIColor *)welcomeSchemeColor {
//    return [UIColor redColor];
//}
//
//- (UIColor *)welcomeBodyTextColor {
//    return [UIColor blackColor]; // Yeah, this looks bad on red, but it gets the idea across
//}


#pragma mark - BranchSharingViewStyleDelegate methods

- (UIColor *)branchSharingViewBackgroundColor {
    return [UIColor blackColor];
}

- (UIColor *)branchSharingViewForegroundColor {
    return [UIColor greenColor];
}

#pragma mark - BranchSharingControllerDelegate methods

- (void)branchSharingControllerCompleted {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
