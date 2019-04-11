//
//  DeliveryManModel.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/17.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "DeliveryManModel.h"

@implementation DeliveryManModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"dmId" : @"userid",
             @"dmName" : @"drivername",
             @"dmPhone" : @"drivermobile",
             @"dmPlateNumber" : @"platenumber",
             @"dmTravelStatus" : @"travelstatus",
             @"dmTravelStatusDesc" : @"travelstatusDesc",
             };
}


@end
