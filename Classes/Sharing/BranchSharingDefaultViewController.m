//
//  BranchSharingViewController.m
//  BranchInvite
//
//  Created by Graham Mueller on 5/7/15.
//
//

#import "BranchSharingDefaultViewController.h"

@interface BranchSharingDefaultViewController ()

@property (strong, nonatomic) UIView <BranchSharingView> *branchSharingView;

@end

@implementation BranchSharingDefaultViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.branchSharingView];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.branchSharingView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.branchSharingView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.branchSharingView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.branchSharingView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    self.branchSharingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.branchSharingView.doneButton addTarget:self action:@selector(donePressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addConstraints:@[ topConstraint, rightConstraint, bottomConstraint, leftConstraint ]];
}

- (void)configureWithSharingData:(NSDictionary *)sharingData {
    [self.branchSharingView configureWithSharingData:sharingData];
}

#pragma mark - Interaction methods
- (void)donePressed {
    [self.delegate branchSharingControllerCompleted];
}

@end
