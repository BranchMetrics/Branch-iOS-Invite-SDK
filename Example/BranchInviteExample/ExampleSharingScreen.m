//
//  ExampleSharingScreen.m
//  BranchInviteExample
//
//  Created by Graham Mueller on 5/11/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "ExampleSharingScreen.h"
#import "BranchSharing.h"

@interface ExampleSharingScreen ()

@property (weak, nonatomic) IBOutlet UILabel *shareTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareImageUrlLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shareImageView;

@end

@implementation ExampleSharingScreen

- (void)configureWithSharingData:(NSDictionary *)sharingData {
    NSString *shareText = sharingData[BRANCH_SHARING_SHARE_TEXT];
    NSString *shareImageUrl = sharingData[BRANCH_SHARING_SHARE_IMAGE];
    
    self.shareTextLabel.text = shareText;
    self.shareImageUrlLabel.text = shareImageUrl;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageUrl]];
        UIImage *image = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.shareImageView.image = image;
        });
    });
}

@end
