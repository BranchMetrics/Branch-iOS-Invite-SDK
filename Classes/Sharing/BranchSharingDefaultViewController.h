//
//  BranchSharingViewController.h
//  BranchInvite
//
//  Created by Graham Mueller on 5/7/15.
//
//

#import <UIKit/UIKit.h>
#import "BranchSharingDelegate.h"

@interface BranchSharingDefaultViewController : UIViewController <BranchSharingDelegate>

- (void)setBranchSharingView:(UIView <BranchSharingDelegate> *)sharingView;
- (void)configureWithSharingData:(NSDictionary *)sharingData;

@end
