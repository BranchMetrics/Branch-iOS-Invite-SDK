//
//  BranchWelcomeView.h
//  BranchInvite
//
//  Created by Graham Mueller on 2/1/15.
//
//
//  This protocol is intended to be used for developers who want to provide
//  a custom view for the Welcome screen. It is basically just a UIView that
//  conforms to a couple of methods that the BranchWelcomeViewController will
//  call while initializing in order to track its state. These methods are
//  required, and will throw exceptions if not implemented.
//

@protocol BranchWelcomeView <NSObject>

// Called once to allow the view to configure itself with the relevant user info.
- (void)configureWithInviteUserInfo:(NSDictionary *)userInviteInfo;

// The button the controller should attach itself to to capture cancel events.
- (UIButton *)cancelButton;

// The button the controller should attach itself to to capture continue events.
- (UIButton *)continueButton;

@end
