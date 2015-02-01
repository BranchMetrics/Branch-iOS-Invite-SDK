//
//  ExampleContactCell.m
//  BranchInviteExample
//
//  Created by Graham Mueller on 2/1/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "ExampleContactCell.h"

@interface ExampleContactCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ExampleContactCell

- (void)configureCellWithContact:(BranchInviteContact *)contact selected:(BOOL)selected {
    self.nameLabel.text = contact.displayName;
    
    self.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (void)updateForSelection {
    self.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)updateForDeselection {
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end
