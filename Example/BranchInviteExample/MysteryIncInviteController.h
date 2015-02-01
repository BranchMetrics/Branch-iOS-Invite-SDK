//
//  MysteryIncInviteController.h
//  BranchInviteExample
//
//  Created by Graham Mueller on 2/1/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MysteryIncInviteControllerDelegate <NSObject>

- (void)inviteSent;
- (void)inviteCanceled;

@end

@interface MysteryIncInviteController : UIViewController

+ (MysteryIncInviteController *)mysteryIncInviteControllerWithUrl:(NSString *)url delegate:(id <MysteryIncInviteControllerDelegate>)delegate charactersToInvite:(NSArray *)charactersToInvite;

@end
