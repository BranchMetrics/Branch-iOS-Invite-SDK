//
//  MysteryIncContactProvider.m
//  BranchInviteExample
//
//  Created by Graham Mueller on 1/31/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "MysteryIncContactProvider.h"
#import "MysteryIncInviteController.h"

@interface MysteryIncContactProvider() <MysteryIncInviteControllerDelegate>

@property (strong, nonatomic) NSArray *mysteryInc;
@property (weak, nonatomic) id <BranchInviteSendingCompletionDelegate> inviteCompletionDelegate;

@end

@implementation MysteryIncContactProvider

#pragma mark - BranchInviteContactProvider methods
- (void)loadContactsWithCallback:(callbackWithStatus)callback {
    BranchInviteContact *scooby = [[BranchInviteContact alloc] init];
    scooby.displayName = @"Scooby-Doo";
    
    BranchInviteContact *shaggy = [[BranchInviteContact alloc] init];
    shaggy.displayName = @"Shaggy Rogers";
    
    BranchInviteContact *velma = [[BranchInviteContact alloc] init];
    velma.displayName = @"Velma Dinkley";
    
    BranchInviteContact *freddy = [[BranchInviteContact alloc] init];
    freddy.displayName = @"Freddy Jones";
    
    BranchInviteContact *daphne = [[BranchInviteContact alloc] init];
    daphne.displayName = @"Daphne Blake";
    
    self.mysteryInc = @[ scooby, shaggy, velma, freddy, daphne ];
    
    callback(YES, nil);
}

- (NSString *)loadFailureMessage {
    return nil; // can't fail.
}

- (NSArray *)contacts {
    return self.mysteryInc;
}

- (NSString *)channel {
    return @"television";
}

- (NSString *)segmentTitle {
    return @"Mystery Inc";
}

- (UIViewController *)inviteSendingController:(NSArray *)selectedContacts inviteUrl:(NSString *)inviteUrl completionDelegate:(id <BranchInviteSendingCompletionDelegate>)completionDelegate {
    NSArray *characterNames = [selectedContacts valueForKey:@"displayName"];
    MysteryIncInviteController *inviteController = [MysteryIncInviteController mysteryIncInviteControllerWithUrl:inviteUrl delegate:self charactersToInvite:characterNames];
    
    self.inviteCompletionDelegate = completionDelegate;

    return inviteController;
}

#pragma mark - MysteryIncInviteController
- (void)inviteSent {
    [self.inviteCompletionDelegate invitesSent];
}

- (void)inviteCanceled {
    [self.inviteCompletionDelegate invitesCanceled];
}

@end
