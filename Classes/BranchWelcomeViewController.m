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
    NSString *userPlaceholderIconPath = [branchInviteBundle pathForResource:@"user" ofType:@"png"];
    self.userImageView.image = [UIImage imageWithContentsOfFile:userPlaceholderIconPath];

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

    NSString *welcomeTitleText = [NSString stringWithFormat:@"%@ has invited you to use this app!", invitingUserFullname];
    NSString *welcomeBodyText = [NSString stringWithFormat:@"Welcome to the app! You've been invited to join the fun by another user, %@.", invitingUserShortName];

    self.welcomeTitleLabel.text = welcomeTitleText;
    self.welcomeBodyLabel.text = welcomeBodyText;
    [self.confirmInviteButton setTitle:[NSString stringWithFormat:@"Press to join %@", invitingUserShortName] forState:UIControlStateNormal];

    // Versions prior to iOS 8.0 don't auto adjust label frames
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
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
+ (NSBundle *)branchInviteBundle {
    NSString *branchInviteBundlePath = [[NSBundle mainBundle] pathForResource:@"BranchInvite" ofType:@"bundle"];
    NSBundle *branchInviteBundle = [NSBundle bundleWithPath:branchInviteBundlePath];

    return branchInviteBundle;
}

- (void)resizeWelcomeTitleForText:(NSString *)welcomeTitleText {
    CGRect welcomeTitleLabelFrame = self.welcomeTitleLabel.frame;
    CGFloat welcomeTitleLabelWidth = welcomeTitleLabelFrame.size.width;
    
    CGFloat height = [welcomeTitleText sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(welcomeTitleLabelWidth, CGFLOAT_MAX)].height;
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.welcomeTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];

    [self.view addConstraint:heightConstraint];
}

- (void)resizeWelcomeBodyForText:(NSString *)welcomeBodyText {
    CGRect welcomeBodyLabelFrame = self.welcomeBodyLabel.frame;
    CGFloat welcomeBodyLabelWidth = welcomeBodyLabelFrame.size.width;
    
    CGFloat height = [welcomeBodyText sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(welcomeBodyLabelWidth, CGFLOAT_MAX)].height;
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.welcomeBodyLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];

    [self.view addConstraint:heightConstraint];
}

@end
