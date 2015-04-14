//
//  BranchReferralController.m
//  BranchInvite
//
//  Created by Graham Mueller on 4/13/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "BranchReferralController.h"
#import "BranchInviteBundleUtil.h"
#import "BranchInviteViewController.h"
#import "Branch.h"

@interface BranchReferralController () <BranchInviteControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *referralCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *referralScoreLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarHeightConstraint;

- (IBAction)inviteUsersPressed:(id)sender;
- (IBAction)donePressed:(id)sender;

@end

@implementation BranchReferralController

+ (BranchReferralController *)branchReferralControllerWithDelegate:(id <BranchReferralScoreDelegate, BranchInviteControllerDelegate>)delegate {
    NSBundle *branchInviteBundle = [BranchInviteBundleUtil branchInviteBundle];
    
    BranchReferralController *controller = [[BranchReferralController alloc] initWithNibName:@"BranchReferralController" bundle:branchInviteBundle];
    controller.delegate = delegate;
    controller.inviteDelegate = delegate;
    
    return controller;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
        self.navBarHeightConstraint.constant = 59;
    }
    
    [[Branch getInstance] getCreditHistoryWithCallback:^(NSArray *referrals, NSError *error) {
        [self showReferralScoreText:referrals];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController || self.tabBarController) {
        self.navBarHeightConstraint.constant = 0;
    }
}


#pragma mark - Interaction methods

- (void)inviteUsersPressed:(id)sender {
    UINavigationController *inviteController = [BranchInviteViewController branchInviteViewControllerWithDelegate:self];
    
    [self presentViewController:inviteController animated:YES completion:NULL];
}

- (void)donePressed:(id)sender {
    [self.delegate branchReferralScoreDelegateScreenCompleted];
}


#pragma mark - BranchInviteController methods

- (void)inviteControllerDidFinish {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    [self.inviteDelegate inviteControllerDidFinish];
}

- (void)inviteControllerDidCancel {
    [self dismissViewControllerAnimated:YES completion:NULL];

    [self.inviteDelegate inviteControllerDidCancel];
}

- (NSArray *)inviteContactProviders {
    return [self.inviteDelegate respondsToSelector:@selector(inviteContactProviders)] ? [self.inviteDelegate inviteContactProviders] : nil;
}

- (void)configureSegmentedControl:(HMSegmentedControl *)segmentedControl {
    if ([self.inviteDelegate respondsToSelector:@selector(configureSegmentedControl:)]) {
        [self.inviteDelegate configureSegmentedControl:segmentedControl];
    }
}

- (UINib *)nibForContactRows {
    return [self.inviteDelegate respondsToSelector:@selector(nibForContactRows)] ? [self.inviteDelegate nibForContactRows] : nil;
}

- (Class)classForContactRows {
    return [self.inviteDelegate respondsToSelector:@selector(classForContactRows)] ? [self.inviteDelegate classForContactRows] : nil;
}

- (CGFloat)heightForContactRows {
    return [self.inviteDelegate respondsToSelector:@selector(heightForContactRows)] ? [self.inviteDelegate heightForContactRows] : 0;
}

- (NSString *)invitingUserFullname {
    return [self.inviteDelegate invitingUserFullname];
}

- (NSString *)invitingUserId {
    return [self.inviteDelegate respondsToSelector:@selector(invitingUserId)] ? [self.inviteDelegate invitingUserId] : nil;
}

- (NSDictionary *)inviteUrlCustomData {
    return [self.inviteDelegate respondsToSelector:@selector(inviteUrlCustomData)] ? [self.inviteDelegate inviteUrlCustomData] : nil;
}

- (NSString *)invitingUserShortName {
    return [self.inviteDelegate respondsToSelector:@selector(invitingUserShortName)] ? [self.inviteDelegate invitingUserShortName] : nil;
}

- (NSString *)invitingUserImageUrl {
    return [self.inviteDelegate respondsToSelector:@selector(invitingUserImageUrl)] ? [self.inviteDelegate invitingUserImageUrl] : nil;
}


#pragma mark - Internals

- (void)showReferralScoreText:(NSArray *)referrals {
    self.referralCountLabel.hidden = NO;
    self.referralCountLabel.text = [NSString stringWithFormat:@"%lld referrals", (long long)[referrals count]];
    
    self.referralScoreLabel.hidden = NO;
    self.referralScoreLabel.text = [NSString stringWithFormat:@"%@ points", [referrals valueForKeyPath:@"@sum.transaction.amount"]];
}

@end
