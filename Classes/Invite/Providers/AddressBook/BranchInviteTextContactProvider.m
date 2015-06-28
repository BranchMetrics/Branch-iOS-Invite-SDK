//
//  BranchInviteTextContactProvider.m
//  BranchInvite
//
//  Created by Graham Mueller on 1/25/15.
//
//

#import "BranchInviteTextContactProvider.h"
#import "BranchInviteAddressBookContact.h"
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>

@interface BranchInviteTextContactProvider () <MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) NSString *inviteMessageFormat;
@property (strong, nonatomic) NSArray *addressBookContacts;
@property (weak, nonatomic) id <BranchInviteSendingCompletionDelegate> inviteSendingCompletionDelegate;

@end

@implementation BranchInviteTextContactProvider

+ (BranchInviteTextContactProvider *)textContactProviderWithInviteMessageFormat:(NSString *)inviteMessageFormat {
    return [[BranchInviteTextContactProvider alloc] initWithInviteMessageFormat:inviteMessageFormat];
}

- (id)init {
    if (self = [super init]) {
        self.inviteMessageFormat =  @"I've been using this cool app lately, and I was hoping you'd come and join me. You can check it out here: %@";
    }
    
    return self;
}

- (id)initWithInviteMessageFormat:(NSString *)inviteMessageFormat {
    if (self = [super init]) {
        self.inviteMessageFormat = inviteMessageFormat;
    }
    
    return self;
}

#pragma mark - BranchInviteContactProvider methods
- (void)loadContactsWithCallback:(callbackWithStatus)callback {
    [self loadContactsFromAddressBookIfPossible:callback];
}

- (NSString *)loadFailureMessage {
    return @"Couldn't show text contacts; permission for address book was denied.";
}

- (NSString *)segmentTitle {
    return @"Text";
}

- (NSString *)channel {
    return @"sms";
}

- (NSArray *)contacts {
    return self.addressBookContacts;
}

- (UIViewController *)inviteSendingController:(NSArray *)selectedContacts inviteUrl:(NSString *)inviteUrl completionDelegate:(id <BranchInviteSendingCompletionDelegate>)completionDelegate {
    if (![MFMessageComposeViewController canSendText]) {
        NSLog(@"Cannot send texts.");
        [completionDelegate invitesCanceled];
        return nil;
    }
    
    self.inviteSendingCompletionDelegate = completionDelegate;
    
    NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
    for (BranchInviteAddressBookContact *addressBookContact in selectedContacts) {
        ABMultiValueRef numbers = ABRecordCopyValue(addressBookContact.contact, kABPersonPhoneProperty);
        
        for (int i = 0; i < ABMultiValueGetCount(numbers); i++) {
            NSString *phoneNumber = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(numbers, i);
            
            [phoneNumbers addObject:phoneNumber];
        }
        
        CFRelease(numbers);
    }
    
    // TODO allow message specification
    MFMessageComposeViewController *messageComposeController = [[MFMessageComposeViewController alloc] init];
    [messageComposeController setMessageComposeDelegate:self];
    [messageComposeController setRecipients:phoneNumbers];
    [messageComposeController setBody:[NSString stringWithFormat:self.inviteMessageFormat, inviteUrl]];
    
    return messageComposeController;
}

#pragma mark - MFMessageComposeDelegate methods
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    if (result == MessageComposeResultSent) {
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
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(contact, kABPersonPhoneProperty);
        
        if (ABMultiValueGetCount(phoneNumbers) > 0) {
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
        CFRelease(phoneNumbers);
    }
    
    // Sort by displayName
    [addressBookContacts sortUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES] ]];
    
    self.addressBookContacts = addressBookContacts;
    
    callback(YES, nil);
}

@end
