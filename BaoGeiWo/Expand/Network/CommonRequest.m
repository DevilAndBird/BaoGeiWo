//
//  CommonRequest.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/8.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "CommonRequest.h"

#import "BGWTransitCenter.h"
#import "DeliveryManModel.h"





@implementation CommonRequest



#pragma mark 获取集散中心/服务中心列表
+ (void)getCityNodeWithType:(BGWCityNodeType)type success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[BGWUser getCurrentUserId] forKey:@"userid"];
    NSArray *cityNodes = @[@"COUNTERCENTERLIST", @"TRANSITCENTERLIST"];
    [parameters setObject:cityNodes[type] forKey:@"queryCityNodeType"];
    
    [BGWRequestManager POST:API_GetCityNode parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        if (success) {

            if (type == BGWCityNodeTypeTransitCenter) {
                NSArray *arr = [BGWTransitCenter mj_objectArrayWithKeyValuesArray:responseObject[@"appTransitCenterList"]];
                success(arr);
            } else if (type == BGWCityNodeTypeCounterCenter) {
                NSArray *arr = [BGWTransitCenter mj_objectArrayWithKeyValuesArray:responseObject[@"appCounterCenterList"]];
                success(arr);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        if (failure) {
            failure(error);
        }
    }];
    
}


#pragma mark 获取取派员列表
+ (void)getDeliveryManList:(BGWDestinationType)destType success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[BGWUser currentUser].userRole.userRoleId forKey:@"destaddress"];
    [parameters setObject:[NSString destType:destType] forKey:@"desttype"];
    
    [BGWRequestManager POST:API_GetDeliveryManList parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSLog(@"%@", responseObject);
        if (success) {
            NSArray *array = [DeliveryManModel mj_objectArrayWithKeyValuesArray:responseObject];
            success(array);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


#pragma mark 取派员位置定位更新
+ (void)updateDeliveryManCurrentLocation:(NSString *)locationSrting {

    BGWUser *user = [BGWUser currentUser];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:locationSrting forKey:@"currentgps"];
    [parameters setObject:user.userId forKey:@"userid"];
    [parameters setObject:user.userName forKey:@"name"];
    [parameters setObject:user.mobile forKey:@"mobile"];
    [parameters setObject:user.userRole.provinceId forKey:@"srcprovid"];
    [parameters setObject:user.userRole.cityId forKey:@"srccityid"];

    
    [BGWRequestManager POST:API_UpdateDManCurrentGPS parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        BNSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
}




@end
