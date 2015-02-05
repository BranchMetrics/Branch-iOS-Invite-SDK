//
//  BranchWelcomeViewController.h
//  Pods
//
//  Created by Graham Mueller on 1/25/15.
//
//
//  The controller shown to users who have received an invite
//  to the app, then opened it. Whether this should be showed
//  should be determined within the Branch init callback, with
//  the options provided by branch. Something like:
//
//  [[Branch getInstance] initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
//      if ([BranchWelcomeViewController shouldShowWelcome:params]) {
//          BranchWelcomeViewController *welcomeController = [BranchWelcomeViewController branchWelcomeViewControllerWithDelegate:self branchOpts:params];
//      }
//  }];
//
//  The standard call shown above will show the default Branch UI
//  for the welcome screen. If a custom view is desired, call the
//  method with a custom view. Note that this view must conform to
//  the BranchWelcomeView protocol.
//

#import <UIKit/UIKit.h>
#import "BranchWelcomeControllerDelegate.h"
#import "BranchWelcomeView.h"

@interface BranchWelcomeViewController : UIViewController

+ (BOOL)shouldShowWelcome:(NSDictionary *)branchOpts;
+ (BranchWelcomeViewController *)branchWelcomeViewControllerWithDelegate:(id <BranchWelcomeControllerDelegate>)delegate branchOpts:(NSDictionary *)branchOpts;
+ (BranchWelcomeViewController *)branchWelcomeViewControllerWithCustomView:(UIView <BranchWelcomeView>*)customView delegate:(id <BranchWelcomeControllerDelegate>)delegate branchOpts:(NSDictionary *)branchOpts;

@end
