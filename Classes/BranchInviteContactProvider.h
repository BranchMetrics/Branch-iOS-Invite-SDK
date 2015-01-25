//
//  BranchInviteContactProvider.h
//  BranchInvite
//
//  Created by Graham Mueller on 1/25/15.
//
//

#import "BranchInviteContact.h"

@protocol BranchInviteContactProvider <NSObject>

- (NSString *)segmentTitle;
- (NSArray *)contacts;

// TODO
// - (UIView *)emptyListView;
// - (UIViewController *)selectedContactsTransitionController;

@end
