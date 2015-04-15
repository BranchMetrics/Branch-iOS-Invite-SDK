//
//  BranchReferralViewControllerDisplayDelegate.h
//  Pods
//
//  Created by Graham Mueller on 4/15/15.
//
//

#import <UIKit/UIKit.h>

@protocol BranchReferralViewControllerDisplayDelegate <NSObject>

- (void)displayController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^)())completion;
- (void)dismissControllerAnimated:(BOOL)animated completion:(void (^)())completion;

@end
