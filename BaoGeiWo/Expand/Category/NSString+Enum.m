//
//  NSString+Enum.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/11.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "NSString+Enum.h"

@implementation NSString (Enum)


- (AppUserType)appUserType {
    NSArray *array = @[@"DELIVERY_MAN", @"TRANSIT_CENTER", @"SERVICE_CENTER", @"REGULAR_DRIVER", @"AIRPORT_PICKER"];
    return (AppUserType)[array indexOfObject:self];
}



- (BGWOrderDriverStatus)orderDriverStatus {
    NSArray *array = @[@"ARRIVING", @"ARRIVED"];
    return (BGWOrderDriverStatus)[array indexOfObject:self];
}
- (NSString *)orderDriverStatusCN {
    NSArray *array = @[@"即将到达", @"确认到达"];
    return array[[self orderDriverStatus]];
}


+ (NSString *)orderMailingWay:(BGWOrderMailingWay)mailingWay {
    NSArray *array = @[@"AIRPOSTCOUNTER", @"ONESELF", @"FRONTDESK", @"OTHER"];
    return array[mailingWay];
}
- (BGWOrderMailingWay)orderMailingWay {
    NSArray *array = @[@"AIRPOSTCOUNTER", @"ONESELF", @"FRONTDESK", @"OTHER"];
    if ([array containsObject:self]) {
        return (BGWOrderMailingWay)[array indexOfObject:self];
    } else {
        return BGWOrderMailingWayUnknown;
    }
}
- (NSString *)orderMailingWayCN {
    NSArray *array = @[@"柜台", @"本人", @"酒店前台", @"他人", @"未知"];
    return array[[self orderMailingWay]];
}


+ (NSString *)roleActionType:(BGWRoleActionType)type {
    NSArray *roleActionTypes = @[@"ROLE_HOTEL_TASK", @"ROLE_HOTEL_SEND", @"ROLE_TRANSIT_TASK", @"ROLE_TRANSIT_SEND", @"ROLE_AIRPORT_TASK", @"ROLE_AIRPORT_SEND", @"ROLE_ARRIVE_HOTEL", @"ROLE_ARRIVE_TRANSIT", @"ROLE_ARRIVE_AIRPORT"];
    return roleActionTypes[type];
}
- (BGWRoleActionType)roleActionType {
    NSArray *roleActionTypes = @[@"ROLE_HOTEL_TASK", @"ROLE_HOTEL_SEND", @"ROLE_TRANSIT_TASK", @"ROLE_TRANSIT_SEND", @"ROLE_AIRPORT_TASK", @"ROLE_AIRPORT_SEND", @"ROLE_ARRIVE_HOTEL", @"ROLE_ARRIVE_TRANSIT", @"ROLE_ARRIVE_AIRPORT"];
    return (BGWRoleActionType)[roleActionTypes indexOfObject:self];
}



+ (NSString *)roleActionStatus:(BGWRoleActionStatus)status {
    NSArray *roleActionStatus = @[@"UNFINISHED", @"ONGOING", @"FINISHED"];
    return roleActionStatus[status];
}
- (BGWRoleActionStatus)roleActionStatus {
    NSArray *roleActionStatus = @[@"UNFINISHED", @"ONGOING", @"FINISHED"];
    return (BGWRoleActionStatus)[roleActionStatus indexOfObject:self];
}



+ (NSString *)destType:(BGWDestinationType)type {
    NSArray *destTypes = @[@"SERVICECERTER", @"TRANSITCERTER", @"RESIDENCE", @"HOTEL", @"OTHER"];
    return destTypes[type];
}
- (BGWDestinationType)destType {
    NSArray *destTypes = @[@"SERVICECERTER", @"TRANSITCERTER", @"RESIDENCE", @"HOTEL", @"OTHER"];
    return (BGWDestinationType)[destTypes indexOfObject:self];
}



+ (NSString *)orderStatus:(BGWOrderStatus)status {
    NSArray *temp = @[@"WAITPAY", @"PREPAID", @"WAITPICK", @"TAKEGOOGSING", @"TAKEGOOGSOVER", @"WAITORDERRECEIVING", @"ORDERRECEIVINGOVER", @"WAITTRUCELOADING", @"TRUCELOADINGOVER", @"TRANSFEROVER", @"ARRIVEAIRPORT", @"RELEASEOVER", @"ALLOTDELIVERY", @"DELIVERYING", @"DELIVERYOVER", @"WAITINGUNLOAD", @"UNLOAD", @"TROUBLE_DEAL",];
    return temp[status];
}
- (BGWOrderStatus)orderStatus {
    NSArray *temp = @[@"WAITPAY", @"PREPAID", @"WAITPICK", @"TAKEGOOGSING", @"TAKEGOOGSOVER", @"WAITORDERRECEIVING", @"ORDERRECEIVINGOVER", @"WAITTRUCELOADING", @"TRUCELOADINGOVER", @"TRANSFEROVER", @"ARRIVEAIRPORT", @"RELEASEOVER", @"ALLOTDELIVERY", @"DELIVERYING", @"DELIVERYOVER", @"WAITINGUNLOAD", @"UNLOAD", @"TROUBLE_DEAL",];
    return (BGWOrderStatus)[temp indexOfObject:self];
}


+ (NSString *)GTOrderType:(BGWGTOrderType)type {
    NSArray *temp = @[@"WAITPAY", @"TAKING", @"SENDING", @"HOSTING", @"FINISH"];
    return temp[type];
}


+ (NSString *)msgType:(BGWMessageType)type {
    NSArray *temp = @[@"SYSTEMMSG", @"ORDERMSG"];
    return temp[type];
}


@end
