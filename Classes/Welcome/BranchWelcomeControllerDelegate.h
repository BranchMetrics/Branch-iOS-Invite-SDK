//
//  BranchWelcomeControllerDelegate.h
//  BranchInvite
//
//  Created by Graham Mueller on 1/25/15.
//
//
//  A protocol for the presenter of the welcome view controller.
//  This currently just handles completion of the controller.
//

@protocol BranchWelcomeControllerDelegate <NSObject>

// Called when the user affirms the welcome screen, indicating
// that they were, in fact, invited to join the application.
- (void)welcomeControllerConfirmedInvite;

// Called when the user denies and closes the welcome screen,
// when they don't want to continue with the invite process.
- (void)welcomeControllerWasCanceled;

@end
