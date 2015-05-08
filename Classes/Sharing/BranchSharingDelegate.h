//
//  BranchSharingDelegate.h
//  BranchInvite
//
//  Created by Graham Mueller on 5/5/15.
//
//

#import <Foundation/Foundation.h>

@protocol BranchSharingDelegate <NSObject>

- (void)configureWithSharingData:(NSDictionary *)sharingData;

@end
