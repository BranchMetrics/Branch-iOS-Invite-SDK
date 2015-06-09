//
//  ViewController.m
//  BranchInviteExample
//
//  Created by Graham Mueller on 1/23/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "ViewController.h"
#import "BranchInviteViewController.h"
#import "BranchInviteTextContactProvider.h"
#import "BranchInviteEmailContactProvider.h"
#import "MysteryIncContactProvider.h"
#import "BranchActivityItemProvider.h"
#import "BranchSharing.h"
#import "UIViewController+BranchShare.h"
#import "BranchReferralController.h"
#import "CurrentUserModel.h"

@interface ViewController () <BranchInviteControllerDelegate, BranchReferralControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UITextField *userFullnameField;
@property (weak, nonatomic) IBOutlet UITextField *userShortNameField;
@property (weak, nonatomic) IBOutlet UITextField *userImageUrlField;
@property (weak, nonatomic) UITextField *activeTextField;
@property (assign, nonatomic) CGRect keyboardFrame;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpCurrentUserIfNecessary];
    
    UITapGestureRecognizer *dismissGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardFromTap)];
    [self.view addGestureRecognizer:dismissGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - Interaction methods

- (IBAction)inviteButtonPressed:(id)sender {
    id branchInviteViewController = [BranchInviteViewController branchInviteViewControllerWithDelegate:self];
    
    [self presentViewController:branchInviteViewController animated:YES completion:NULL];
}

- (IBAction)shareButtonPressed:(id)sender {
    NSString *sharingText = @"This is the profile picture I used to test out Branch's sharing functionality, isn't it great?";
    NSDictionary *params = @{
        BRANCH_SHARING_SHARE_TEXT: sharingText,
        BRANCH_SHARING_SHARE_IMAGE: self.userImageUrlField.text,
        @"$og_image_url": self.userImageUrlField.text,
        @"$og_title": @"Branch Sharing Profile Picture"
    };
    
    [self shareText:sharingText andParams:params];
}

- (IBAction)viewReferralsPressed:(id)sender {
    BranchReferralController *referralController = [BranchReferralController branchReferralControllerWithDelegate:self inviteDelegate:self];
    
    [self presentViewController:referralController animated:YES completion:NULL];
}

- (void)dismissKeyboardFromTap {
    [self.activeTextField resignFirstResponder];
}


#pragma mark - BranchInviteControllerDelegate methods

- (void)inviteControllerDidFinish {
    [self dismissViewControllerAnimated:YES completion:^{
        [[[UIAlertView alloc] initWithTitle:@"Hooray!" message:@"Your invites have been sent!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void)inviteControllerDidCancel {
    [self dismissViewControllerAnimated:YES completion:^{
        [[[UIAlertView alloc] initWithTitle:@"Awe :(" message:@"Your invites were canceled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

// Uncomment these methods to see how segmented control customization works
//- (UIColor *)inviteItemColor {
//    return [UIColor redColor];
//}
//
//- (void)configureSegmentedControl:(HMSegmentedControl *)segmentedControl {
//    segmentedControl.backgroundColor = [UIColor redColor];
//    
//    [segmentedControl addTarget:self action:@selector(invitesSent) forControlEvents:UIControlEventValueChanged]; // NOTE this will be removed
//    segmentedControl.sectionTitles = @[ @"Foo", @"Bar" ]; // NOTE these will be removed
//}

// Uncomment these lines to see how invite tableview customizations work
//- (UINib *)nibForContactRows {
//    return [UINib nibWithNibName:@"ExampleContactCell" bundle:[NSBundle mainBundle]];
//}
//
//- (CGFloat)heightForContactRows {
//    return 72;
//}

- (NSDictionary *)inviteUrlCustomData {
    return @{ };
}

- (NSString *)invitingUserId {
    return [CurrentUserModel sharedModel].userId;
}

- (NSString *)invitingUserFullname {
    return [CurrentUserModel sharedModel].userFullname;
}

- (NSString *)invitingUserShortName {
    return [CurrentUserModel sharedModel].userShortName;
}

- (NSString *)invitingUserImageUrl {
    return [CurrentUserModel sharedModel].userImageUrl;
}

- (NSArray *)inviteContactProviders {
    return @[
        [BranchInviteEmailContactProvider emailContactProviderWithSubject:@"Check out this demo app!" inviteMessageFormat:@"Check out my demo app with Branch!:\n\n%@"],
        [BranchInviteTextContactProvider textContactProviderWithInviteMessageFormat:@"Check out my demo app with Branch!:\n\n%@"],
        [[MysteryIncContactProvider alloc] init]
    ];
}


#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;

    [UIView animateWithDuration:0.2 animations:^{
        [self shiftKeyboardIfNecessary];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userFullnameField) {
        [self.userShortNameField becomeFirstResponder];
    }
    else if (textField == self.userShortNameField) {
        [self.userImageUrlField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }

    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.userFullnameField) {
        [CurrentUserModel sharedModel].userFullname = textField.text;
    }
    else if (textField == self.userShortNameField) {
        [CurrentUserModel sharedModel].userShortName = textField.text;
    }
    else {
        [CurrentUserModel sharedModel].userImageUrl = textField.text;
    }
}


#pragma mark - BranchReferralScore delegate

- (NSString *)referringUserId {
    return [CurrentUserModel sharedModel].userId;
}

- (void)branchReferralControllerCompleted {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Keyboard Management methods

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.keyboardFrame = keyboardFrame;

    [self shiftKeyboardIfNecessary];
}

- (void)keyboardWillHide:(NSNotification *)notification  {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 0;
    self.view.frame = viewFrame;
}


#pragma mark - Internal methods

- (void)setUpCurrentUserIfNecessary {
    CurrentUserModel *sharedModel = [CurrentUserModel sharedModel];
    if (!sharedModel.userId) {
        sharedModel.userId = [NSUUID UUID].UUIDString;
        sharedModel.userFullname = @"Graham Mueller";
        sharedModel.userShortName = @"Graham";
        sharedModel.userImageUrl = @"https://www.gravatar.com/avatar/28ed70ee3c8275f1d307d1c5b6eddfa5";
    }
    
    self.userIdLabel.text = sharedModel.userId;
    self.userFullnameField.text = sharedModel.userFullname;
    self.userShortNameField.text = sharedModel.userShortName;
    self.userImageUrlField.text = sharedModel.userImageUrl;
}

- (void)shiftKeyboardIfNecessary {
    CGRect viewFrame = self.view.frame;
    CGRect activeTextFieldFrame = self.activeTextField.frame;
    CGFloat bottomPadding = 4;
    
    // The lowest point visible on the screen is the height of the screen minus the height of the keyboard, then adjusted by the current position
    // of the view. So, if the view has already been shifted upwards (negative origin), then more of the lower part of the screen is visible.
    CGFloat lowestPointCoveredByKeyboard = -viewFrame.origin.y + viewFrame.size.height - self.keyboardFrame.size.height;
    
    // The active text field's lowest point is its origin.y + its height (so, if it was at y=200, and is 21px tall, then the lowest point is 221.
    // We then check the lowest point covered by the keyboard, as described above, and check if we're below that (and if so, by how much). This
    // will be the amount (plus a little padding) that we further offset the view by.
    CGFloat distanceActiveTextFieldIsUnderFrame = activeTextFieldFrame.origin.y + activeTextFieldFrame.size.height - lowestPointCoveredByKeyboard;
    
    if (distanceActiveTextFieldIsUnderFrame > 0) {
        viewFrame.origin.y -= distanceActiveTextFieldIsUnderFrame + bottomPadding;
        
        self.view.frame = viewFrame;
    }
}

@end
