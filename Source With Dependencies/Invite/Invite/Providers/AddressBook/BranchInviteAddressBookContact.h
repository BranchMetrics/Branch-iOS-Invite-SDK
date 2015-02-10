//
//  BranchInviteAddressBookContact.h
//  BranchInvite
//
//  Created by Graham Mueller on 1/25/15.
//
//
//  This class is meant primarily as an internal use class.
//  It is basically just a regular contact, but with an
//  AddressBook record reference property as well.
//

#import "BranchInviteContact.h"
#import <AddressBook/AddressBook.h>

@interface BranchInviteAddressBookContact : BranchInviteContact

@property (assign, nonatomic) ABRecordRef contact;

@end
