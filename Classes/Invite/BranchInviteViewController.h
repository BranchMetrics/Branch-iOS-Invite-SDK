//
//  BranchInviteViewController.h
//  BranchInvite
//
//  Created by Graham Mueller on 1/23/15.
//
//
//  Where all the magic happens. This controller is what applications
//  should utilize to allows their users to send invites to their user.
//  It is wrapped in a UINavigationController, primarily for use of the
//  nav bar for buttons. This may be changed in a future version, so apps
//  shouldn't rely on the return type for now. Instead, they should just
//  blindly call presentViewController: and take our word for it :)
//
//  The required delegate offers a number of methods that are required
//  (things like actual delegation info, for completion, and user info)
//  as well as a number of optional items (things like UI override points).
//

#import <UIKit/UIKit.h>
#import "BranchInviteControllerDelegate.h"

@interface BranchInviteViewController : UIViewController

+ (UINavigationController *)branchInviteViewControllerWithDelegate:(id <BranchInviteControllerDelegate>)delegate;

@end
