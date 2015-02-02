//
//  BranchInviteTextContactProvider.h
//  BranchInvite
//
//  Created by Graham Mueller on 1/25/15.
//
//
//  This class is one of the default contact provider classes
//  provided in this project. It will gather contacts from the
//  device address book, and will show an MFMessageComposeController
//  when contacts have been selected. The message can be customized
//  to fit an app's requirements.
//

#import <Foundation/Foundation.h>
#import "BranchInviteContactProvider.h"

@interface BranchInviteTextContactProvider : NSObject <BranchInviteContactProvider>

+ (BranchInviteTextContactProvider *)textContactProviderWithInviteMessageFormat:(NSString *)inviteMessageFormat;

@end
