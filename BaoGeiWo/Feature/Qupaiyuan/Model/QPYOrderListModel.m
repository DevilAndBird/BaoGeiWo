//
//  QPYOrderListModel.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/8.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYOrderListModel.h"


@implementation QPYQRNumerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"QRNumber" : @"baggageid",
             @"QRNumberId" : @"id"
             };
}

@end




@implementation QPYOrderListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"orderId" : @"id",
             @"orderNumber" : @"orderno",
             @"personName" : @"cusname",
             @"baggageNumber" : @"num",
             @"QRNumbers" : @"orderBaggageList"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"QRNumbers":@"QPYQRNumerModel"};
}

@end
