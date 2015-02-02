//
//  BranchWelcomeViewController.m
//  Pods
//
//  Created by Graham Mueller on 1/25/15.
//
//

#import "BranchWelcomeViewController.h"
#import "BranchInviteBundleUtil.h"
#import <Branch/Branch.h>

@interface BranchWelcomeViewController ()

@property (strong, nonatomic) NSDictionary *branchOpts;
@property (weak, nonatomic) id <BranchWelcomeControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *welcomeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeBodyLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmInviteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageTopConstraint;

- (IBAction)continuePressed;
- (IBAction)cancelPressed;

@end

CGFloat const PREFERRED_WIDTH = 288;

@implementation BranchWelcomeViewController

+ (BOOL)shouldShowWelcome:(NSDictionary *)branchOpts {
    return branchOpts[@"invitingUserId"] != nil;
}

+ (BranchWelcomeViewController *)branchWelcomeViewControllerWithDelegate:(id <BranchWelcomeControllerDelegate>)delegate branchOpts:(NSDictionary *)branchOpts {
    NSBundle *branchInviteBundle = [BranchInviteBundleUtil branchInviteBundle];
    
    BranchWelcomeViewController *branchWelcomeController = [[BranchWelcomeViewController alloc] initWithNibName:@"BranchWelcomeViewController" bundle:branchInviteBundle];
    branchWelcomeController.delegate = delegate;
    branchWelcomeController.branchOpts = branchOpts;
    
    return branchWelcomeController;
}

- (void)loadView {
    [super loadView];
    
    [[Branch getInstance] userCompletedAction:@"viewed_personal_welcome"];
    
    // Place holder image
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2.0;
    self.userImageView.image = [BranchInviteBundleUtil imageNamed:@"user" type:@"png"];

    NSString *invitingUserFullname = self.branchOpts[@"invitingUserFullname"];
    NSString *invitingUserShortName = self.branchOpts[@"invitingUserShortName"] ?: invitingUserFullname;
    NSURL *invitingUserImageUrl = [NSURL URLWithString:self.branchOpts[@"invitingUserImageUrl"]];
    
    if (invitingUserImageUrl) {
        // Load the contents of this image asynchronously.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:invitingUserImageUrl];
            
            // If the image fails to load, just leave the placeholder
            if (!imageData) {
                return;
            }

            UIImage *invitingUserImage = [UIImage imageWithData:imageData];
           
            dispatch_async(dispatch_get_main_queue(), ^{
                self.userImageView.image = invitingUserImage;
            });
        });
    }

    NSString *welcomeTitleText = [NSString stringWithFormat:@"%@ has invited you to use this app!", invitingUserFullname];
    NSString *welcomeBodyText = [NSString stringWithFormat:@"Welcome to the app! You've been invited to join the fun by another user, %@.", invitingUserShortName];

    self.welcomeTitleLabel.text = welcomeTitleText;
    self.welcomeBodyLabel.text = welcomeBodyText;
    [self.confirmInviteButton setTitle:[NSString stringWithFormat:@"Press to join %@", invitingUserShortName] forState:UIControlStateNormal];

    // Versions prior to iOS 8.0 don't auto adjust label frames
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        [self adjustTopConstaints];
        [self resizeWelcomeTitleForText:welcomeTitleText];
        [self resizeWelcomeBodyForText:welcomeBodyText];
    }
}

#pragma mark - Interaction methods
- (void)cancelPressed {
    [self.delegate welcomeControllerWasCanceled];
}

- (void)continuePressed {
    [self.delegate welcomeControllerConfirmedInvite];
}

#pragma mark - Internal methods
- (void)adjustTopConstaints {
    self.cancelTopConstraint.constant -= 16;
    self.userImageTopConstraint.constant -= 20;
}

- (void)resizeWelcomeTitleForText:(NSString *)welcomeTitleText {
    CGFloat height = [welcomeTitleText sizeWithFont:[UIFont boldSystemFontOfSize:20] constrainedToSize:CGSizeMake(PREFERRED_WIDTH, CGFLOAT_MAX)].height;
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.welcomeTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];

    [self.view addConstraint:heightConstraint];
}

- (void)resizeWelcomeBodyForText:(NSString *)welcomeBodyText {
    CGFloat height = [welcomeBodyText sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(PREFERRED_WIDTH, CGFLOAT_MAX)].height;
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.welcomeBodyLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];

    [self.view addConstraint:heightConstraint];
}

@end
