//
//  BranchReferralController.h
//  BranchInvite
//
//  Created by Graham Mueller on 4/13/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BranchInviteViewController.h"

@protocol BranchReferralScoreDelegate <NSObject>

- (void)branchReferralScoreDelegateScreenCompleted;

@end

@interface BranchReferralController : UIViewController

+ (BranchReferralController *)branchReferralControllerWithDelegate:(id <BranchReferralScoreDelegate, BranchInviteControllerDelegate>)delegate;

@property (weak, nonatomic) id <BranchReferralScoreDelegate> delegate;
@property (weak, nonatomic) id <BranchInviteControllerDelegate> inviteDelegate;

@end
