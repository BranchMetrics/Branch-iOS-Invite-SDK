//
//  BranchInviteSendingCompletionDelegate.h
//  BranchInvite
//
//  Created by Graham Mueller on 1/25/15.
//
//
//  This protocol is what the BranchInviteViewController confirms
//  to and waits for a provider to call after the invite sending
//  controller completes.
//

@protocol BranchInviteSendingCompletionDelegate <NSObject>

// Should be called when a user sends the invites.
- (void)invitesSent;

// Should be called when a user cancels the invite screen.
- (void)invitesCanceled;

@end
