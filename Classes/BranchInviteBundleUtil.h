//
//  BranchInviteBundleUtil.h
//  BranchInvite
//
//  Created by Graham Mueller on 2/1/15.
//
//
//  This class is an internal class that allows for easy
//  lookup of resources within the BranchInvite bundle.
//  These specific methods are not documented, as they're
//  basically just wrappers on Apple functions that use
//  the BranchInvite bundle specifically.
//

#import <UIKit/UIKit.h>

@interface BranchInviteBundleUtil : NSObject

+ (NSBundle *)branchInviteBundle;
+ (UINib *)nibNamed:(NSString *)nibName;
+ (UIImage *)imageNamed:(NSString *)imageName type:(NSString *)type;

@end
