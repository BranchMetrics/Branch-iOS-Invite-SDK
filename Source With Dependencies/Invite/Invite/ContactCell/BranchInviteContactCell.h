//
//  BranchInviteContactCell.h
//  BranchInvite
//
//  Created by Graham Mueller on 2/1/15.
//
//
//  BranchInviteContactCell is the protocol utilized for
//  rows within the BranchInviteViewController. The configure
//  method is called for each cell in tableView:cellForRowAtIndexPath:
//  The updateForSelection and updateForDeselection methods
//  are called whenever a row is selected or deselected.
//

#import "BranchInviteContact.h"

@protocol BranchInviteContactCell <NSObject>

- (void)configureCellWithContact:(BranchInviteContact *)contact selected:(BOOL)selected inviteItemColor:(UIColor *)inviteItemColor;
- (void)updateForSelection;
- (void)updateForDeselection;

@end
