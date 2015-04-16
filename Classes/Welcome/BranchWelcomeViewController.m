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
    return branchOpts[BRANCH_INVITE_USER_FULLNAME_KEY] != nil;
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
    
    [branchWelcomeController tryToLinkInviteWithReferralIfDesired];
    
    return branchWelcomeController;
}


#pragma mark - Interaction methods

- (void)cancelPressed {
    [self.delegate welcomeControllerWasCanceled];
}

- (void)continuePressed {
    [self.delegate welcomeControllerConfirmedInvite];
}

#pragma mark - Internals

- (void)tryToLinkInviteWithReferralIfDesired {
    if ([self.delegate respondsToSelector:@selector(welcomeControllerShouldShowReferredCredits)] && [self.delegate welcomeControllerShouldShowReferredCredits]) {
        self.maxReferralLinkRetryCount = DEFAULT_REFERRAL_LINK_RETRY_COUNT;
        self.currentReferralLinkRetryNumber = 0;
        
        if ([self.delegate respondsToSelector:@selector(welcomeControllerMaxReferralLinkRetryCount)]) {
            self.maxReferralLinkRetryCount = [self.delegate welcomeControllerMaxReferralLinkRetryCount];
        }
        
        NSString *invitingUserId = self.branchOpts[BRANCH_INVITE_USER_ID_KEY];
        if (invitingUserId) {
            [self checkForReferral:invitingUserId];
        }
        else {
            NSLog(@"BranchWelcomeController was told to show referred user credits, but the invite didn't contain a user id");
        }
    }
}

- (void)checkForReferral:(NSString *)invitingUserId {
    [[Branch getInstance] getCreditHistoryWithCallback:^(NSArray *creditHistoryItems, NSError *error) {
        BOOL referringTransactionFound = NO;
        for (NSDictionary *creditHistoryItem in creditHistoryItems) {
            NSString *referringUserId = creditHistoryItem[@"referrer"];

            // The first (most recent) transaction is considered the "matching" referral
            // transaction if the referring user is equal to the id of the inviting user.
            if ([referringUserId isEqualToString:invitingUserId]) {
                UIView <BranchWelcomeView> *view = (UIView <BranchWelcomeView> *)self.view;
                
                // Allow the view to update with this information
                if ([view respondsToSelector:@selector(setReferredCreditAmount:)]) {
                    NSInteger amount = [creditHistoryItem[@"transaction"][@"amount"] integerValue];
                    [view setReferredCreditAmount:amount];
                }

                referringTransactionFound = YES;
                break;
            }
        }
        
        // Check again in a second if not found, this can take some time to process
        if (!referringTransactionFound && self.currentReferralLinkRetryNumber < self.maxReferralLinkRetryCount) {
            self.currentReferralLinkRetryNumber++;
            [self performSelector:@selector(checkForReferral:) withObject:invitingUserId afterDelay:1];
        }
    }];
}

@end
