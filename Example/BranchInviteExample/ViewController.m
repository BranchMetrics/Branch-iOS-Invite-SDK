//
//  ViewController.m
//  BranchInviteExample
//
//  Created by Graham Mueller on 1/23/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "ViewController.h"
#import "BranchInviteViewController.h"

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

- (NSString *)invitingUserId {
    return @"fooby-dooby-doo";
}

- (NSString *)invitingUserFullname {
    return @"Fooby Doo";
}

- (NSString *)invitingUserImageUrl {
    return @"https://www.gravatar.com/avatar/28ed70ee3c8275f1d307d1c5b6eddfa5";
}

// TODO implement this w/ a custom provider
//- (NSArray *)inviteContactProviders {
//    return @[ [[BranchInviteEmailContactProvider alloc] init], [[BranchInviteTextContactProvider alloc] init] ];
//}

@end
