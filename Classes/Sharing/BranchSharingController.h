//
//  BranchSharingControllerDelegate.h
//  Pods
//
//  Created by Graham Mueller on 5/18/15.
//
//

#import <UIKit/UIKit.h>
#import "BranchSharingDelegate.h"

@protocol BranchSharingControllerDelegate

- (void)branchSharingControllerCompleted;

@end

/**
 Protocol for a controller that will be used for sharing content. Used to provide dismissing hooks.
 */
@protocol BranchSharingController <BranchSharingDelegate>

/**
 The delegate to notify once the sharing process has completed
 */
@property (weak, nonatomic) id <BranchSharingControllerDelegate> delegate;

@end
