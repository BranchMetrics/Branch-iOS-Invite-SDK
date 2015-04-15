//
//  BranchReferralController.h
//  BranchInvite
//
//  Created by Graham Mueller on 4/13/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BranchInviteViewController.h"

@protocol BranchReferralControllerDelegate <NSObject>

- (void)branchReferralControllerCompleted;
- (NSString *)referringUserId;

@end

@interface BranchReferralController : UIViewController

+ (BranchReferralController *)branchReferralControllerWithDelegate:(id <BranchReferralScoreDelegate, BranchInviteControllerDelegate>)delegate;


@end
