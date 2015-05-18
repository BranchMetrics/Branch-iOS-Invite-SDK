//
//  BranchSharingDefaultView.h
//  BranchInvite
//
//  Created by Graham Mueller on 5/5/15.
//
//

#import <UIKit/UIKit.h>
#import "BranchSharingView.h"
#import "BranchSharing.h"

@interface BranchSharingDefaultView : UIView <BranchSharingView>

@property (weak, nonatomic) id <BranchSharingViewStyleDelegate> styleDelegate;

@end
