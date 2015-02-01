//
//  MysteryIncInviteController.m
//  BranchInviteExample
//
//  Created by Graham Mueller on 2/1/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "MysteryIncInviteController.h"

@interface MysteryIncInviteController ()

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSArray *charactersToInvite;
@property (weak, nonatomic) id <MysteryIncInviteControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *charactersLabel;

@end

@implementation MysteryIncInviteController

+ (MysteryIncInviteController *)mysteryIncInviteControllerWithUrl:(NSString *)url delegate:(id <MysteryIncInviteControllerDelegate>)delegate charactersToInvite:(NSArray *)charactersToInvite {
    MysteryIncInviteController *mysteryIncInviteController = [[MysteryIncInviteController alloc] initWithNibName:@"MysteryIncInviteController" bundle:[NSBundle mainBundle]];
    mysteryIncInviteController.url = url;
    mysteryIncInviteController.delegate = delegate;
    mysteryIncInviteController.charactersToInvite = charactersToInvite;
    
    return mysteryIncInviteController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.charactersLabel.text = [NSString stringWithFormat:@"We need your help, %@. Check out this url %@", [self.charactersToInvite componentsJoinedByString:@","], self.url];
}

#pragma mark - Interaction methods
- (IBAction)sendInvitePressed:(id)sender {
    [self.delegate inviteSent];
}

- (IBAction)cancelPressed:(id)sender {
    [self.delegate inviteCanceled];
}

@end
