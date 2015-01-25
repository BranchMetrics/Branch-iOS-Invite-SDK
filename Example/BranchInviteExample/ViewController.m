//
//  ViewController.m
//  BranchInviteExample
//
//  Created by Graham Mueller on 1/23/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "ViewController.h"
#import "BranchInviteViewController.h"

@implementation ViewController

- (IBAction)inviteButtonPressed:(id)sender {
    id branchInviteViewController = [BranchInviteViewController branchInviteViewController];
    
    [self presentViewController:branchInviteViewController animated:YES completion:NULL];
}

@end
