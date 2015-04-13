//
//  BranchReferralController.m
//  BranchInvite
//
//  Created by Graham Mueller on 4/13/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "BranchReferralController.h"
#import "BranchInviteBundleUtil.h"
#import "Branch.h"

@interface BranchReferralController ()

@property (weak, nonatomic) IBOutlet UILabel *referringLabel;

@end

@implementation BranchReferralController

+ (BranchReferralController *)branchReferralController {
    NSBundle *branchInviteBundle = [BranchInviteBundleUtil branchInviteBundle];
    
    return [[BranchReferralController alloc] initWithNibName:@"BranchReferralController" bundle:branchInviteBundle];
}

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[Branch getInstance] getCreditHistoryWithCallback:^(NSArray *list, NSError *error) {
        NSNumber *numReferrals = @([list count]);
        NSNumber *referralsValue = [list valueForKeyPath:@"@sum.transaction.amount"];
        
        NSString *referralString = [NSString stringWithFormat:@"You've referred %@ users for a total of %@ points!", numReferrals, referralsValue];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:referralString];
        [attributedString setAttributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:15] } range:[referralString rangeOfString:[numReferrals stringValue]]];
        [attributedString setAttributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:15] } range:[referralString rangeOfString:[referralsValue stringValue]]];

        self.referringLabel.attributedText = attributedString;
    }];
}

@end
