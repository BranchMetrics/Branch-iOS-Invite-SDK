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

@property (weak, nonatomic) id <BranchReferralControllerDelegate> delegate;
@property (weak, nonatomic) id <BranchInviteControllerDelegate> inviteDelegate;
@property (weak, nonatomic) IBOutlet UIView <BranchReferralView> *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarHeightConstraint;

- (IBAction)donePressed:(id)sender;

@end

@implementation BranchReferralController

+ (BranchReferralController *)branchReferralControllerWithView:(UIView <BranchReferralView> *)view delegate:(id<BranchReferralControllerDelegate>)delegate {
    BranchReferralController *controller = [[BranchReferralController alloc] init];
    controller.contentView = view;
    
    [view willMoveToSuperview:controller.view];
    [controller.view addSubview:view]; // TODO figure this out
    [view didMoveToSuperview];
    
    return controller;
}

+ (BranchReferralController *)branchReferralControllerWithDelegate:(id<BranchReferralControllerDelegate>)delegate {
    return [BranchReferralController branchReferralControllerWithDelegate:delegate inviteDelegate:nil];
}

+ (BranchReferralController *)branchReferralControllerWithDelegate:(id <BranchReferralControllerDelegate>)delegate inviteDelegate:(id<BranchInviteControllerDelegate>)inviteDelegate {
    NSBundle *branchInviteBundle = [BranchInviteBundleUtil branchInviteBundle];
    
    BranchReferralController *controller = [[BranchReferralController alloc] initWithNibName:@"BranchReferralController" bundle:branchInviteBundle];
    controller.delegate = delegate;
    controller.inviteDelegate = inviteDelegate;
    
    return controller;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Don't layout under things
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Taller nav bar for iOS 7.0 and beyond since they layout under the status bar
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
        self.navBarHeightConstraint.constant = 59;
    }
    
    [[Branch getInstance] getCreditHistoryWithCallback:^(NSArray *transactions, NSError *error) {
        NSArray *referrals = [transactions filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSDictionary *transaction, NSDictionary *bindings) {
            return [self isReferral:transaction];
        }]];

        [self.contentView setCreditHistoryItems:transactions];
        [self.contentView setReferrals:referrals];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController || self.tabBarController) {
        self.navBarHeightConstraint.constant = 0;
    }
}


#pragma mark - Interaction methods

- (void)donePressed:(id)sender {
    [self.delegate branchReferralControllerCompleted];
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

- (BOOL)isReferral:(NSDictionary *)transaction {
    NSString *currentSessionId = [self.delegate referringUserId];
    NSString *referrer = transaction[@"referrer"];
    NSString *referree = transaction[@"referree"];
    
    BOOL referreeIsSetAndIsNotMe = referree && ![referree isEqualToString:currentSessionId];
    BOOL referrerIsSetAndIsMe = referrer && [referrer isEqualToString:currentSessionId];
    
    // This transaction is a referral made by me if one of the two are true:
    // * The referree is set (BranchReferringUser type referrals), and  it is not me. If it is me, that means I was referred.
    // * The referrer is set (BranchReferreeUser, BranchBothUsers), and is me. If it is not me, that means I wasn't the referrer.
    return referreeIsSetAndIsNotMe || referrerIsSetAndIsMe;
}

@end
