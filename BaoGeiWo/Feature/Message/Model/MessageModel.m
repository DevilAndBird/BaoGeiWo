//
//  MessageModel.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/25.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"msgId" : @"id",
             @"msgContent" : @"pushcontent",
             @"msgTime" : @"addtime",
             @"msgTheme" : @"theme",
             @"msgType" : @"type",
             @"isRead" : @"isread",
             };
}

@end
