//
//  BranchSharingDefaultView.m
//  BranchInvite
//
//  Created by Graham Mueller on 5/5/15.
//
//

#import "BranchSharingDefaultView.h"

@interface BranchSharingDefaultView ()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation BranchSharingDefaultView

- (void)configureWithSharingData:(NSDictionary *)sharingData {
    if ([self.styleDelegate respondsToSelector:@selector(branchSharingViewBackgroundColor)]) {
        self.backgroundColor = [self.styleDelegate branchSharingViewBackgroundColor];
    }
    
    if ([self.styleDelegate respondsToSelector:@selector(branchSharingViewForegroundColor)]) {
        self.contentTextLabel.textColor = [self.styleDelegate branchSharingViewForegroundColor];
    }
    
    if ([self.styleDelegate respondsToSelector:@selector(branchSharingViewFont)]) {
        self.contentTextLabel.font = [self.styleDelegate branchSharingViewFont];
    }

    self.contentTextLabel.text = sharingData[BRANCH_SHARING_SHARE_TEXT];
    
    NSString *imageUrl = sharingData[BRANCH_SHARING_SHARE_IMAGE];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:imgData];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            self.contentImageView.image = image;
        });
    });
}

@end
