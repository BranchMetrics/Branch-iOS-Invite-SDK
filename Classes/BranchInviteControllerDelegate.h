//
//  BranchInviteControllerDelegate.h
//  BranchInvite
//
//  Created by Graham Mueller on 1/25/15.
//
//

@protocol BranchInviteControllerDelegate <NSObject>

- (void)inviteControllerDidFinish;
- (void)inviteControllerDidCancel;

@end
