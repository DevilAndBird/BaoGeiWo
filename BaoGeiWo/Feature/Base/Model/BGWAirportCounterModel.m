//
//  BGWAirportCounterModel.m
//  BaoGeiWo
//
//  Created by wb on 2018/10/26.
//  Copyright © 2018 qyqs. All rights reserved.
//

#import "BGWAirportCounterModel.h"

@implementation BGWAirportCounterModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"counterId" : @"id",
             @"counterName" : @"servicecentername",
             @"counterRemark" : @"remark",
             @"counterCoordinate" : @"gps",
             };
}

@end
