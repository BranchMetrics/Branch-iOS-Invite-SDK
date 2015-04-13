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
#import "BranchReferralController.h"

@interface ViewController () <BranchInviteControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userIdField;
@property (weak, nonatomic) IBOutlet UITextField *userFullnameField;
@property (weak, nonatomic) IBOutlet UITextField *userShortNameField;
@property (weak, nonatomic) IBOutlet UITextField *userImageUrlField;
@property (weak, nonatomic) UITextField *activeTextField;
@property (assign, nonatomic) CGRect keyboardFrame;

@end

@implementation ViewController

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

- (IBAction)viewReferralsPressed:(id)sender {
    BranchReferralController *referralController = [BranchReferralController branchReferralController];
    
    [self presentViewController:referralController animated:YES completion:NULL];
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

// Uncomment this method to see how segmented control customization works
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
    return @{
        @"$ios_url": @"branchinvite://home"
    };
}

- (NSString *)invitingUserId {
    return self.userIdField.text;
}

- (NSString *)invitingUserFullname {
    return self.userFullnameField.text;
}

- (NSString *)invitingUserShortName {
    return self.userShortNameField.text;
}

- (NSString *)invitingUserImageUrl {
    return self.userImageUrlField.text;
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
    if (textField == self.userIdField) {
        [self.userFullnameField becomeFirstResponder];
    }
    else if (textField == self.userFullnameField) {
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
