//
//  BranchWelcomeView.h
//  Pods
//
//  Created by Graham Mueller on 2/1/15.
//
//

@protocol BranchWelcomeView <NSObject>

- (UIButton *)cancelButton;
- (UIButton *)continueButton;

- (void)configureWithInviteUserInfo:(NSDictionary *)userInviteInfo;

@end
