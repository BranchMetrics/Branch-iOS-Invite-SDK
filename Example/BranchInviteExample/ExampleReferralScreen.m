//
//  ExampleReferringScreen.m
//  BranchInviteExample
//
//  Created by Graham Mueller on 5/22/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "ExampleReferralScreen.h"

@interface ExampleReferralScreen()

@property (weak, nonatomic) IBOutlet UILabel *creditHistoryCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *referralsCountLabel;
@property (weak, nonatomic) id <BranchReferralViewControllerDisplayDelegate> displayDelegate;

- (IBAction)dismissController:(id)sender;

@end

@implementation ExampleReferralScreen

- (void)setCreditHistoryItems:(NSArray *)creditHistoryItems {
    self.creditHistoryCountLabel.text = [NSString stringWithFormat:@"%ld Credit History items", [creditHistoryItems count]];
}

- (void)setReferrals:(NSArray *)referrals {
    self.referralsCountLabel.text = [NSString stringWithFormat:@"%ld Referrals", [referrals count]];
}

- (void)dismissController:(id)sender {
    [self.displayDelegate dismissControllerAnimated:YES completion:NULL];
}

@end
