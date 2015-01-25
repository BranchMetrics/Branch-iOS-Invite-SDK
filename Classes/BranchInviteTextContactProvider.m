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

@interface BranchInviteTextContactProvider ()

@property (strong, nonatomic) NSArray *addressBookContacts;

@end

@implementation BranchInviteTextContactProvider

- (id)init {
    if (self = [super init]) {
        [self loadContactsFromAddressBookIfPossible];
    }
    
    return self;
}

#pragma mark - BranchInviteContactProvider methods
- (NSString *)segmentTitle {
    return @"Text";
}

- (NSArray *)contacts {
    return self.addressBookContacts;
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
    NSArray *allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSMutableArray *addressBookContacts = [[NSMutableArray alloc] init];
    
    for (id recordRef in allContacts) {
        ABRecordRef contact = (__bridge ABRecordRef)recordRef;
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(contact, kABPersonPhoneProperty);
        
        if (ABMultiValueGetCount(phoneNumbers) > 0) {
            BranchInviteAddressBookContact *addressBookContact = [[BranchInviteAddressBookContact alloc] init];
            addressBookContact.displayName = (__bridge_transfer NSString *)ABRecordCopyCompositeName(contact);
            addressBookContact.contact = CFRetain(contact);
            
            [addressBookContacts addObject:addressBookContact];
        }
        
        CFRelease(contact);
        CFRelease(phoneNumbers);
    }
    
    self.addressBookContacts = addressBookContacts;
    
    CFRelease(addressBook);
}

@end
