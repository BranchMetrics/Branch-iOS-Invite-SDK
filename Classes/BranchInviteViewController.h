//
//  BranchInviteViewController.h
//  BranchInvite
//
//  Created by Graham Mueller on 1/23/15.
//
//

#import <UIKit/UIKit.h>
#import "BranchInviteControllerDelegate.h"

@interface BranchInviteViewController : UIViewController

+ (UINavigationController *)branchInviteViewControllerWithDelegate:(id <BranchInviteControllerDelegate>)delegate;

@end
