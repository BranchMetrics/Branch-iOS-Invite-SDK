//
//  ViewController.m
//  BranchInviteExample
//
//  Created by Graham Mueller on 1/23/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "ViewController.h"
#import "BranchInviteViewController.h"
#import "BranchInviteTextContactProvider.h"
#import "BranchInviteEmailContactProvider.h"
#import "MysteryIncContactProvider.h"

@interface ViewController () <BranchInviteControllerDelegate>

@end

@implementation ViewController

- (IBAction)inviteButtonPressed:(id)sender {
    id branchInviteViewController = [BranchInviteViewController branchInviteViewControllerWithDelegate:self];
    
    [self presentViewController:branchInviteViewController animated:YES completion:NULL];
}

#pragma mark - BranchInviteControllerDelegate methods
- (void)inviteControllerDidFinish {
    [self dismissViewControllerAnimated:YES completion:^{
        [[[UIAlertView alloc] initWithTitle:@"Hooray!" message:@"Your invites have been sent!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void)inviteControllerDidCancel {
    [self dismissViewControllerAnimated:YES completion:^{
        [[[UIAlertView alloc] initWithTitle:@"Awe :(" message:@"Your invites were canceled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

// Uncomment this method to see how segmented control customization works
//- (void)configureSegmentedControl:(HMSegmentedControl *)segmentedControl {
//    segmentedControl.backgroundColor = [UIColor redColor];
//    
//    [segmentedControl addTarget:self action:@selector(invitesSent) forControlEvents:UIControlEventValueChanged]; // NOTE this will be removed
//    segmentedControl.sectionTitles = @[ @"Foo", @"Bar" ]; // NOTE these will be removed
//}

// Uncomment these lines to see how invite tableview customizations work
//- (UINib *)nibForContactRows {
//    return [UINib nibWithNibName:@"ExampleContactCell" bundle:[NSBundle mainBundle]];
//}
//
//- (CGFloat)heightForContactRows {
//    return 72;
//}

- (NSString *)invitingUserId {
    return @"shortstuffsushi";
}

- (NSString *)invitingUserFullname {
    return @"Graham Mueller";
}

- (NSString *)invitingUserShortName {
    return @"Graham";
}

- (NSString *)invitingUserImageUrl {
    return @"https://www.gravatar.com/avatar/28ed70ee3c8275f1d307d1c5b6eddfa5";
}

- (NSArray *)inviteContactProviders {
    return @[
        [BranchInviteEmailContactProvider emailContactProviderWithSubject:@"Check out this demo app!" inviteMessageFormat:@"Check out my demo app with Branch:\n\n%@!"],
        [BranchInviteTextContactProvider textContactProviderWithInviteMessageFormat:@"Check out my demo app with Branch:\n\n%@!"],
        [[MysteryIncContactProvider alloc] init]
    ];
}

@end
