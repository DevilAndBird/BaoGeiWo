//
//  BGWUser.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/4.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "BGWUser.h"



#define kUserKey @"user"


@implementation BGWUserRole

MJExtensionCodingImplementation


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"userRoleId" : @"id",
             @"userRoleName" : @"roleName",
             @"provinceId" : @"provid",
             @"cityId" : @"cityid",
             @"provinceName" : @"provname",
             @"cityName" : @"cityname",
             @"coordinate" : @"gps",
             };
}

@end




static BGWUser *_user = nil;


@implementation BGWUser


MJExtensionCodingImplementation


+ (instancetype)currentUser {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [self readLocalUser];
    });
    
//    if (user == nil) {
//        user = [self readLocalUser];
//    }
    return _user;
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"userId" : @"roleid",
             @"userName" : @"name",
             @"mobile" : @"mobile",
             @"userTypeString" : @"type",
             @"userRole" : @"appuserrole",
             @"token" : @"sign",
             };
}


- (void)saveUserInfo {
    _user = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableData *data_M = [[NSMutableData alloc]initWithCapacity:0];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data_M];
        [archiver encodeObject:self forKey:kUserKey];
        [archiver finishEncoding];
        [[NSUserDefaults standardUserDefaults]setObject:data_M forKey:kUserKey];
    });
}


+ (BGWUser *)readLocalUser {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableData *data_M = [userDefault valueForKey:kUserKey];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data_M];
    BGWUser *localUser = [unarchiver decodeObjectForKey:kUserKey];
    [unarchiver finishDecoding];
    
//    if (!localUser) {
//        localUser = [[BGWUser alloc] init];
//    }
    return localUser;
}


+ (void)removeUserInfoFromUserDefaults {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([userDefault valueForKey:kUserKey]) {
            _user = nil;
            [userDefault removeObjectForKey:kUserKey];
        }
    });
}


+ (NSString *)getCurrentUserId {
    return _user.userId;
}

+ (NSString *)getCurremtUserName {
    return _user.userName;
}

+ (AppUserType)getCurremtUserType {
    return [_user.userTypeString appUserType];
}




@end
