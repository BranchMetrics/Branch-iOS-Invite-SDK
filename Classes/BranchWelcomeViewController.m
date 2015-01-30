//
//  BranchWelcomeViewController.m
//  Pods
//
//  Created by Graham Mueller on 1/25/15.
//
//

#import "BranchWelcomeViewController.h"
#import <Branch/Branch.h>

@interface BranchWelcomeViewController ()

@property (strong, nonatomic) NSDictionary *branchOpts;
@property (weak, nonatomic) id <BranchWelcomeControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *welcomeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeBodyLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmInviteButton;

- (IBAction)continuePressed;
- (IBAction)cancelPressed;

@end

@implementation BranchWelcomeViewController

+ (BOOL)shouldShowWelcome:(NSDictionary *)branchOpts {
    return branchOpts[@"invitingUserId"] != nil;
}

+ (BranchWelcomeViewController *)branchWelcomeViewControllerWithDelegate:(id <BranchWelcomeControllerDelegate>)delegate branchOpts:(NSDictionary *)branchOpts {
    NSBundle *branchInviteBundle = [BranchWelcomeViewController branchInviteBundle];
    
    BranchWelcomeViewController *branchWelcomeController = [[BranchWelcomeViewController alloc] initWithNibName:@"BranchWelcomeViewController" bundle:branchInviteBundle];
    branchWelcomeController.delegate = delegate;
    branchWelcomeController.branchOpts = branchOpts;
    
    return branchWelcomeController;
}

- (void)loadView {
    [super loadView];
    
    [[Branch getInstance] userCompletedAction:@"viewed_personal_welcome"];
    
    // Place holder image
    NSBundle *branchInviteBundle = [BranchWelcomeViewController branchInviteBundle];
    UIImage *userIcon = [UIImage imageNamed:@"user" inBundle:branchInviteBundle compatibleWithTraitCollection:nil];
    self.userImageView.image = userIcon;

    NSString *invitingUserFullname = self.branchOpts[@"invitingUserFullname"];
    NSString *invitingUserShortName = self.branchOpts[@"invitingUserShortName"] ?: invitingUserFullname;
    NSURL *invitingUserImageUrl = [NSURL URLWithString:self.branchOpts[@"invitingUserImageUrl"]];
    
    if (invitingUserImageUrl) {
        // Load the contents of this image asynchronously.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:invitingUserImageUrl];
            UIImage *invitingUserImage = [UIImage imageWithData:imageData];
           
            dispatch_async(dispatch_get_main_queue(), ^{
                self.userImageView.image = invitingUserImage;
            });
        });
    }

    self.welcomeTitleLabel.text = [NSString stringWithFormat:@"%@ has invited you to use this app!", invitingUserFullname];
    self.welcomeBodyLabel.text = [NSString stringWithFormat:@"Welcome to the app! You've been invited to join the fun by another user, %@.", invitingUserShortName];
    [self.confirmInviteButton setTitle:[NSString stringWithFormat:@"Press to join %@", invitingUserShortName] forState:UIControlStateNormal];
}

#pragma mark - Interaction methods
- (void)cancelPressed {
    [self.delegate welcomeControllerWasCanceled];
}

- (void)continuePressed {
    [self.delegate welcomeControllerConfirmedInvite];
}

#pragma mark - Internal methods
+ (NSBundle *)branchInviteBundle {
    NSString *branchInviteBundlePath = [[NSBundle mainBundle] pathForResource:@"BranchInvite" ofType:@"bundle"];
    NSBundle *branchInviteBundle = [NSBundle bundleWithPath:branchInviteBundlePath];

    return branchInviteBundle;
}

@end
