//
//  BranchReferralView.h
//  Pods
//
//  Created by Graham Mueller on 4/15/15.
//
//

#import "BranchReferralViewControllerDisplayDelegate.h"

@protocol BranchReferralView <NSObject>

/**
 Sets a list of *all* transactions this user has participated in that have increased or decreased their credit count.
 
 @param creditHistoryItems All transactions for the user.
 */
- (void)setCreditHistoryItems:(NSArray *)creditHistoryItems;

/**
 Sets a list of transactions that are referrals by this user.
 
 @param referrals Referrals for the user.
 */
- (void)setReferrals:(NSArray *)referrals;

@optional

/**
 Sets a delegate allowing this view to notify its desire to be dismissed. Necessary when presented modally.
 
 @param displayDelegate The delegate that will manage dismissing this view.
 */
- (void)setControllerDisplayDelegate:(id <BranchReferralViewControllerDisplayDelegate>)displayDelegate;

@end
