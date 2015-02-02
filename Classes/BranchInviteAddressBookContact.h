//
//  BranchInviteAddressBookContact.h
//  BranchInvite
//
//  Created by Graham Mueller on 1/25/15.
//
//

#import "BranchInviteContact.h"
#import <AddressBook/AddressBook.h>

@interface BranchInviteAddressBookContact : BranchInviteContact

@property (assign, nonatomic) ABRecordRef contact;

@end
