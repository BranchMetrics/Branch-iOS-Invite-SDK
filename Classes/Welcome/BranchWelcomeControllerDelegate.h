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
// Optional method indicating whether the controller should try to find a matching referral transaction and show the value to the user.
// Note, if you want to use this, the invite MUST have specified the INVITING_USER_ID.
- (BOOL)welcomeControllerShouldShowReferredCredits;

// Optional method indicating how many times to try to find a link between the invite and a referral transaction, in the
// case that one isn't found immediately. There is a one second gap between retries, and the default retry count is three.
- (NSInteger)welcomeControllerMaxReferralLinkRetryCount;

// Optional method allowing you to provide the text displayed for the welcome title message, given the provided user fullname and short name.
- (NSString *)welcomeTitleTextForFullname:(NSString *)invitingUserFullname shortName:(NSString *)invitingUserShortName;

// Optional method allowing you to provide the text displayed for the welcome body message, given the provided user fullname and short name.
- (NSString *)welcomeBodyTextForFullname:(NSString *)invitingUserFullname shortName:(NSString *)invitingUserShortName;

// Optional method allowing you to provide the text displayed for the welcome earned credits message, given the provided credit amount.
// This should be used in conjunction with the `welcomeControllerShouldShowReferredCredits` method.
- (NSString *)welcomeEarnedCreditsTextForAmount:(NSInteger)creditAmount;

// Optional method allowing you to provide the text displayed for the welcome continue button, given the provided user fullname and short name.
- (NSString *)welcomeContinueButtonTextForFullname:(NSString *)invitingUserFullname shortName:(NSString *)invitingUserShortName;

// Color to set the title text and body background.
- (UIColor *)welcomeSchemeColor;

// Color for body text.
- (UIColor *)welcomeBodyTextColor;

// Font to set the title text
- (UIFont *)titleTextFont;

// Font for body text.
- (UIFont *)bodyTextFont;

// Font for continue button text.
- (UIFont *)continueButtonFont;

@end
