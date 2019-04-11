//
//  UserRequest.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/4.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "UserRequest.h"

@implementation UserRequest

+ (void)userLoginWithAccount:(NSString *)account password:(NSString *)password success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSDictionary *parameters = @{@"mobile":account,
                                 @"password":password,
                                 @"source":@"app"};
    
    NSLog(@"parameters:%@", parameters);
    [BGWRequestManager POST:API_UserLogin parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSLog(@"%@", responseObject);
        if (success) {
            BGWUser *user = [BGWUser mj_objectWithKeyValues:responseObject];
            user.account = account;
            user.password = password;
            if ([user.userTypeString isEqualToString:@"SERVICE_CENTER"]) {
                user.userType = AppUserTypeServiceCenter;
            } else if ([user.userTypeString isEqualToString:@"DELIVERY_MAN"]) {
                user.userType = AppUserTypeDeliveryMan;
            } else if ([user.userTypeString isEqualToString:@"TRANSIT_CENTER"]) {
                user.userType = AppUserTypeTransitCenter;
                
                // 下边两个暂时没用
            } else if ([user.userTypeString isEqualToString:@"REGULAR_DRIVER"]) {
                user.userType = AppUserTypeRegularDriver;
            } else if ([user.userTypeString isEqualToString:@"AIRPORT_PICKER"]) {
                user.userType = AppUserTypeAirportPicker;
            }
            
            [user saveUserInfo];
            
            success(nil);
            
        }
        

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
//        [BGWUser removeUserInfoFromUserDefaults];
        if (failure) {
            failure(error);
        }

    }];
    
}

@end
