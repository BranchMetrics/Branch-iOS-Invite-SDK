//
//  BranchInviteContactCell.h
//  BranchInvite
//
//  Created by Graham Mueller on 2/1/15.
//
//

#import "BranchInviteContact.h"

@protocol BranchInviteContactCell <NSObject>

- (void)configureCellWithContact:(BranchInviteContact *)contact selected:(BOOL)selected;
- (void)updateForSelection;
- (void)updateForDeselection;

@end
