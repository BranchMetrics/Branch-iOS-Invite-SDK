//
//  BranchWelcomeViewController.m
//  BranchInvite
//
//  Created by Graham Mueller on 1/25/15.
//
//

#import "BranchWelcomeViewController.h"
#import <Branch/Branch.h>
#import "BranchInvite.h"
#import "BranchInviteBundleUtil.h"
#import "BranchWelcomeDefaultView.h"

NSInteger const DEFAULT_REFERRAL_LINK_RETRY_COUNT = 3;

@interface BranchWelcomeViewController ()

@property (strong, nonatomic) NSDictionary *branchOpts;
@property (assign, nonatomic) BOOL shouldShowReferredCredits;
@property (assign, nonatomic) NSInteger maxReferralLinkRetryCount;
@property (assign, nonatomic) NSInteger currentReferralLinkRetryNumber;
@property (weak, nonatomic) id <BranchWelcomeControllerDelegate> delegate;

@end

@implementation BranchWelcomeViewController

+ (BOOL)shouldShowWelcome:(NSDictionary *)branchOpts {
    return branchOpts[BRANCH_INVITE_USER_FULLNAME_KEY] != nil && ![[Branch getInstance] isUserIdentified];
}

+ (BranchWelcomeViewController *)branchWelcomeViewControllerWithDelegate:(id <BranchWelcomeControllerDelegate>)delegate branchOpts:(NSDictionary *)branchOpts {
    NSBundle *branchInviteBundle = [BranchInviteBundleUtil branchInviteBundle];

    BranchWelcomeDefaultView *defaultView = [[branchInviteBundle loadNibNamed:@"BranchWelcomeDefaultView" owner:self options:kNilOptions] objectAtIndex:0];
    defaultView.delegate = delegate;
    
    return [BranchWelcomeViewController branchWelcomeViewControllerWithCustomView:defaultView delegate:delegate branchOpts:branchOpts];
}

+ (BranchWelcomeViewController *)branchWelcomeViewControllerWithCustomView:(UIView <BranchWelcomeView>*)customView delegate:(id <BranchWelcomeControllerDelegate>)delegate branchOpts:(NSDictionary *)branchOpts {
    BranchWelcomeViewController *branchWelcomeController = [[BranchWelcomeViewController alloc] init];

    branchWelcomeController.view = customView;
    branchWelcomeController.delegate = delegate;
    branchWelcomeController.branchOpts = branchOpts;
    
    [customView configureWithInviteUserInfo:branchOpts];
    [[customView continueButton] addTarget:branchWelcomeController action:@selector(continuePressed) forControlEvents:UIControlEventTouchUpInside];
    [[customView cancelButton] addTarget:branchWelcomeController action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];

    // We don't own the view lifecycle, so just get this out of the way
    [[Branch getInstance] userCompletedAction:@"viewed_personal_welcome"];
    
    return branchWelcomeController;
}


#pragma mark - Interaction methods

- (void)cancelPressed {
    [self.delegate welcomeControllerWasCanceled];
}

- (void)continuePressed {
    [self.delegate welcomeControllerConfirmedInvite];
}

@end
