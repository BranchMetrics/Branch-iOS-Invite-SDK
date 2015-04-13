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

@property (weak, nonatomic) IBOutlet UILabel *referralScoreLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarHeightConstraint;

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
    
    [[Branch getInstance] getCreditHistoryWithCallback:^(NSArray *referrals, NSError *error) {
        self.referralScoreLabel.hidden = NO;

        if (error) {
            [self showErrorMessage];
        }
        else if (![referrals count]) {
            [self showNoReferralsMesasge];
        }
        else {
            [self showReferralScoreText:referrals];
        }

        if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
            [self updateScoreLabelSize];
        }
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

- (void)showErrorMessage {
    self.referralScoreLabel.text = @"Unable to load referral information at this time";
}

- (void)showNoReferralsMesasge {
    self.referralScoreLabel.text = @"You haven't referred any users yet! Press the button below to invite friends.";
}

- (void)showReferralScoreText:(NSArray *)referrals {
    NSNumber *numReferrals = @([referrals count]);
    NSNumber *referralsValue = [referrals valueForKeyPath:@"@sum.transaction.amount"];
    
    UIColor *accentColor = [UIColor colorWithRed:45/255.0 green:157/255.0 blue:157/255.0 alpha:1];
    NSDictionary *valueAttributes = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:48], NSForegroundColorAttributeName: accentColor };
    NSDictionary *labelAttributes = @{ NSForegroundColorAttributeName: accentColor };

    NSString *referralString = [NSString stringWithFormat:@"You've referred\n%@ users\nfor a total of\n%@ points!", numReferrals, referralsValue];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:referralString];
    [attributedString setAttributes:valueAttributes range:[referralString rangeOfString:[numReferrals stringValue]]];
    [attributedString setAttributes:labelAttributes range:[referralString rangeOfString:@"users"]];
    [attributedString setAttributes:valueAttributes range:[referralString rangeOfString:[referralsValue stringValue]]];
    [attributedString setAttributes:labelAttributes range:[referralString rangeOfString:@"points"]];
    
    self.referralScoreLabel.attributedText = attributedString;
}

- (void)updateScoreLabelSize {
    CGFloat height;
    if (self.referralScoreLabel.attributedText) {
        height = [self.referralScoreLabel.attributedText size].height + 20; // pad
    }
    else {
        height = [self.referralScoreLabel.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(self.referralScoreLabel.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
    }
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.referralScoreLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    
    [self.view addConstraint:heightConstraint];
}

@end
