//
//  BGWTransitCenter.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/8.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "BGWTransitCenter.h"

@implementation BGWTransitCenter

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"transitCenterId":@"id",
             @"transitCenterName":@"name"
             };
}


@end
