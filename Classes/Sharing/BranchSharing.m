//
//  BranchSharing.m
//  BranchInvite
//
//  Created by Graham Mueller on 5/5/15.
//
//

#import "BranchSharing.h"
#import "BranchSharingDefaultView.h"
#import "BranchSharingDefaultViewController.h"
#import "BranchInviteBundleUtil.h"

NSString * const BRANCH_SHARING_SHARE_TEXT = @"BranchShareText";
NSString * const BRANCH_SHARING_SHARE_IMAGE = @"BranchShareImage";

@implementation BranchSharing

+ (UIViewController <BranchSharingController> *)sharingControllerForBranchOpts:(NSDictionary *)branchOpts delegate:(id <BranchSharingControllerDelegate>)delegate {
    UIViewController <BranchSharingController> *sharingController;
    NSDictionary *sharingControllers = [BranchSharing sharingControllers];
    for (NSString *potentialSharingKey in [sharingControllers allKeys]) {
        if (branchOpts[potentialSharingKey]) {
            sharingController = sharingControllers[potentialSharingKey];
            sharingController.delegate = delegate;
            [sharingController configureWithSharingData:branchOpts];
            break;
        }
    }

    return sharingController;
}


#pragma mark - View Registration

+ (void)registerForSharingEventsWithKey:(NSString *)key {
    BranchSharingDefaultView *defaultView = [[[BranchInviteBundleUtil branchInviteBundle] loadNibNamed:@"BranchSharingDefaultView" owner:self options:kNilOptions] firstObject];
    [BranchSharing registerForSharingEventsWithKey:key view:defaultView];
}

+ (void)registerForSharingEventsWithKey:(NSString *)key styleDelegate:(id <BranchSharingViewStyleDelegate>)delegate {
    BranchSharingDefaultView *defaultView = [[[BranchInviteBundleUtil branchInviteBundle] loadNibNamed:@"BranchSharingDefaultView" owner:self options:kNilOptions] firstObject];
    defaultView.styleDelegate = delegate;

    [BranchSharing registerForSharingEventsWithKey:key view:defaultView];
}

+ (void)registerForSharingEventsWithKey:(NSString *)key view:(UIView <BranchSharingView> *)view {
    BranchSharingDefaultViewController *controller = [[BranchSharingDefaultViewController alloc] init];
    [controller setBranchSharingView:view];

    [BranchSharing sharingControllers][key] = controller;
}

+ (void)registerForSharingEventsWithKey:(NSString *)key controller:(UIViewController <BranchSharingControllerDelegate> *)controller {
    [BranchSharing sharingControllers][key] = controller;
}


#pragma mark - Internals
+ (NSMutableDictionary *)sharingControllers {
    static NSMutableDictionary *sharingControllers;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharingControllers = [[NSMutableDictionary alloc] init];
    });
    
    return sharingControllers;
}

@end
