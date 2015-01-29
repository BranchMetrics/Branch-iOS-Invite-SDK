//
//  BranchInviteContactProvider.h
//  BranchInvite
//
//  Created by Graham Mueller on 1/25/15.
//
//

#import "BranchInviteContact.h"
#import "BranchInviteSendingCompletionDelegate.h"

@protocol BranchInviteContactProvider <NSObject>

// TODO document
- (NSString *)segmentTitle;
- (NSString *)channel;
- (NSArray *)contacts;
- (UIViewController *)inviteSendingController:(NSArray *)selectedContacts inviteUrl:(NSString *)inviteUrl completionDelegate:(id <BranchInviteSendingCompletionDelegate>)completionDelegate;

// TODO what to show when there are no contacts
// - (UIView *)emptyListView;

@end
