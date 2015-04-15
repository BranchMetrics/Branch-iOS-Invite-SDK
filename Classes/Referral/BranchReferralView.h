//
//  BranchReferralView.h
//  Pods
//
//  Created by Graham Mueller on 4/15/15.
//
//

#import "BranchReferralViewControllerDisplayDelegate.h"

@protocol BranchReferralView <NSObject>

- (void)setCreditHistoryItems:(NSArray *)creditHistoryItems;
- (void)setReferrals:(NSArray *)referrals;

@optional
- (void)setControllerDisplayDelegate:(id <BranchReferralViewControllerDisplayDelegate>)displayDelegate;

@end
