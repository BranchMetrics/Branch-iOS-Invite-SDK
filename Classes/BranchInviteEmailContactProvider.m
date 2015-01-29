//
//  BranchInviteEmailContactProvider.m
//  BranchInvite
//
//  Created by Graham Mueller on 1/25/15.
//
//

#import "BranchInviteEmailContactProvider.h"
#import "BranchInviteAddressBookContact.h"
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>

@interface BranchInviteEmailContactProvider () <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSArray *addressBookContacts;
@property (weak, nonatomic) id <BranchInviteSendingCompletionDelegate> inviteSendingCompletionDelegate;

@end

@implementation BranchInviteEmailContactProvider

- (id)init {
    if (self = [super init]) {
        [self loadContactsFromAddressBookIfPossible];
    }
    
    return self;
}

#pragma mark - BranchInviteContactProvider methods
- (NSString *)segmentTitle {
    return @"Email";
}

- (NSString *)channel {
    return @"Email";
}

- (NSArray *)contacts {
    return self.addressBookContacts;
}

- (UIViewController *)inviteSendingController:(NSArray *)selectedContacts inviteUrl:(NSString *)inviteUrl completionDelegate:(id <BranchInviteSendingCompletionDelegate>)completionDelegate {
    if (![MFMailComposeViewController canSendMail]) {
        NSLog(@"Cannot send mail.");
        [completionDelegate invitesCanceled];
        return nil;
    }
    
    self.inviteSendingCompletionDelegate = completionDelegate;
    
    NSMutableArray *emailAddresses = [[NSMutableArray alloc] init];
    for (BranchInviteAddressBookContact *addressBookContact in selectedContacts) {
        ABMultiValueRef emails = ABRecordCopyValue(addressBookContact.contact, kABPersonEmailProperty);
        
        for (int i = 0; i < ABMultiValueGetCount(emails); i++) {
            NSString *emailAddress = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, i);
            
            [emailAddresses addObject:emailAddress];
        }
        
        CFRelease(emails);
    }

    // TODO allow message/title specification
    MFMailComposeViewController *mailComposeController = [[MFMailComposeViewController alloc] init];
    [mailComposeController setMailComposeDelegate:self];
    [mailComposeController setToRecipients:emailAddresses];
    [mailComposeController setSubject:@"Come Join Me in this Cool App!"];
    [mailComposeController setMessageBody:[NSString stringWithFormat:@"I've been using this cool app lately, and I was hoping you'd come and join me. You can check it out here: %@", inviteUrl] isHTML:NO];
    
    return mailComposeController;
}

#pragma mark - MFMailComposeDelegate methods
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result == MFMailComposeResultSent) {
        [self.inviteSendingCompletionDelegate invitesSent];
    }
    else {
        [self.inviteSendingCompletionDelegate invitesCanceled];
    }
}

#pragma mark - Internals
- (void)loadContactsFromAddressBookIfPossible {
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil); // TODO pass in options and error maybe?
    
    if (authorizationStatus == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            // TODO check error maybe?
            if (!granted) {
                NSLog(@"Permission for Address Book was denied");
            }
            else {
                [self loadContactsFromAddressBook:addressBook];
            }
        });
    }
    else if (authorizationStatus == kABAuthorizationStatusAuthorized) {
        [self loadContactsFromAddressBook:addressBook];
    }
    else {
        NSLog(@"Permission for Address Book was denied");
    }
}

- (void)loadContactsFromAddressBook:(ABAddressBookRef)addressBook {
    NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSMutableArray *addressBookContacts = [[NSMutableArray alloc] init];
    
    for (id recordRef in allContacts) {
        ABRecordRef contact = (__bridge ABRecordRef)recordRef;
        ABMultiValueRef emails = ABRecordCopyValue(contact, kABPersonEmailProperty);

        if (ABMultiValueGetCount(emails) > 0) {
            BranchInviteAddressBookContact *addressBookContact = [[BranchInviteAddressBookContact alloc] init];
            addressBookContact.displayName = (__bridge_transfer NSString *)ABRecordCopyCompositeName(contact);
            addressBookContact.contact = CFRetain(contact);
            
            [addressBookContacts addObject:addressBookContact];
        }
        
        CFRelease(contact);
        CFRelease(emails);
    }
    
    self.addressBookContacts = addressBookContacts;
}

@end
