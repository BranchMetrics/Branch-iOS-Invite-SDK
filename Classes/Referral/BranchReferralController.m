//
//  BranchReferralController.m
//  BranchInvite
//
//  Created by Graham Mueller on 4/13/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "BranchReferralController.h"
#import "BranchInviteBundleUtil.h"
#import "BranchInviteViewController.h"
#import <Branch/Branch.h>
#import "BranchReferralDefaultView.h"

@interface BranchReferralController () <BranchReferralViewControllerDisplayDelegate>

@property (weak, nonatomic) id <BranchReferralControllerDelegate> delegate;
@property (strong, nonatomic) UIView <BranchReferralView> *contentView;
@property (strong, nonatomic) UINavigationBar *navBar;

- (IBAction)donePressed:(id)sender;

@end

@implementation BranchReferralController

+ (BranchReferralController *)branchReferralControllerWithDelegate:(id <BranchReferralControllerDelegate>)delegate {
    return [BranchReferralController branchReferralControllerWithDelegate:delegate inviteDelegate:nil];
}

+ (BranchReferralController *)branchReferralControllerWithDelegate:(id <BranchReferralControllerDelegate>)delegate inviteDelegate:(id <BranchInviteControllerDelegate>)inviteDelegate {
    NSBundle *branchInviteBundle = [BranchInviteBundleUtil branchInviteBundle];
    
    BranchReferralDefaultView *defaultView = [[branchInviteBundle loadNibNamed:@"BranchReferralDefaultView" owner:self options:kNilOptions] objectAtIndex:0];
    defaultView.inviteDelegate = inviteDelegate;
    
    return [BranchReferralController branchReferralControllerWithView:defaultView delegate:delegate];
}

+ (BranchReferralController *)branchReferralControllerWithView:(UIView <BranchReferralView> *)view delegate:(id <BranchReferralControllerDelegate>)delegate {
    BranchReferralController *controller = [[BranchReferralController alloc] init];
    controller.delegate = delegate;
    controller.contentView = view;
    
    if ([view respondsToSelector:@selector(setControllerDisplayDelegate:)]) {
        [view setControllerDisplayDelegate:controller];
    }
    
    return controller;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Don't layout under things
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Build up the navigation bar and add it
    // Taller nav bar for iOS 7.0 and beyond since they layout under the status bar
    CGFloat navBarHeight = NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0 ? 59 : 44;
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, navBarHeight)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(donePressed:)];
    
    navigationItem.rightBarButtonItem = doneButton;
    self.navBar.items = @[ navigationItem ];
    
    [self.view addSubview:self.navBar];

    // Ensure the view doesn't use auto resizing constraints
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;

    // Go through the full view cycle for the content view
    [self.contentView willMoveToSuperview:self.view];
    [self.view addSubview:self.contentView];
    [self.contentView didMoveToSuperview];
    
    // Create constraints, pinned top to bottom of navbar, left to view edge, right to view edge, bottom to view edge
    NSLayoutConstraint *contentViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.navBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *contentViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *contentViewRightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *contentViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    // Add them
    [self.view addConstraints:@[ contentViewTopConstraint, contentViewRightConstraint, contentViewBottomConstraint, contentViewLeftConstraint ]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController || self.tabBarController) {
        CGRect navBarFrame = self.navBar.frame;
        navBarFrame.size.height = 0;
        self.navBar.frame = navBarFrame;
    }
    
    [[Branch getInstance] getCreditHistoryWithCallback:^(NSArray *transactions, NSError *error) {
        NSArray *referrals = [transactions filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSDictionary *transaction, NSDictionary *bindings) {
            return [self isReferral:transaction];
        }]];
        
        [self.contentView setCreditHistoryItems:transactions];
        [self.contentView setReferrals:referrals];
    }];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    
    // Set up the tab item defaults
    self.title = @"Referrals";
    self.tabBarItem.image = [BranchInviteBundleUtil imageNamed:@"referrals-icon" type:@"png"];
}


#pragma mark - Interaction methods

- (void)donePressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(branchReferralControllerCompleted)]) {
        [self.delegate branchReferralControllerCompleted];
    }
}


#pragma mark - BranchReferralViewControllerDisplayDelegate methods
- (void)displayController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^)())completion {
    [self presentViewController:controller animated:animated completion:completion];
}

- (void)dismissControllerAnimated:(BOOL)animated completion:(void (^)())completion {
    [self dismissViewControllerAnimated:animated completion:completion];
}


#pragma mark - Internals

- (BOOL)isReferral:(NSDictionary *)transaction {
    NSString *currentSessionId = [self.delegate referringUserId];
    NSString *referrer = transaction[@"referrer"];
    NSString *referree = transaction[@"referree"];
    
    BOOL referreeIsSetAndIsNotMe = referree && ![referree isEqualToString:currentSessionId];
    BOOL referrerIsSetAndIsMe = referrer && [referrer isEqualToString:currentSessionId];
    
    // This transaction is a referral made by me if one of the two are true:
    // * The referree is set (BranchReferringUser type referrals), and  it is not me. If it is me, that means I was referred.
    // * The referrer is set (BranchReferreeUser, BranchBothUsers), and is me. If it is not me, that means I wasn't the referrer.
    return referreeIsSetAndIsNotMe || referrerIsSetAndIsMe;
}

@end
