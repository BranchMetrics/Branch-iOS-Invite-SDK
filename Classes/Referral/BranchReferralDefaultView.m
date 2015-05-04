//
//  BranchReferralDefaultView.m
//  Pods
//
//  Created by Graham Mueller on 4/15/15.
//
//

#import "BranchReferralDefaultView.h"

@interface BranchReferralDefaultView () <UITableViewDataSource, UITableViewDelegate, BranchInviteControllerDelegate>

@property (strong, nonatomic) NSArray *referrals;
@property (strong, nonatomic) NSArray *creditHistoryItems;
@property (weak, nonatomic) IBOutlet UIButton *referralCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *referralListHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *transactionsView;
@property (weak, nonatomic) IBOutlet UITableView *creditHistoryTransactionTable;
@property (weak, nonatomic) IBOutlet UIView *pointsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointsViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inviteButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inviteButtonBottomConstraint;
@property (weak, nonatomic) id <BranchReferralViewControllerDisplayDelegate> displayDelegate;

- (IBAction)inviteUsersPressed:(id)sender;
- (IBAction)showReferralsPressed:(id)sender;

@end

@implementation BranchReferralDefaultView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    // Don't show the invite button if no invite delegate is available
    if (!self.inviteDelegate) {
        self.pointsViewBottomConstraint.constant = 0;
        [self.inviteButton setTitle:nil forState:UIControlStateNormal];
        self.inviteButtonHeightConstraint.constant = 0;
        self.inviteButtonBottomConstraint.constant = 0;
    }
}


#pragma mark - BranchReferralView delegate methods

- (void)setCreditHistoryItems:(NSArray *)creditHistoryItems {
    _creditHistoryItems = creditHistoryItems;
    
    self.creditsLabel.text = [NSString stringWithFormat:@"%@ credits", [creditHistoryItems valueForKeyPath:@"@sum.transaction.amount"]];

    [self.creditHistoryTransactionTable reloadData];
}

- (void)setReferrals:(NSArray *)referrals {
    _referrals = referrals;
    
    long long referredCount = (long long)[referrals count];
    NSString *suffix = referredCount == 1 ? @"" : @"s";

    NSString *referralsCount = [NSString stringWithFormat:@"%lld referred user%@", referredCount, suffix];
    [self.referralCountLabel setTitle:referralsCount forState:UIControlStateNormal];
    
    self.referralCountLabel.hidden = NO;
    self.creditsLabel.hidden = NO;
}

- (void)setControllerDisplayDelegate:(id <BranchReferralViewControllerDisplayDelegate>)displayDelegate {
    self.displayDelegate = displayDelegate;
}


#pragma mark - Interaction methods

- (void)inviteUsersPressed:(id)sender {
    id controller = [BranchInviteViewController branchInviteViewControllerWithDelegate:self];
    
    [self.displayDelegate displayController:controller animated:YES completion:NULL];
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
        
        [self layoutIfNeeded];
    }];
}


#pragma mark - UITableViewDataSource / Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.creditHistoryItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreditHistoryTransactionCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CreditHistoryTransactionCell"];
    }
    
    NSDictionary *creditHistoryItem = self.creditHistoryItems[indexPath.row];
    NSDictionary *transaction = creditHistoryItem[@"transaction"];
    
    NSNumber *amount = transaction[@"amount"];
    NSInteger transactionType = [transaction[@"type"] integerValue];
    NSString *formattedDate = [self formatDateString:transaction[@"date"]];
    NSString *actionString;
    
    switch (transactionType) {
        case 0: {
            if ([self.referrals containsObject:creditHistoryItem]) {
                actionString = @"You referred a user";
            }
            else {
                actionString = @"You were referred";
            }
            break;
        }
        case 1: actionString = @"You earned credits"; break;
        case 2: actionString = @"You redeemed credts"; break;
        case 3:
        case 4:
        case 5: actionString = @"Fraud reconciliation"; break;
    }
    
    NSString *timeString = [NSString stringWithFormat:@"(%@)", formattedDate];
    NSString *wholeText = [NSString stringWithFormat:@"%@ %@", actionString, timeString];
    NSMutableAttributedString *attributedActionString = [[NSMutableAttributedString alloc] initWithString:wholeText];
    [attributedActionString addAttributes:@{ NSForegroundColorAttributeName: [UIColor lightGrayColor], NSFontAttributeName: [UIFont systemFontOfSize:10] } range:[wholeText rangeOfString:timeString]];

    cell.textLabel.attributedText = attributedActionString;
    cell.detailTextLabel.text = [amount stringValue];
    
    return cell;
}


#pragma mark - BranchInviteController methods

- (void)inviteControllerDidFinish {
    [self.displayDelegate dismissControllerAnimated:YES completion:NULL];
    
    [self.inviteDelegate inviteControllerDidFinish];
}

- (void)inviteControllerDidCancel {
    [self.displayDelegate dismissControllerAnimated:YES completion:NULL];
    
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

@end
