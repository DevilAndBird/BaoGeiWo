//
//  QPYOrderTaskListModel.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/11.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYOrderTaskListModel.h"


@implementation OrderTaskBaggageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"baggageQRNumber" : @"baggageid",
             @"baggageId" : @"id",
             @"baggageImageUrl" : @"imgurl",
             };
}

@end


@implementation OrderTaskNextBindAction

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"arrivedTime" : @"arrivedtime",
             @"srcAddress" : @"srcaddrname",
             @"srcAddressDesc" : @"srcaddrdesc",
             @"destAddressId" : @"destaddress",
             @"destAddressType" : @"desttype",
             @"destAddress" : @"destaddrname",
             @"destAddressDesc" : @"destaddrdesc",
            };
}

@end


@implementation OrderTaskDestAddressCoordinate

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"latitudeStr" : @"lat",
             @"longitudeStr" : @"lng",
             };
}
@end


@implementation QPYOrderTaskListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"orderId" : @"id",
             @"orderNumber" : @"orderno",
             @"orderStatus" : @"status",
             @"srcMailingWay" : @"mailingway",
             @"destMailingWay" : @"backway",
             @"srcPhone" : @"senderphone",
             @"destPhone" : @"receiverphone",
             @"takeTime" : @"taketime",
             @"sendTime" : @"sendtime",
             @"currentTime" : @"currentstamp",
             @"arrivedTime" : @"arrivedtime",
             @"destAddressId" : @"destaddress",
             @"destAddressType" : @"desttype",
             @"destAddress" : @"destaddrname",
             @"destAddressDesc" : @"destaddrdesc",
             @"baggageNumber" : @"num",
             @"travelStatus" : @"travelstatus",
             @"orderBaggageArray" : @"orderBaggageList",
             @"roleType" : @"roletype",
             @"isFinish" : @"isfinish",
             @"nextBindAction" : @"nextBindAction",
             @"addressCoordinate" : @"destaddressGps",
             @"isArrived" : @"isarrived",
             @"isTake" : @"istake",
             @"isToday" : @"isnight",
             };
    
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"orderBaggageArray" : @"OrderTaskBaggageModel"};
}


- (void)realTaskType {
    
    switch ([self.isFinish roleActionStatus]) {
        case BGWRoleActionStatusNotBegin:
            switch ([self.roleType roleActionType]) {
                case BGWRoleActionTypeHotelTask:
                case BGWRoleActionTypeTransitTask:
                case BGWRoleActionTypeAirportTask:
                    self.taskType = BGWOrderTaskTypePrepareReceive;
                    break;
                case BGWRoleActionTypeHotelSend:
                case BGWRoleActionTypeTransitSend:
                case BGWRoleActionTypeAirportSend:
                    self.taskType = BGWOrderTaskTypePrepareSend;
                    break;
                default:
                    self.taskType = BGWOrderTaskTypeOther;
                    break;
            }
            break;
        case BGWRoleActionStatusOnGoing:
            self.taskType = BGWOrderTaskTypeOnGoing;
            break;
        case BGWRoleActionStatusFinished:
            switch ([self.roleType roleActionType]) {
                case BGWRoleActionTypeHotelSend:
                case BGWRoleActionTypeTransitSend:
                case BGWRoleActionTypeAirportSend:
                    self.taskType = BGWOrderTaskTypeFinished;
                    break;
                default:
                    self.taskType = BGWOrderTaskTypeOther;
                    break;
            }
            break;
        default:
            self.taskType = BGWOrderTaskTypeOther;
            break;
    }
    
}

@end


@implementation QPYOrderTaskGroupModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"taskGroup" : @"TaskList"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"taskGroup" : @"QPYOrderTaskListModel"};
}

@end


