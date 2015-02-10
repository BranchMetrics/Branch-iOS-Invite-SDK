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

@optional
// Optional method allowing you to provide the text displayed for the welcome title message, given the provided user fullname and short name.
- (NSString *)welcomeTitleTextForFullname:(NSString *)invitingUserFullname shortName:(NSString *)invitingUserShortName;

// Optional method allowing you to provide the text displayed for the welcome body message, given the provided user fullname and short name.
- (NSString *)welcomeBodyTextForFullname:(NSString *)invitingUserFullname shortName:(NSString *)invitingUserShortName;

// Optional method allowing you to provide the text displayed for the welcome continue button, given the provided user fullname and short name.
- (NSString *)welcomeContinueButtonTextForFullname:(NSString *)invitingUserFullname shortName:(NSString *)invitingUserShortName;

// Color to set the title text and body background.
- (UIColor *)welcomeSchemeColor;

// Color for body text.
- (UIColor *)welcomeBodyTextColor;

@end
