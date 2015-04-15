//
//  BranchReferralController.h
//  BranchInvite
//
//  Created by Graham Mueller on 4/13/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BranchInviteViewController.h"
#import "BranchReferralView.h"

@protocol BranchReferralControllerDelegate <NSObject>

- (void)branchReferralControllerCompleted;
- (NSString *)referringUserId;

@end

@interface BranchReferralController : UIViewController

// Create a BranchController with a custom content view that conforms to the BranchReferralView protocol
+ (BranchReferralController *)branchReferralControllerWithView:(UIView <BranchReferralView> *)view delegate:(id <BranchReferralControllerDelegate>)delegate;

// Create a BranchController with the default content view
+ (BranchReferralController *)branchReferralControllerWithDelegate:(id <BranchReferralControllerDelegate>)delegate;

// Create a BranchController with the default content view and the ability to send invites
+ (BranchReferralController *)branchReferralControllerWithDelegate:(id <BranchReferralControllerDelegate>)delegate inviteDelegate:(id <BranchInviteControllerDelegate>)inviteDelegate;

@end
