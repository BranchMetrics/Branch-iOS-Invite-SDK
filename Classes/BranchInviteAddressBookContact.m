//
//  BranchInviteAddressBookContact.m
//  BranchInvite
//
//  Created by Graham Mueller on 1/25/15.
//
//

#import "BranchInviteAddressBookContact.h"

@implementation BranchInviteAddressBookContact

- (void)dealloc {
    CFRelease(self.contact);
}

@end
