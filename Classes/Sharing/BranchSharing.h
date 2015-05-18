//
//  BranchSharing.h
//  BranchInvite
//
//  Created by Graham Mueller on 5/5/15.
//
//

#import <Foundation/Foundation.h>
#import "BranchSharingView.h"
#import "BranchSharingController.h"

extern NSString * const BRANCH_SHARING_SHARE_TEXT;
extern NSString * const BRANCH_SHARING_SHARE_IMAGE;

@protocol BranchSharingViewStyleDelegate <NSObject>

- (UIColor *)branchSharingViewBackgroundColor;
- (UIColor *)branchSharingViewForegroundColor;

@end

@interface BranchSharing : NSObject

+ (void)registerForSharingEventsWithKey:(NSString *)key;
+ (void)registerForSharingEventsWithKey:(NSString *)key styleDelegate:(id <BranchSharingViewStyleDelegate>)delegate;
+ (void)registerForSharingEventsWithKey:(NSString *)key view:(UIView <BranchSharingView> *)view;
+ (void)registerForSharingEventsWithKey:(NSString *)key controller:(UIViewController <BranchSharingController> *)controller;

+ (UIViewController <BranchSharingController> *)sharingControllerForBranchOpts:(NSDictionary *)branchOpts delegate:(id <BranchSharingControllerDelegate>)delegate;

@end
