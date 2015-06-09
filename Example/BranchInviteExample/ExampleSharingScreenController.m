//
//  ExampleSharingScreenController.m
//  BranchInviteExample
//
//  Created by Graham Mueller on 5/11/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "ExampleSharingScreenController.h"
#import "ExampleSharingScreen.h"

@interface ExampleSharingScreenController ()

@end

@implementation ExampleSharingScreenController

- (void)configureWithSharingData:(NSDictionary *)sharingData {
    NSLog(@"ExampleSharingScreenController is configuring from sharing data");
    
    ExampleSharingScreen *sharingView = (ExampleSharingScreen *)self.view;
    [sharingView configureWithSharingData:sharingData];
}

@end
