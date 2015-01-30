//
//  BranchInviteControllerDelegate.h
//  BranchInvite
//
//  Created by Graham Mueller on 1/25/15.
//
//

@protocol BranchInviteControllerDelegate <NSObject>

#pragma mark - Controller Delegation
@required
- (void)inviteControllerDidFinish;
- (void)inviteControllerDidCancel;

@optional
- (NSArray *)inviteContactProviders;

#pragma mark - Inviting User Information
@required
- (NSString *)invitingUserId;
- (NSString *)invitingUserFullname;

@optional
- (NSString *)invitingUserShortName;
- (NSString *)invitingUserImageUrl;

@end
