//
//  CurrentUserModel.h
//  BranchInviteExample
//
//  Created by Graham Mueller on 4/15/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentUserModel : NSObject

+ (CurrentUserModel *)sharedModel;

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userImageUrl;
@property (strong, nonatomic) NSString *userFullname;
@property (strong, nonatomic) NSString *userShortName;

@end
