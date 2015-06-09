//
//  BranchSharingViewController.h
//  BranchInvite
//
//  Created by Graham Mueller on 5/7/15.
//
//

#import <UIKit/UIKit.h>
#import "BranchSharingController.h"
#import "BranchSharingView.h"

@interface BranchSharingDefaultViewController : UIViewController <BranchSharingController>

- (void)setBranchSharingView:(UIView <BranchSharingView> *)sharingView;
- (void)configureWithSharingData:(NSDictionary *)sharingData;

@end
