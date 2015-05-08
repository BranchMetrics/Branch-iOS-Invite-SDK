//
//  BranchSharing.h
//  BranchInvite
//
//  Created by Graham Mueller on 5/5/15.
//
//

#import <Foundation/Foundation.h>
#import "BranchSharingDelegate.h"

extern NSString * const BRANCH_SHARING_SHARE_TEXT;
extern NSString * const BRANCH_SHARING_SHARE_IMAGE;

@protocol BranchSharingViewStyleDelegate <NSObject>

- (UIColor *)branchSharingViewBackgroundColor;
- (UIColor *)branchSharingViewForegroundColor;

@end

@interface BranchSharing : NSObject

+ (void)registerForSharingEventsWithKey:(NSString *)key;
+ (void)registerForSharingEventsWithKey:(NSString *)key styleDelegate:(id <BranchSharingViewStyleDelegate>)delegate;
+ (void)registerForSharingEventsWithKey:(NSString *)key view:(UIView <BranchSharingDelegate> *)view;
+ (void)registerForSharingEventsWithKey:(NSString *)key controller:(UIViewController <BranchSharingDelegate> *)controller;

+ (UIViewController *)sharingControllerForBranchOpts:(NSDictionary *)branchOpts;

@end
