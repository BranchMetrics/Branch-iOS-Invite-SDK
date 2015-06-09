//
//  CreditsController.m
//  BranchInviteExample
//
//  Created by Graham Mueller on 5/22/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "CreditsController.h"
#import "Branch.h"

@interface CreditsController ()

@property (weak, nonatomic) IBOutlet UILabel *creditCountLabel;
@property (weak, nonatomic) IBOutlet UIView *loadingMask;

- (IBAction)redeemCreditsButton:(id)sender;

@end

@implementation CreditsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[Branch getInstance] loadRewardsWithCallback:^(BOOL changed, NSError *error) {
        self.creditCountLabel.text = [NSString stringWithFormat:@"%ld credits available", (long)[[Branch getInstance] getCredits]];
    }];
}

- (void)redeemCreditsButton:(id)sender {
    self.loadingMask.hidden = NO;
    [[Branch getInstance] redeemRewards:5 callback:^(BOOL changed, NSError *error) {
        self.loadingMask.hidden = YES;
        if (error) {
            NSLog(@"Unable to redeem credits: %@", error);
            return;
        }

        self.creditCountLabel.text = [NSString stringWithFormat:@"%ld credits available", (long)[[Branch getInstance] getCredits]];
    }];
}

@end
