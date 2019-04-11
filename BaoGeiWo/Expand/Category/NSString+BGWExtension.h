//
//  NSString+BGWExtension.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/4.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BGWExtension)


+ (NSString *)MD5:(NSString *)str;
- (NSString *)MD5;




//时间戳的年份
@property (nonatomic, strong, readonly) NSString *yearOfTimeStap;
//时间戳的月份
@property (nonatomic, strong, readonly) NSString *monthOfTimeStap;
//时间戳的日期
@property (nonatomic, strong, readonly) NSString *dateOfTimeStap;

//获取时间戳 当前时间
+ (NSString *)getCurrentTimestamp;

//将时间戳转换为时间数组
- (NSArray *)seperateDateWithtimeStap;

//计算两个时间戳的间隔 单位为小时
+ (NSString *)compareTimeStamp:(NSString *)timeStamp1 timeStamp:(NSString *)timeStamp2;

//与另一个时间戳比较时间间隔 单位为小时
- (NSString *)timeintervalWithOtherTimeStamp:(NSString *)timeStamp;

- (BOOL)timeintervalSmallThanHourWithTimeStamp:(NSString *)timeStamp;

//将时间戳转换为指定分隔符年月日格式
- (NSString *)yymmddWithStringDivisionBy:(NSString *)division;


//将时间戳转换为 yyyy年mm月dd日
- (NSString *)yymmddhhmmString;
- (NSString *)yymmddString;
- (NSString *)yy_mm_ddString;
- (NSString *)yy_mmString;
- (NSString *)mm_ddString;

//将时间戳转换为 yyyy年
- (NSString *)yyString;

//将时间戳转换为 yyyy
- (NSString *)yyOnYearsString;



//mm-dd hh:mm
- (NSString *)interactiveTime;






@end
