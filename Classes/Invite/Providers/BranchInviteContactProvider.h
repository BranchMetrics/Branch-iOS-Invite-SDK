//
//  BranchInviteContactProvider.h
//  BranchInvite
//
//  Created by Graham Mueller on 1/25/15.
//
//
//  BranchInviteContactProvider is the extension point
//  for any custom provider an app wants to provide. There
//  are a number of defaults provided (Text, Email, Facebook,
//  and possibly others to come), but these may not be enough
//  for any given app. In that case, those apps may provide
//  additional classes that conform to this protocol and
//  provide a list of contacts and a view controller that
//  will be displayed when contacts have been selected.
//

#import "BranchInviteContact.h"
#import "BranchInviteSendingCompletionDelegate.h"
#import <Branch/Branch.h>

@protocol BranchInviteContactProvider <NSObject>

// This method is called when a contact provider is selected for the first time.
// The expectation is that the provider will do some async work, if necessary,
// then call the callback with YES as the status. If the provider fails to load
// its contacts, it should call the callback with a NO status.
- (void)loadContactsWithCallback:(callbackWithStatus)callback;

// This method will be called if the provider calls the callback for
// loadContactsWithCallback: with a NO status. This message will be presented
// to the user via a UIAlertView.
- (NSString *)loadFailureMessage;

// The title of the segment shown in the BranchInviteViewController
- (NSString *)segmentTitle;

// The channel that wil be used for the Branch URL that's created for invites.
- (NSString *)channel;

// An array of BranchInviteContacts that will be displayed in the BranchInviteViewController list.
- (NSArray *)contacts;

// The view controller to present after selecting and confirming a list of contacts
// for this provider. The controller is given an inviteUrl to be shared to the invited
// contacts. The completionDelegate is the InviteController, which will be waiting for the
// controller it's presenting to answer. For example, the TextProvider shows an MFMessageComposeController
// that it is the delegate for. Once the user has sent a message, or canceled, the provider
// will call the corresponding completion method for the invite controller, and the message
// controller (and possible the invite controller) will be dismissed.
- (UIViewController *)inviteSendingController:(NSArray *)selectedContacts inviteUrl:(NSString *)inviteUrl completionDelegate:(id <BranchInviteSendingCompletionDelegate>)completionDelegate;

// TODO
// This view / message is shown when no contacts are available for a provider
// - (UIView *)emptyListView;

@end
