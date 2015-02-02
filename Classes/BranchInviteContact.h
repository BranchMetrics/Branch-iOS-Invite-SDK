//
//  BranchInviteContact.h
//  BranchInvite
//
//  Created by Graham Mueller on 1/25/15.
//
//
//  BranchInviteContacts are what the BranchInviteViewController
//  uses for rendering the rows it its Contact table. Providers
//  must return an array of these items. The display image is
//  recommended, but not required (at least not for the default
//  view). Display name is required.
//

#import <UIKit/UIKit.h>

@interface BranchInviteContact : NSObject

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) UIImage *displayImage;

@end
