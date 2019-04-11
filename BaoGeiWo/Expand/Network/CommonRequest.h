//
//  CommonRequest.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/8.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailureBlock)(id error);


@interface CommonRequest : NSObject




+ (void)getCityNodeWithType:(BGWCityNodeType)type success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getDeliveryManList:(BGWDestinationType)destType success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)updateDeliveryManCurrentLocation:(NSString *)locationSrting;



@end
