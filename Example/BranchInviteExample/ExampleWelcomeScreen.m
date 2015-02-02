//
//  ExampleWelcomeScreen.m
//  BranchInviteExample
//
//  Created by Graham Mueller on 2/1/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "ExampleWelcomeScreen.h"

@interface ExampleWelcomeScreen ()

@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *userFullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userShortNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userImageUrlLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@end

@implementation ExampleWelcomeScreen

- (void)configureWithInviteUserInfo:(NSDictionary *)userInviteInfo {
    NSString *userId = userInviteInfo[@"invitingUserId"];
    NSString *userFullname = userInviteInfo[@"invitingUserFullname"];
    NSString *userShortName = userInviteInfo[@"invitingUserShortName"];
    NSString *userImageUrl = userInviteInfo[@"invitingUserImageUrl"];
    
    self.userIdLabel.text = userId;
    self.userFullnameLabel.text = userFullname;
    self.userShortNameLabel.text = userShortName;
    self.userImageUrlLabel.text = userImageUrl;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userImageUrl]];
        
        if (!imageData) {
            return;
        }
        
        UIImage *invitingUserImage = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.userImageView.image = invitingUserImage;
        });
    });
}

@end
