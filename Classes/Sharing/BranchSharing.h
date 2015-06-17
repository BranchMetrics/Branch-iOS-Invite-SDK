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

@optional
- (UIColor *)branchSharingViewBackgroundColor;
- (UIColor *)branchSharingViewForegroundColor;
- (UIFont *)branchSharingViewFont;

@end

@interface BranchSharing : NSObject

/**
 Register for a sharing event by using the specified key. This will use the default BranchSharing view and controller.
 
 @param key The key to look for in the launch options indicating that we should launch the share view.
 */
+ (void)registerForSharingEventsWithKey:(NSString *)key;

/**
 Register for a sharing event by using the specified key. This will use the default BranchSharing view and controller, but the delegate allows for simple customizations to the view.
 
 @param key The key to look for in the launch options indicating that we should launch the share view.
 @param delegate The delegate responsible for styling the view.
 */
+ (void)registerForSharingEventsWithKey:(NSString *)key styleDelegate:(id <BranchSharingViewStyleDelegate>)delegate;

/**
 Register for a sharing event by using the specified key and the provided view. This will use the default BranchSharing controller.
 
 @param key The key to look for in the launch options indicating that we should launch the share view.
 @param view The view to show when a matching sharing key is present.
 */
+ (void)registerForSharingEventsWithKey:(NSString *)key view:(UIView <BranchSharingView> *)view;

/**
 Register for a sharing event by using the specified key and the provided controller.
 
 @param key The key to look for in the launch options indicating that we should launch the share view.
 @param controller The controller to use when a matching sharing key is present.
 @warning This method expects you to manage your own view and call the controller's delegate's `branchSharingControllerCompleted` method.
 */
+ (void)registerForSharingEventsWithKey:(NSString *)key controller:(UIViewController <BranchSharingController> *)controller;

/**
 Retrieves an appropriate controller if any sharing keys are found in the Branch open options.
 
 @param branchOpts The options returned from a Branch initSession call.
 @param delegate The delegate to manage dismissing the sharing view once it has completed.
 */
+ (UIViewController <BranchSharingController> *)sharingControllerForBranchOpts:(NSDictionary *)branchOpts delegate:(id <BranchSharingControllerDelegate>)delegate;

@end
