//
//  BranchReferralDefaultView.h
//  Pods
//
//  Created by Graham Mueller on 4/15/15.
//
//

#import <UIKit/UIKit.h>
#import "BranchReferralView.h"
#import "BranchInviteViewController.h"

@interface BranchReferralDefaultView : UIView <BranchReferralView>

@property (weak, nonatomic) id <BranchInviteControllerDelegate> inviteDelegate;

@end
