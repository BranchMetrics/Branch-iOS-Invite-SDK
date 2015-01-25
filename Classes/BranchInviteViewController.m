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
#import "BranchInviteEmailContactProvider.h"
#import "BranchInviteTextContactProvider.h"

@interface BranchInviteViewController ()

@property (strong, nonatomic) NSArray *contactProviders;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *contactTable;

@end

@implementation BranchInviteViewController

+ (id)branchInviteViewController {
    NSString *branchInviteBundlePath = [[NSBundle mainBundle] pathForResource:@"BranchInvite" ofType:@"bundle"];
    NSBundle *branchInviteBundle = [NSBundle bundleWithPath:branchInviteBundlePath];

    BranchInviteViewController *branchInviteController = [[BranchInviteViewController alloc] initWithNibName:@"BranchInviteViewController" bundle:branchInviteBundle];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:branchInviteController];
    
    return navigationController;
}

- (void)loadView {
    [super loadView];

    // Don't want to be laid out under the nav bar.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
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
