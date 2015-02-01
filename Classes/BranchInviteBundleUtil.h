//
//  BranchInviteBundleUtil.h
//  Pods
//
//  Created by Graham Mueller on 2/1/15.
//
//

#import <UIKit/UIKit.h>

@interface BranchInviteBundleUtil : NSObject

+ (NSBundle *)branchInviteBundle;
+ (UINib *)nibNamed:(NSString *)nibName;
+ (UIImage *)imageNamed:(NSString *)imageName type:(NSString *)type;

@end
