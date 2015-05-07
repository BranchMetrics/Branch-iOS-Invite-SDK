//
//  BranchInviteContactCell.m
//  BranchInvite
//
//  Created by Graham Mueller on 2/1/15.
//
//

#import "BranchInviteDefaultContactCell.h"
#import "BranchInviteBundleUtil.h"

@interface BranchInviteDefaultContactCell()

@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectionIcon;

@end

@implementation BranchInviteDefaultContactCell

- (void)configureCellWithContact:(BranchInviteContact *)contact selected:(BOOL)selected inviteItemColor:(UIColor *)inviteItemColor {
    self.contactNameLabel.text = contact.displayName;
    self.contactImageView.image = contact.displayImage ?: [BranchInviteBundleUtil imageNamed:@"user" type:@"png"];

    self.contactImageView.layer.masksToBounds = YES;
    self.contactImageView.layer.cornerRadius = self.contactImageView.frame.size.width / 2.0;

    self.selectionIcon.layer.masksToBounds = YES;
    self.selectionIcon.layer.cornerRadius = self.selectionIcon.frame.size.width / 2.0;
    self.selectionIcon.hidden = !selected;
    self.selectionIcon.backgroundColor = inviteItemColor;
}

- (void)updateForSelection {
    self.selectionIcon.hidden = NO;
}

- (void)updateForDeselection {
    self.selectionIcon.hidden = YES;
}

@end
