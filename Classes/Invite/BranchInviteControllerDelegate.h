//
//  BranchInviteControllerDelegate.h
//  BranchInvite
//
//  Created by Graham Mueller on 1/25/15.
//
//

#import <HMSegmentedControl/HMSegmentedControl.h>

@protocol BranchInviteControllerDelegate <NSObject>

#pragma mark - Controller Delegation
@required
// Method for transitioning away from the invite controller once it has successfully sent invites.
- (void)inviteControllerDidFinish;

// Method for transitioning away from the invite controller after the invitation process was canceled.
- (void)inviteControllerDidCancel;

@optional
// Method for specifying an array of contact providers to use.
// Will default to Email and Text if not provided.
- (NSArray *)inviteContactProviders;

#pragma mark - View Customization
@optional

- (UIColor *)inviteItemColor;

// Allows for configuration of any of the UI elements of the HMSegmentedControl.
// Stylize however you like, but note that you should not add targets or specify tab titles.
// These items will be removed.
- (void)configureSegmentedControl:(HMSegmentedControl *)segmentedControl;

// Optionally provide a nib to use for the contact rows in the contact table.
// NOTE: the class in the nib *must* fulfill the BranchInviteContactCell contact.
- (UINib *)nibForContactRows;

// Optionally provide a class to use for the contact rows in the contact table.
// This value will only be used if a nib is not provided.
// NOTE: the class *must* fulfill the BranchInviteContactCell contact.
- (Class)classForContactRows;

// Specify a height for the custom cell being provided, if desired.
// Will default to 44px if not provided.
- (CGFloat)heightForContactRows;

#pragma mark - Invite Information
@required
// Inviting user fullname. Will be bundled w/ invite url.
// Shown in the Welcome screen when an invited user logs in.
- (NSString *)invitingUserFullname;

@optional
// Inviting user identifier. Will be bundled w/ invite url.
- (NSString *)invitingUserId;

// Additional items to add to the Branch URL that will be
// created. This can include any custom NSJSONSerializable
// items you want. Common uses are things like redirect keys,
// or content items to display.
- (NSDictionary *)inviteUrlCustomData;

// Inviting user short name. Will be bundled w/ invite url.
// Shown in the Welcome screen when an invited user logs in.
// Will default to inviting user fullname if not provided.
- (NSString *)invitingUserShortName;

// Inviting user image url. Will be bundled w/ invite url.
// Shown in the Welcome screen when an invited user logs in.
// Will default to null / placeholder image if not provided.
- (NSString *)invitingUserImageUrl;

@end
