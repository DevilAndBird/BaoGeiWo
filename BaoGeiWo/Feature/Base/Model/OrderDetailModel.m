//
//  OrderDetailModel.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/17.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "OrderDetailModel.h"

#pragma mark- OrderDetailAddressModel
@implementation OrderDetailAddressModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"srcAddressMark" : @"scrlandmark",
             @"srcAddress" : @"srcaddress",
             @"destAddressMark" : @"destlandmark",
             @"destAddress" : @"destaddress"
             };
}
@end

#pragma mark- OrderDetailBaggageModel
@implementation OrderDetailBaggageModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"baggageQRCode" : @"baggageid",
             @"baggageId" : @"id",
             @"baggageImageUrl" : @"imgurl",
             };
}
@end

#pragma mark- OrderDetailNotesModel
@implementation OrderDetailNotesModel
@end

#pragma mark- OrderDetailFlightModel
@implementation OrderDetailFlightModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"flightNo" : @"flightno",
             };
}
@end

#pragma mark OrderDetailCusInfoModel
@implementation OrderDetailCusInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"IDNumber" : @"idno"};
}
@end

#pragma mark- OrderDetailPriceDetailModel
@implementation OrderDetailPriceDetailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"priceList" : @"lugBaseCostMap",
             @"safetyPrice" : @"prem",
             @"extraPrice" : @"extraMoney",
             @"totalPrice" : @"actualMoney",
             };
}
@end


#pragma mark- OrderDetailModel
@implementation OrderDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"orderId" : @"id",
             @"orderNumber" : @"orderno",
             @"orderStatus" : @"status",
             @"srcMailingWay" : @"mailingway",
             @"destMailingWay" : @"backway",
             @"srcPhone" : @"senderphone",
             @"destPhone" : @"receiverphone",
             @"srcName" : @"sendername",
             @"destName" : @"receivername",
             @"takeTime" : @"taketime",
             @"sendTime" : @"sendtime",
             @"baggageNumber" : @"num",
             @"roleType" : @"type",
             @"cusInfo" : @"cusInfo",
             @"orderAddress" : @"orderAddress",
             @"orderBaggages" : @"orderBaggageList",
             @"orderNotes" : @"orderNotesInfoList",
             @"priceDetail" : @"orderPriceDetatils",
             @"flightNo" : @"flightno",
             };
}


+ (NSDictionary *)mj_objectClassInArray {
    return @{@"orderBaggages" : @"OrderBaggageModel",
             @"orderNotes" : @"OrderDetailNotesModel",
             };
}

@end
