//
//  GTOrderListModel.m
//  BaoGeiWo
//
//  Created by wb on 2018/6/21.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "GTOrderListModel.h"

@implementation GTOrderBaggageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"baggageId" : @"id",
             @"baggageCode" : @"baggageid"
             };
}

@end


@implementation GTOrderListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"orderId" : @"id",
             @"orderNo" : @"orderno",
             @"personName" : @"name",
             @"mobile" : @"mobile",
             @"baggageNumber" : @"num",
             @"baggageList" : @"orderBaggageList",
             @"takeTime" : @"taketime",
             @"sendTime" : @"sendtime",
             @"modifyTime" : @"modifytime",
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"baggageList":@"JSOrderBaggageModel"};
}

@end
