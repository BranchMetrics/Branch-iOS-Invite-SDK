//
//  BranchReferralDefaultView.m
//  Pods
//
//  Created by Graham Mueller on 4/15/15.
//
//

#import "BranchReferralDefaultView.h"
#import "BranchInviteViewController.h"

@interface BranchReferralDefaultView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *referrals;
@property (strong, nonatomic) NSArray *creditHistoryItems;
@property (weak, nonatomic) IBOutlet UIButton *referralCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *referralScoreLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *referralListHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *pointsView;
@property (weak, nonatomic) IBOutlet UIView *transactionsView;
@property (weak, nonatomic) IBOutlet UITableView *creditHistoryTransactionTable;

- (IBAction)inviteUsersPressed:(id)sender;
- (IBAction)showReferralsPressed:(id)sender;

@end

@implementation BranchReferralDefaultView

- (void)setCreditHistoryItems:(NSArray *)creditHistoryItems {
    _creditHistoryItems = creditHistoryItems;
    
    [self.creditHistoryTransactionTable reloadData];
}

- (void)setReferrals:(NSArray *)referrals {
    _referrals = referrals;
    
    NSString *referralsCount = [NSString stringWithFormat:@"%lld referrals", (long long)[referrals count]];
    [self.referralCountLabel setTitle:referralsCount forState:UIControlStateNormal];
    
    self.referralScoreLabel.text = [NSString stringWithFormat:@"%@ points", [referrals valueForKeyPath:@"@sum.transaction.amount"]];
    
    self.referralCountLabel.hidden = NO;
    self.referralScoreLabel.hidden = NO;
}


#pragma mark - Interaction methods

- (void)inviteUsersPressed:(id)sender {
    // TODO
//    UINavigationController *inviteController = [BranchInviteViewController branchInviteViewControllerWithDelegate:self];
//    
//    [self presentViewController:inviteController animated:YES completion:NULL];
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
    BOOL isReferral = [self.referrals containsObject:creditHistoryItem];
    NSDictionary *transaction = creditHistoryItem[@"transaction"];
    
    NSNumber *amount = transaction[@"amount"];
    NSString *dateString = [self formatDateString:transaction[@"date"]];
    NSString *actionString;
    
    if (isReferral) {
        actionString = @"Referral";
    }
    else if ([amount integerValue] > 0) {
        actionString = @"Credit";
    }
    else {
        actionString =  @"Redeem";
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", actionString, dateString];
    cell.detailTextLabel.text = [amount stringValue];
    
    return cell;
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
