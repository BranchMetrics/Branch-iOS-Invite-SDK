//
//  BranchSharingControllerDelegate.h
//  Pods
//
//  Created by Graham Mueller on 5/18/15.
//
//

#import <UIKit/UIKit.h>
#import "BranchSharingDelegate.h"

@protocol BranchSharingControllerDelegate <BranchSharingDelegate>

- (void)branchSharingControllerCompleted;

@end

@protocol BranchSharingController <BranchSharingDelegate>

@property (weak, nonatomic) id <BranchSharingControllerDelegate> delegate;

@end
