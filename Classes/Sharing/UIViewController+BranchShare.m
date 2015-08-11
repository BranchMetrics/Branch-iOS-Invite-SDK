//
//  UIViewController+BranchShare.m
//  BranchInvite
//
//  Created by Derrick Staten on 4/25/15.
//  Copyright (c) 2015 Branch Metrics. All rights reserved.
//

#import "UIViewController+BranchShare.h"
#import <Branch/Branch.h>

@implementation UIViewController (BranchShare)

- (void)shareText:(NSString *)text {
    [self shareText:text andParams:nil];
}

- (void)shareText:(NSString *)text andParams:(NSDictionary *)params {
    NSString *feature = BRANCH_FEATURE_TAG_SHARE;
    UIActivityItemProvider *itemProvider = [Branch getBranchActivityItemWithParams:params feature:feature stage:nil tags:nil];
    UIActivityViewController *shareViewController = [[UIActivityViewController alloc] initWithActivityItems:@[ text, itemProvider ] applicationActivities:nil];

    [self presentViewController:shareViewController animated:YES completion:nil];
}

@end
