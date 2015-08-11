//
//  BranchInviteViewController.m
//  BranchInvite
//
//  Created by Graham Mueller on 1/23/15.
//
//

#import "BranchInviteViewController.h"
#import <Branch/Branch.h>
#import "BranchInvite.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "BranchInviteContactProvider.h"
#import "BranchInviteSendingCompletionDelegate.h"
#import "BranchInviteEmailContactProvider.h"
#import "BranchInviteTextContactProvider.h"
#import "BranchInviteDefaultContactCell.h"
#import "BranchInviteBundleUtil.h"

@interface BranchInviteViewController () <BranchInviteSendingCompletionDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSArray *contactProviders;
@property (strong, nonatomic) NSArray *currentContacts;
@property (strong, nonatomic) UIColor *inviteItemColor;
@property (weak, nonatomic) id <BranchInviteControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentedControlHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *contactTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation BranchInviteViewController

+ (UINavigationController *)branchInviteViewControllerWithDelegate:(id <BranchInviteControllerDelegate>)delegate {
    NSBundle *branchInviteBundle = [BranchInviteBundleUtil branchInviteBundle];
    BranchInviteViewController *branchInviteController = [[BranchInviteViewController alloc] initWithNibName:@"BranchInviteViewController" bundle:branchInviteBundle];
    branchInviteController.delegate = delegate;

    return [[UINavigationController alloc] initWithRootViewController:branchInviteController];
}

- (void)loadView {
    [super loadView];
    
    [[Branch getInstance] userCompletedAction:@"viewed_invite_screen"];
    
    self.inviteItemColor = [UIColor colorWithRed:45/255.0 green:157/255.0 blue:188/255.0 alpha:1];
    
    if ([self.delegate respondsToSelector:@selector(inviteItemColor)]) {
        self.inviteItemColor = [self.delegate inviteItemColor];
    }
    
    [self configureNavigationItems];
    [self configureContactProviders];
    [self configureSegmentedControl];
    [self configureContactTable];
    
    // Load contacts for the first provider
    [self loadContactsForProviderThenLoadTable:[self.contactProviders firstObject]];
}

#pragma mark - Configuration
- (void)configureNavigationItems {
    // Don't want to be laid out under the nav bar.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
}

- (void)configureContactProviders {
    // Determine if providers are specified, or use default
    self.contactProviders = @[ [[BranchInviteEmailContactProvider alloc] init], [[BranchInviteTextContactProvider alloc] init] ];
    if ([self.delegate respondsToSelector:@selector(inviteContactProviders)]) {
        NSArray *contactProviders = [self.delegate inviteContactProviders];
        
        // Verify that the provided contact providers is a non-empty array
        if ([contactProviders count]) {
            self.contactProviders = contactProviders;
        }
    }
}

