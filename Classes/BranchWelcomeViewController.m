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

@end

@implementation BranchWelcomeViewController

+ (BOOL)shouldShowWelcome:(NSDictionary *)branchOpts {
    return branchOpts[@"invitingUserId"] != nil;
}

+ (BranchWelcomeViewController *)branchWelcomeViewControllerWithDelegate:(id <BranchWelcomeControllerDelegate>)delegate branchOpts:(NSDictionary *)branchOpts {
    NSString *branchInviteBundlePath = [[NSBundle mainBundle] pathForResource:@"BranchInvite" ofType:@"bundle"];
    NSBundle *branchInviteBundle = [NSBundle bundleWithPath:branchInviteBundlePath];
    
    BranchWelcomeViewController *branchWelcomeController = [[BranchWelcomeViewController alloc] initWithNibName:@"BranchWelcomeViewController" bundle:branchInviteBundle];
    branchWelcomeController.delegate = delegate;
    branchWelcomeController.branchOpts = branchOpts;
    
    return branchWelcomeController;
}

- (void)loadView {
    [super loadView];
    
    [[Branch getInstance] userCompletedAction:@"viewed_personal_welcome"];
    
    // Don't want to be laid out under the nav bar.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];

    NSString *invitingUserFullname = self.branchOpts[@"invitingUserFullname"];
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
    self.welcomeBodyLabel.text = [NSString stringWithFormat:@"Welcome to the app! You've been invited to join the fun by another user, %@.", invitingUserFullname];
    [self.confirmInviteButton setTitle:[NSString stringWithFormat:@"Press here to continue via %@'s referral", invitingUserFullname] forState:UIControlStateNormal];
}

#pragma mark - Interaction methods
- (void)cancelPressed {
    [self.delegate welcomeControllerWasCanceled];
}

@end
