//
//  BranchSharingDelegate.h
//  BranchInvite
//
//  Created by Graham Mueller on 5/5/15.
//
//

#import <Foundation/Foundation.h>

/**
 Base protocol for items that intend to be used for sharing.
 */
@protocol BranchSharingDelegate <NSObject>

/**
 Configure the item with a dictionary of sharing data
 */
- (void)configureWithSharingData:(NSDictionary *)sharingData;

@end
