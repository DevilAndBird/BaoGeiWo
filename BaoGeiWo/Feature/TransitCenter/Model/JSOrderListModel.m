//
//  JSOrderListModel.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/28.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "JSOrderListModel.h"



@implementation JSOrderBaggageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"baggageId" : @"id",
             @"baggageCode" : @"baggageid"
             };
}

@end




@implementation JSOrderListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"orderId" : @"id",
             @"orderNumber" : @"orderno",
             @"personName" : @"name",
             @"baggageNumber" : @"num",
             @"baggageList" : @"orderBaggageList",
             @"roleType" : @"roletype",
             @"arrivedTime" : @"arrivedtime",
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"baggageList":@"JSOrderBaggageModel"};
}

@end
