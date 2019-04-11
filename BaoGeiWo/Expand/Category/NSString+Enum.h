//
//  NSString+Enum.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/11.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Enum)

- (AppUserType)appUserType;

- (BGWOrderDriverStatus)orderDriverStatus;
- (NSString *)orderDriverStatusCN;

+ (NSString *)orderMailingWay:(BGWOrderMailingWay)mailingWay;
- (BGWOrderMailingWay)orderMailingWay;
- (NSString *)orderMailingWayCN;


+ (NSString *)roleActionType:(BGWRoleActionType)type;
- (BGWRoleActionType)roleActionType;


+ (NSString *)roleActionStatus:(BGWRoleActionStatus)status;
- (BGWRoleActionStatus)roleActionStatus;


+ (NSString *)destType:(BGWDestinationType)type;
- (BGWDestinationType)destType;


+ (NSString *)orderStatus:(BGWOrderStatus)status;
- (BGWOrderStatus)orderStatus;

+ (NSString *)GTOrderType:(BGWGTOrderType)type;


+ (NSString *)msgType:(BGWMessageType)type;



@end
