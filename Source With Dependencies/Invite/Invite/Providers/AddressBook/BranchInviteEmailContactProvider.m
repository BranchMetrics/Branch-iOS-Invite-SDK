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
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *inviteMessageFormat;
@property (weak, nonatomic) id <BranchInviteSendingCompletionDelegate> inviteSendingCompletionDelegate;

@end

@implementation BranchInviteEmailContactProvider

+ (BranchInviteEmailContactProvider *)emailContactProviderWithSubject:(NSString *)subject inviteMessageFormat:(NSString *)inviteMessageFormat {
    return [[BranchInviteEmailContactProvider alloc] initWithSubject:subject inviteMessageFormat:inviteMessageFormat];
}

- (id)init {
    if (self = [super init]) {
        _subject = @"Come Join Me in this Cool App!";
        _inviteMessageFormat = @"I've been using this cool app lately, and I was hoping you'd come and join me. You can check it out here: %@";
    }
    
    return self;
}

- (id)initWithSubject:(NSString *)subject inviteMessageFormat:(NSString *)inviteMessageFormat {
    if (self = [super init]) {
        _subject = subject;
        _inviteMessageFormat = inviteMessageFormat;
    }
    
    return self;
}

#pragma mark - BranchInviteContactProvider methods
- (void)loadContactsWithCallback:(callbackWithStatus)callback {
    [self loadContactsFromAddressBookIfPossible:callback];
}

- (NSString *)loadFailureMessage {
    return @"Couldn't show email contacts; permission for address book was denied.";
}

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
    [mailComposeController setSubject:self.subject];
    [mailComposeController setMessageBody:[NSString stringWithFormat:self.inviteMessageFormat, inviteUrl] isHTML:NO];
    
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
- (void)loadContactsFromAddressBookIfPossible:(callbackWithStatus)callback {
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil); // TODO pass in options and error maybe?
    
    if (authorizationStatus == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            // TODO check error maybe?
            if (!granted) {
                callback(NO, nil);
            }
            else {
                [self loadContactsFromAddressBook:addressBook callback:callback];
            }
        });
    }
    else if (authorizationStatus == kABAuthorizationStatusAuthorized) {
        [self loadContactsFromAddressBook:addressBook callback:callback];
    }
    else {
        callback(NO, nil);
    }
}

- (void)loadContactsFromAddressBook:(ABAddressBookRef)addressBook callback:(callbackWithStatus)callback {
    NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSMutableArray *addressBookContacts = [[NSMutableArray alloc] init];
    
    for (id recordRef in allContacts) {
        ABRecordRef contact = (__bridge ABRecordRef)recordRef;
        ABMultiValueRef emails = ABRecordCopyValue(contact, kABPersonEmailProperty);

        if (ABMultiValueGetCount(emails) > 0) {
            BranchInviteAddressBookContact *addressBookContact = [[BranchInviteAddressBookContact alloc] init];
            addressBookContact.displayName = (__bridge_transfer NSString *)ABRecordCopyCompositeName(contact);
            addressBookContact.contact = CFRetain(contact);
            
            if (ABPersonHasImageData(contact)) {
                NSData *contactImageData = (__bridge_transfer NSData *)ABPersonCopyImageData(contact);
                addressBookContact.displayImage = [UIImage imageWithData:contactImageData];
            }
            
            [addressBookContacts addObject:addressBookContact];
        }
        
        CFRelease(contact);
        CFRelease(emails);
    }
    
    // Sort by displayName
    [addressBookContacts sortUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES] ]];
    
    self.addressBookContacts = addressBookContacts;
    
    callback(YES, nil);
}

@end
