//
//  CurrentUserModel.m
//  BranchInviteExample
//
//  Created by Graham Mueller on 4/15/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "CurrentUserModel.h"
#import "Branch.h"

NSString * const USER_ID_KEY = @"UserIdKey";
NSString * const USER_IMAGE_URL_KEY = @"UserImageUrlKey";
NSString * const USER_FULLNAME_KEY = @"UserFullnameKey";
NSString * const USER_SHORT_NAME_KEY = @"UserShortNameKey";

@implementation CurrentUserModel

+ (CurrentUserModel *)sharedModel {
    static CurrentUserModel *sharedModel;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedModel = [[CurrentUserModel alloc] init];
    });
    
    return sharedModel;
}


#pragma mark - Properties

@synthesize userId = _userId, userImageUrl = _userImageUrl, userFullname = _userFullname, userShortName = _userShortName;

- (void)setUserId:(NSString *)userId {
    if (![userId isEqualToString:self.userId]) {
        _userId = userId;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:userId forKey:USER_ID_KEY];
        [defaults synchronize];

        [[Branch getInstance] logout];
        [[Branch getInstance] setIdentity:userId];
    }
}

- (NSString *)userId {
    if (!_userId) {
        _userId = [[NSUserDefaults standardUserDefaults] stringForKey:USER_ID_KEY];
    }
    
    return _userId;
}

- (void)setUserImageUrl:(NSString *)userImageUrl {
    if (![userImageUrl isEqualToString:self.userImageUrl]) {
        _userImageUrl = userImageUrl;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:userImageUrl forKey:USER_IMAGE_URL_KEY];
        [defaults synchronize];
    }
}

- (NSString *)userImageUrl {
    if (!_userImageUrl) {
        _userImageUrl = [[NSUserDefaults standardUserDefaults] stringForKey:USER_IMAGE_URL_KEY];
    }
    
    return _userImageUrl;
}

- (void)setUserFullname:(NSString *)userFullname {
    if (![userFullname isEqualToString:self.userFullname]) {
        _userFullname = userFullname;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:userFullname forKey:USER_FULLNAME_KEY];
        [defaults synchronize];
    }
}

- (NSString *)userFullname {
    if (!_userFullname) {
        _userFullname = [[NSUserDefaults standardUserDefaults] stringForKey:USER_FULLNAME_KEY];
    }
    
    return _userFullname;
}

- (void)setUserShortName:(NSString *)userShortName {
    if (![userShortName isEqualToString:self.userShortName]) {
        _userShortName = userShortName;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:userShortName forKey:USER_SHORT_NAME_KEY];
        [defaults synchronize];
    }
}

- (NSString *)userShortName {
    if (!_userShortName) {
        _userShortName = [[NSUserDefaults standardUserDefaults] stringForKey:USER_SHORT_NAME_KEY];
    }
    
    return _userShortName;
}

@end
