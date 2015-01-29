//
//  BranchInviteViewController.m
//  BranchInvite
//
//  Created by Graham Mueller on 1/23/15.
//
//

#import "BranchInviteViewController.h"
#import "HMSegmentedControl.h"
#import "BranchInviteContactProvider.h"
#import "BranchInviteSendingCompletionDelegate.h"
#import "BranchInviteEmailContactProvider.h"
#import "BranchInviteTextContactProvider.h"
#import <Branch/Branch.h>

@interface BranchInviteViewController () <BranchInviteSendingCompletionDelegate>

@property (strong, nonatomic) NSArray *contactProviders;
@property (weak, nonatomic) id <BranchInviteControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *contactTable;

@end

@implementation BranchInviteViewController

+ (UINavigationController *)branchInviteViewControllerWithDelegate:(id <BranchInviteControllerDelegate>)delegate {
    NSString *branchInviteBundlePath = [[NSBundle mainBundle] pathForResource:@"BranchInvite" ofType:@"bundle"];
    NSBundle *branchInviteBundle = [NSBundle bundleWithPath:branchInviteBundlePath];

    BranchInviteViewController *branchInviteController = [[BranchInviteViewController alloc] initWithNibName:@"BranchInviteViewController" bundle:branchInviteBundle];
    branchInviteController.delegate = delegate;

    return [[UINavigationController alloc] initWithRootViewController:branchInviteController];
}

- (void)loadView {
    [super loadView];
    
    [[Branch getInstance] userCompletedAction:@"viewed_invite_screen"];

    // Don't want to be laid out under the nav bar.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
    
    // TODO allow these to be specified
    self.contactProviders = @[ [[BranchInviteEmailContactProvider alloc] init], [[BranchInviteTextContactProvider alloc] init] ];

    self.segmentedControl.selectedTextColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    self.segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:45/255.0 green:157/255.0 blue:188/255.0 alpha:1];
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.sectionTitles = [self.contactProviders valueForKey:@"segmentTitle"];
    [self.segmentedControl addTarget:self action:@selector(providerChanged) forControlEvents:UIControlEventValueChanged];
    
    [self.contactTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ContactCell"];
}

#pragma mark - Interaction Methods
- (void)providerChanged {
    [self.contactTable reloadData];
}

- (void)cancelPressed {
    [self.delegate inviteControllerDidCancel];
}

- (void)donePressed {
    Branch *branch = [Branch getInstance];
    id <BranchInviteContactProvider> provider = self.contactProviders[self.segmentedControl.selectedSegmentIndex];
    NSArray *contacts = [provider contacts];
    NSString *channel = [provider channel];
    NSArray *selectedIndexPaths = [self.contactTable indexPathsForSelectedRows];
    NSMutableArray *selectedContacts = [[NSMutableArray alloc] init];

    // TODO there might be a way to get this directly w/o the for loop
    for (NSIndexPath *indexPath in selectedIndexPaths) {
        [selectedContacts addObject:contacts[indexPath.row]];
    }
    
    // Optional
    id normalizedImageUrl = [NSNull null];
    if ([self.delegate respondsToSelector:@selector(invitingUserImageUrl)]) {
        normalizedImageUrl = [self.delegate invitingUserImageUrl];
    }
    
    NSDictionary *urlParams = @{
        @"invitingUserId": [self.delegate invitingUserId],
        @"invitingUserFullname": [self.delegate invitingUserFullname],
        @"invitingUserImageUrl": normalizedImageUrl
    };
    
    [branch getShortURLWithParams:urlParams andChannel:channel andFeature:BRANCH_FEATURE_TAG_INVITE andCallback:^(NSString *url, NSError *error) {
        if (error) {
            NSLog(@"Failed to retrieve short url for invite");
            return;
        }
        
        [branch userCompletedAction:@"selected_contacts"];

        UIViewController *inviteSendingViewController = [provider inviteSendingController:selectedContacts inviteUrl:url completionDelegate:self];
        [self presentViewController:inviteSendingViewController animated:YES completion:NULL];
    }];
}

#pragma mark - InviteSendingControllerDelegate
- (void)invitesSent {
    // Don't show this dismissal, let our delegate show the animation.
    // Otherwise you see two levels of dismissal, which looks kind of weird.
    [self dismissViewControllerAnimated:NO completion:^{
        [[Branch getInstance] userCompletedAction:@"sent_invite"];
        
        [self.delegate inviteControllerDidFinish];
    }];
}

- (void)invitesCanceled {
    // If the specific invite view was canceled, we won't just blindly exit. Perhaps they
    // want to utilize a different provider instead, or realized they missed some contacts.
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableView Data Source / Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <BranchInviteContactProvider> provider = self.contactProviders[self.segmentedControl.selectedSegmentIndex];
    
    return [[provider contacts] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    id <BranchInviteContactProvider> provider = self.contactProviders[self.segmentedControl.selectedSegmentIndex];
    BranchInviteContact *contact = [provider contacts][indexPath.row];
    
    // TODO sexify
    cell.textLabel.text = contact.displayName;

    return cell;
}

@end
