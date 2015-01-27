//
//  BranchWelcomeControllerDelegate.h
//  BranchInvite
//
//  Created by Graham Mueller on 1/25/15.
//
//

@protocol BranchWelcomeControllerDelegate <NSObject>

- (void)welcomeControllerConfirmedInvite;
- (void)welcomeControllerWasCanceled;

@end