- (void)configureSegmentedControl {
    if ([self.contactProviders count] == 1) {
        self.segmentedControlHeightConstraint.constant = 0;
        return;
    }

    // Set up all of the defaults
    self.segmentedControl.textColor = [UIColor whiteColor];
    self.segmentedControl.selectedTextColor = [UIColor whiteColor];
    self.segmentedControl.selectionIndicatorColor = [UIColor whiteColor];
    self.segmentedControl.backgroundColor = self.inviteItemColor;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;

    // Now allow for overrides
    if ([self.delegate respondsToSelector:@selector(configureSegmentedControl:)]) {
        [self.delegate configureSegmentedControl:self.segmentedControl];
    }

    // Clean up any nefarious action additions
    for (id target in [self.segmentedControl allTargets]) {
        for (NSString *action in [self.segmentedControl actionsForTarget:target forControlEvent:UIControlEventValueChanged]) {
            [self.segmentedControl removeTarget:target action:NSSelectorFromString(action) forControlEvents:UIControlEventValueChanged];
        }
    }

    self.segmentedControl.sectionTitles = [self.contactProviders valueForKey:@"segmentTitle"];
    [self.segmentedControl addTarget:self action:@selector(providerChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)configureContactTable {
    self.contactTable.allowsMultipleSelection = YES;
    
    // Optionally allow for row height specification
    CGFloat rowHeightForContactRows = 0;
    if ([self.delegate respondsToSelector:@selector(heightForContactRows)]) {
        rowHeightForContactRows = [self.delegate heightForContactRows];
    }
    
    // If the delegate didn't provide a height, or provided a 0 height, use default
    if (rowHeightForContactRows <= 0) {
        rowHeightForContactRows = 44;
    }
    
    // Table configuration. Prefer custom nib to custom class, and custom class to our default.
    BOOL registeredACell = NO;
    if ([self.delegate respondsToSelector:@selector(nibForContactRows)]) {
        UINib *nibForContactRows = [self.delegate nibForContactRows];
        
        if (nibForContactRows) {
            [self.contactTable registerNib:nibForContactRows forCellReuseIdentifier:@"ContactCell"];
            self.contactTable.rowHeight = rowHeightForContactRows;
            registeredACell = YES;
        }
    }
    else if ([self.delegate respondsToSelector:@selector(classForContactRows)]) {
        Class classForContactRows = [self.delegate classForContactRows];
        
        if (classForContactRows) {
            [self.contactTable registerClass:classForContactRows forCellReuseIdentifier:@"ContactCell"];
            self.contactTable.rowHeight = rowHeightForContactRows;
            registeredACell = YES;
        }
    }
    
    // If no cell was successfully registered (not implemented or nil), use default
    if (!registeredACell) {
        [self.contactTable registerNib:[BranchInviteBundleUtil nibNamed:@"BranchInviteDefaultContactCell"] forCellReuseIdentifier:@"ContactCell"];
        self.contactTable.rowHeight = 56;
    }
}

#pragma mark - Interaction Methods
- (void)providerChanged {
    id <BranchInviteContactProvider> provider = self.contactProviders[self.segmentedControl.selectedSegmentIndex];
    NSArray *contacts = [provider contacts];
    
    // For now, blindly assuming that "if empty, not loaded." This will have the interesting side effect of allowing providers who have
    // failed to reattempt if the user has corrected the error condition. Not sure if this is preferable or not, yet to be determined.
    if (![contacts count]) {
        [self loadContactsForProviderThenLoadTable:provider];
    }
    else {
        self.currentContacts = contacts;
        [self filterContactsForSearchText];
    }
}

- (void)cancelPressed {
    [self.delegate inviteControllerDidCancel];
}

- (void)donePressed {
    Branch *branch = [Branch getInstance];
    id <BranchInviteContactProvider> provider = self.contactProviders[self.segmentedControl.selectedSegmentIndex];
    NSString *channel = [provider channel];
    NSMutableArray *selectedContacts = [[NSMutableArray alloc] init];

    for (NSIndexPath *indexPath in self.contactTable.indexPathsForSelectedRows) {
        [selectedContacts addObject:self.currentContacts[indexPath.row]];
    }
    
    NSDictionary *invitingUserParams = [self createInvitingUserParams];
    
    [branch getReferralUrlWithParams:invitingUserParams andChannel:channel andCallback:^(NSString *url, NSError *error) {
        if (error) {
            NSLog(@"Failed to retrieve short url for invite");
            return;
        }
        
        [branch userCompletedAction:@"selected_contacts"];

        UIViewController *inviteSendingViewController = [provider inviteSendingController:selectedContacts inviteUrl:url completionDelegate:self];

        if (inviteSendingViewController) {
            [self presentViewController:inviteSendingViewController animated:YES completion:NULL];
        }
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

#pragma mark - UISearchBarDelegate methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterContactsForSearchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UITableView Data Source / Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.currentContacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell <BranchInviteContactCell>*cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    BranchInviteContact *contact = self.currentContacts[indexPath.row];
    
    BOOL isSelected = [tableView.indexPathsForSelectedRows containsObject:indexPath];
    [cell configureCellWithContact:contact selected:isSelected inviteItemColor:self.inviteItemColor];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];
    
    UITableViewCell <BranchInviteContactCell>*cell = (UITableViewCell <BranchInviteContactCell>*)[tableView cellForRowAtIndexPath:indexPath];
    [cell updateForSelection];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];

    UITableViewCell <BranchInviteContactCell>*cell = (UITableViewCell <BranchInviteContactCell>*)[tableView cellForRowAtIndexPath:indexPath];
    [cell updateForDeselection];
}

#pragma mark - Internal methods
- (void)filterContactsForSearchText {
    NSString *searchText = self.searchBar.text;
    id <BranchInviteContactProvider> provider = self.contactProviders[self.segmentedControl.selectedSegmentIndex];
    NSArray *allContactsForProvider = [provider contacts];
    
    if (searchText.length) {
        self.currentContacts = [allContactsForProvider filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"displayName CONTAINS[cd] %@", searchText]];
    }
    else {
        self.currentContacts = allContactsForProvider;
    }
    
    [self.contactTable reloadData];
}

- (void)loadContactsForProviderThenLoadTable:(id <BranchInviteContactProvider>)provider {
    [provider loadContactsWithCallback:^(BOOL loaded, NSError *error) {
        if (loaded) {
            self.currentContacts = [provider contacts];
            [self filterContactsForSearchText];
        }
        else {
            NSString *failureMessage = [provider loadFailureMessage];
            [[[UIAlertView alloc] initWithTitle:@"Failed to load contacts" message:failureMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (NSDictionary *)createInvitingUserParams {
    // Required user info
    NSString *userId = [self.delegate invitingUserId];
    NSString *userFullname = [self.delegate invitingUserFullname];
    
    // Optional user info
    id normalizedImageUrl = [NSNull null];
    if ([self.delegate respondsToSelector:@selector(invitingUserImageUrl)]) {
        NSString *providedImageUrl = [self.delegate invitingUserImageUrl];

        if (providedImageUrl) {
            normalizedImageUrl = providedImageUrl;
        }
    }
    
    NSString *normalizedShortName = userFullname;
    if ([self.delegate respondsToSelector:@selector(invitingUserShortName)]) {
        NSString *providedShortName = [self.delegate invitingUserShortName];
        
        if (providedShortName) {
            normalizedShortName = providedShortName;
        }
    }
    
    NSMutableDictionary *inviteParams = [[NSMutableDictionary alloc] init];
    
    // First, apply any customized data
    if ([self.delegate respondsToSelector:@selector(inviteUrlCustomData)]) {
        NSDictionary *customData = [self.delegate inviteUrlCustomData];
        
        if (customData) {
            [inviteParams addEntriesFromDictionary:customData];
        }
    }

    // Then, add all of our data, overwriting any bad entries
    inviteParams[BRANCH_INVITE_USER_ID_KEY] = userId;
    inviteParams[BRANCH_INVITE_USER_FULLNAME_KEY] = userFullname;
    inviteParams[BRANCH_INVITE_USER_SHORT_NAME_KEY] = normalizedShortName;
    inviteParams[BRANCH_INVITE_USER_IMAGE_URL_KEY] = normalizedImageUrl;
    
    return inviteParams;
}

@end
