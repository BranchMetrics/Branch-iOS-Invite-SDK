//
//  BranchWelcomeViewController.h
//  Pods
//
//  Created by Graham Mueller on 1/25/15.
//
//

#import <UIKit/UIKit.h>
#import "BranchWelcomeControllerDelegate.h"
#import "BranchWelcomeView.h"

@interface BranchWelcomeViewController : UIViewController

+ (BOOL)shouldShowWelcome:(NSDictionary *)branchOpts;
+ (BranchWelcomeViewController *)branchWelcomeViewControllerWithDelegate:(id <BranchWelcomeControllerDelegate>)delegate branchOpts:(NSDictionary *)branchOpts;
+ (BranchWelcomeViewController *)branchWelcomeViewControllerWithCustomView:(UIView <BranchWelcomeView>*)customView delegate:(id <BranchWelcomeControllerDelegate>)delegate branchOpts:(NSDictionary *)branchOpts;

@end
