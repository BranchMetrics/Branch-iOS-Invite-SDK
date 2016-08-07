//
//  BranchInviteBundleUtil.m
//  BranchInvite
//
//  Created by Graham Mueller on 2/1/15.
//
//

#import "BranchInviteBundleUtil.h"
#import "BranchInviteViewController.h"

@implementation BranchInviteBundleUtil

+ (NSBundle *)branchInviteBundle {
    NSString *branchInviteBundlePath = [[NSBundle bundleForClass:[BranchInviteViewController class]] pathForResource:@"BranchInvite" ofType:@"bundle"];
    NSBundle *branchInviteBundle = [NSBundle bundleWithPath:branchInviteBundlePath];
    
    return branchInviteBundle;
}

+ (UINib *)nibNamed:(NSString *)nibName {
    NSBundle *branchInviteBundle = [BranchInviteBundleUtil branchInviteBundle];
    UINib *nib = [UINib nibWithNibName:nibName bundle:branchInviteBundle];
    
    return nib;
}

+ (UIImage *)imageNamed:(NSString *)imageName type:(NSString *)type {
    NSBundle *branchInviteBundle = [BranchInviteBundleUtil branchInviteBundle];
    NSString *imagePath = [branchInviteBundle pathForResource:imageName ofType:type];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    return image;
}

@end
