//
//  BranchInviteSendingCompletionDelegate.h
//  BranchInvite
//
//  Created by Graham Mueller on 1/25/15.
//
//

@protocol BranchInviteSendingCompletionDelegate <NSObject>

- (void)invitesSent;
- (void)invitesCanceled;

@end
