//
//  BranchSharingView.h
//  Pods
//
//  Created by Graham Mueller on 5/18/15.
//
//

#import "BranchSharingDelegate.h"

/**
 Protocol for a view that will be used for sharing content. Basically just a view that provides a "done" button.
 */
@protocol BranchSharingView <BranchSharingDelegate>

/**
 The button that indicates the view is ready to be dismissed.
 */
- (UIButton *)doneButton;

@end
