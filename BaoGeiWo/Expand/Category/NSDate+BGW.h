//
//  NSDate+BGW.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/4.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (BGW)

/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;
- (NSDateComponents *)deltaHourFrom:(NSDate *)from;
/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;

@end
