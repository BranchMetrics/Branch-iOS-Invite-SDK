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
#import "Branch.h"

@interface BranchReferralController () <BranchInviteControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *creditHistoryTransactions;
@property (weak, nonatomic) IBOutlet UIButton *referralCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *referralScoreLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *referralListHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *pointsView;
@property (weak, nonatomic) IBOutlet UIView *transactionsView;
@property (weak, nonatomic) IBOutlet UITableView *creditHistoryTransactionTable;

- (IBAction)inviteUsersPressed:(id)sender;
- (IBAction)showReferralsPressed:(id)sender;
- (IBAction)donePressed:(id)sender;

@end

@implementation BranchReferralController

+ (BranchReferralController *)branchReferralControllerWithDelegate:(id <BranchReferralScoreDelegate, BranchInviteControllerDelegate>)delegate {
    NSBundle *branchInviteBundle = [BranchInviteBundleUtil branchInviteBundle];
    
    BranchReferralController *controller = [[BranchReferralController alloc] initWithNibName:@"BranchReferralController" bundle:branchInviteBundle];
    controller.delegate = delegate;
    controller.inviteDelegate = delegate;
    
    return controller;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Don't layout under things
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Taller nav bar for iOS 7.0 and beyond since they layout under the status bar
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
        self.navBarHeightConstraint.constant = 59;
    }
    
    [[Branch getInstance] getCreditHistoryWithCallback:^(NSArray *transactions, NSError *error) {
        self.creditHistoryTransactions = transactions;
        [self.creditHistoryTransactionTable reloadData];

        [self showReferralScoreText:transactions];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController || self.tabBarController) {
        self.navBarHeightConstraint.constant = 0;
    }
}


#pragma mark - Interaction methods

- (void)inviteUsersPressed:(id)sender {
    UINavigationController *inviteController = [BranchInviteViewController branchInviteViewControllerWithDelegate:self];
    
    [self presentViewController:inviteController animated:YES completion:NULL];
}

- (void)showReferralsPressed:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        if (self.referralListHeightConstraint.constant == 0) {
            self.referralListHeightConstraint.constant = self.pointsView.frame.size.height;
            self.transactionsView.hidden = NO;
        }
        else {
            self.referralListHeightConstraint.constant = 0;
            self.transactionsView.hidden = YES;
        }
        
        [self.view layoutIfNeeded];
    }];
}

- (void)donePressed:(id)sender {
    [self.delegate branchReferralScoreDelegateScreenCompleted];
}

#pragma mark - UITableViewDataSource / Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.creditHistoryTransactions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreditHistoryTransactionCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CreditHistoryTransactionCell"];
    }

    NSDictionary *creditHistoryTransaction = self.creditHistoryTransactions[indexPath.row][@"transaction"];
    
    NSNumber *amount = creditHistoryTransaction[@"amount"];
    NSString *dateString = [self formatDateString:creditHistoryTransaction[@"date"]];
    NSString *actionString = [amount integerValue] > 0 ? @"Referral" : @"Redeem";

    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", actionString, dateString];
    cell.detailTextLabel.text = [amount stringValue];
    
    return cell;
}

- (NSString *)formatDateString:(NSString *)dateString {
    static NSDateFormatter *iso8601formatter;
    static NSDateFormatter *tableViewFormatter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        iso8601formatter = [[NSDateFormatter alloc] init];
        iso8601formatter.dateFormat = @"YYYY-MM-dd'T'HH:mm:ss.SSSZ";

        tableViewFormatter = [[NSDateFormatter alloc] init];
        tableViewFormatter.dateStyle = NSDateFormatterShortStyle;
        tableViewFormatter.timeStyle = NSDateFormatterShortStyle;
    });
    
    NSDate *date = [iso8601formatter dateFromString:dateString];
    
    return [tableViewFormatter stringFromDate:date];
}


#pragma mark - BranchInviteController methods

- (void)inviteControllerDidFinish {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    [self.inviteDelegate inviteControllerDidFinish];
}

- (void)inviteControllerDidCancel {
    [self dismissViewControllerAnimated:YES completion:NULL];

    [self.inviteDelegate inviteControllerDidCancel];
}

- (NSArray *)inviteContactProviders {
    return [self.inviteDelegate respondsToSelector:@selector(inviteContactProviders)] ? [self.inviteDelegate inviteContactProviders] : nil;
}

- (void)configureSegmentedControl:(HMSegmentedControl *)segmentedControl {
    if ([self.inviteDelegate respondsToSelector:@selector(configureSegmentedControl:)]) {
        [self.inviteDelegate configureSegmentedControl:segmentedControl];
    }
}

- (UINib *)nibForContactRows {
    return [self.inviteDelegate respondsToSelector:@selector(nibForContactRows)] ? [self.inviteDelegate nibForContactRows] : nil;
}

- (Class)classForContactRows {
    return [self.inviteDelegate respondsToSelector:@selector(classForContactRows)] ? [self.inviteDelegate classForContactRows] : nil;
}

- (CGFloat)heightForContactRows {
    return [self.inviteDelegate respondsToSelector:@selector(heightForContactRows)] ? [self.inviteDelegate heightForContactRows] : 0;
}

- (NSString *)invitingUserFullname {
    return [self.inviteDelegate invitingUserFullname];
}

- (NSString *)invitingUserId {
    return [self.inviteDelegate respondsToSelector:@selector(invitingUserId)] ? [self.inviteDelegate invitingUserId] : nil;
}

- (NSDictionary *)inviteUrlCustomData {
    return [self.inviteDelegate respondsToSelector:@selector(inviteUrlCustomData)] ? [self.inviteDelegate inviteUrlCustomData] : nil;
}

- (NSString *)invitingUserShortName {
    return [self.inviteDelegate respondsToSelector:@selector(invitingUserShortName)] ? [self.inviteDelegate invitingUserShortName] : nil;
}

- (NSString *)invitingUserImageUrl {
    return [self.inviteDelegate respondsToSelector:@selector(invitingUserImageUrl)] ? [self.inviteDelegate invitingUserImageUrl] : nil;
}


#pragma mark - Internals

- (void)showReferralScoreText:(NSArray *)transactions {
    NSArray *referralTransactions = [transactions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"transaction.amount > 0"]];
    NSString *referralsCount = [NSString stringWithFormat:@"%lld referrals", (long long)[referralTransactions count]];
    [self.referralCountLabel setTitle:referralsCount forState:UIControlStateNormal];
    
    self.referralScoreLabel.text = [NSString stringWithFormat:@"%@ points", [referralTransactions valueForKeyPath:@"@sum.transaction.amount"]];

    self.referralCountLabel.hidden = NO;
    self.referralScoreLabel.hidden = NO;
}

@end
