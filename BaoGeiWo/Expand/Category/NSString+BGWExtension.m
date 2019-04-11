//
//  NSString+BGWExtension.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/4.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "NSString+BGWExtension.h"
#import "NSDate+BGW.h"
#import <CommonCrypto/CommonDigest.h>



@implementation NSString (BGWExtension)



+ (NSString *)MD5:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}

- (NSString *)MD5 {
    return [NSString MD5:self];
}

+ (BOOL) isMobile1:(NSString *)mobileNumbel {
    if ([mobileNumbel length] == 0) {
        return NO;
    }
    NSString *regex = @"[1][34578]\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:mobileNumbel];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

+ (NSString *)getCurrentTimestamp {
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}

- (BOOL)isMobile {
    return [NSString isMobile1:self];
}


+ (BOOL) isMobile2:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    return NO;
}


- (CGFloat)heightWithWidth:(CGFloat)width fontSize:(CGFloat)fontSize{
    CGFloat height = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:BGWFont(fontSize)} context:nil].size.height;
    return (height == 0) ? 34 : height;
}

- (CGFloat)widthWithFontSize:(CGFloat)fontSize {
    
    CGSize size = [self sizeWithAttributes:@{NSFontAttributeName : BGWFont(fontSize)}];
    return size.width;
}


// dateStringFromtimeStampString
- (NSArray *)seperateDateWithtimeStap{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *dateString = [dateFormate stringFromDate:date];
    NSArray *seperateDate = [dateString componentsSeparatedByString:@"-"];
    return seperateDate;
}

//计算两个时间戳的时间差
+ (NSString *)compareTimeStamp:(NSString *)timeStamp1 timeStamp:(NSString *)timeStamp2 {

    NSTimeInterval timeinterval = (timeStamp2.doubleValue - timeStamp1.doubleValue);
    NSInteger timeInt = (NSInteger)timeinterval;
    
    NSString *timeString;
    NSInteger hour, minute, sec;
    if (timeInt < 60) { // < 1分
        sec = timeInt;
        timeString = [NSString stringWithFormat:@"00:%zd", sec];
    } else if (timeInt < 3600) { // < 1小时
        minute = timeInt/60;
        sec = timeInt%60;
        timeString = [NSString stringWithFormat:@"%zd:%zd", minute, sec];
    } else {
        hour = timeInt/60/60;
        minute = timeInt%3600/60;
        sec = timeInt%3600%60;
        timeString = [NSString stringWithFormat:@"%zd:%zd:%zd", hour, minute, sec];
    }
    
    return timeString;
}

- (NSString *)timeintervalWithOtherTimeStamp:(NSString *)timeStamp {
    return [NSString compareTimeStamp:self timeStamp:timeStamp];
}

- (BOOL)timeintervalSmallThanHourWithTimeStamp:(NSString *)timeStamp {
    NSTimeInterval timeinterval = (timeStamp.doubleValue - self.doubleValue);
    return !((long)timeinterval/3600);
}



- (NSString *)yearOfTimeStap {
    if ([self seperateDateWithtimeStap].count > 3) {
        return [self seperateDateWithtimeStap][0];
    }
    return nil;
}

- (NSString *)monthOfTimeStap {
    if ([self seperateDateWithtimeStap].count > 3) {
        return [self seperateDateWithtimeStap][1];
    }
    return nil;
}

- (NSString *)dateOfTimeStap {
    if ([self seperateDateWithtimeStap].count > 3) {
        return [self seperateDateWithtimeStap][2];
    }
    return nil;
}

- (NSString *)yymmddWithStringDivisionBy:(NSString *)division{
    
    NSArray *yymmdd = [self seperateDateWithtimeStap];
    if (yymmdd.count > 3) {
        return [NSString stringWithFormat:@"%@%@%@%@%@", yymmdd[0], division, yymmdd[1], division, yymmdd[2]];
    }
    return nil;
}

- (NSString *)yymmddhhmmString{
    
    NSArray *yymmdd = [self seperateDateWithtimeStap];
    if (yymmdd.count > 5) {
        return [NSString stringWithFormat:@"%@-%@-%@ %@:%@", yymmdd[0],yymmdd[1],yymmdd[2],yymmdd[3],yymmdd[4]];
    }
    return nil;
}

- (NSString *)yymmddString{
    NSArray *yymmdd = [self seperateDateWithtimeStap];
    if (yymmdd.count > 3) {
        return [NSString stringWithFormat:@"%@年%@月%@日", yymmdd[0], yymmdd[1], yymmdd[2]];
    }
    return nil;
}

- (NSString *)mm_ddString {
    NSArray *yymmdd = [self seperateDateWithtimeStap];
    if (yymmdd.count > 3) {
        return [NSString stringWithFormat:@"%@-%@", yymmdd[1], yymmdd[2]];
    }
    return nil;
}

- (NSString *)yy_mm_ddString {
    NSArray *yymmdd = [self seperateDateWithtimeStap];
    if (yymmdd.count > 3) {
        return [NSString stringWithFormat:@"%@-%@-%@", yymmdd[0], yymmdd[1], yymmdd[2]];
    }
    return nil;
}

- (NSString *)yyString{
    NSArray *yymmdd = [self seperateDateWithtimeStap];
    if (yymmdd.count > 3) {
        return [NSString stringWithFormat:@"%@年", yymmdd[0]];
    }
    return nil;
}

- (NSString *)yyOnYearsString {
    NSArray *yymmdd = [self seperateDateWithtimeStap];
    if (yymmdd.count > 3) {
        return [NSString stringWithFormat:@"%@", yymmdd[0]];
    }
    return nil;
}

- (NSString *)yy_mmString {
    NSArray *yymmdd = [self seperateDateWithtimeStap];
    if (yymmdd.count > 3) {
        return [NSString stringWithFormat:@"%@年%@月", yymmdd[0], yymmdd[1]];
    }
    return nil;
}

- (NSInteger)getTimeInterval {
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间_create_time 是返回的时间;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormate stringFromDate:date];
    
    NSDate *create = [fmt dateFromString:dateString];
    
    NSDateComponents *cmps = [[NSDate date] deltaHourFrom:create];
    
    return cmps.hour;
}


- (NSString *)createTime {
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间_create_time 是返回的时间;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormate stringFromDate:date];
    
    NSDate *create = [fmt dateFromString:dateString];
    
    //    if (create.isThisYear) { // 今年
    //        if (create.isToday) { // 今天
    //            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];
    //
    //            if (cmps.hour >= 1) { // 时间差距 >= 1小时
    //                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
    //            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
    //                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
    //            } else { // 1分钟 > 时间差距
    //                return @"刚刚";
    //            }
    //        } else { // 其他
    //            fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    //            return [fmt stringFromDate:create];
    //        }
    //    } else { // 非今年
    //        fmt.dateFormat = @"yyyy-MM-dd";
    //        return [fmt stringFromDate:create];
    //    }
    
    if (create.isThisYear) { // 今年
        if (create.isToday) { // 今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];
            
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前更新", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
                return @"刚刚更新";
            } else { // 1分钟 > 时间差距
                return @"刚刚更新";
            }
        } else { // 其他
            fmt.dateFormat = @"MM-dd";
            return [[fmt stringFromDate:create] stringByAppendingString:@"更新"];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM";
        return [[fmt stringFromDate:create] stringByAppendingString:@"更新"];
    }
    
}

- (NSString *)interactiveTime
{
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间_create_time 是返回的时间;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormate stringFromDate:date];
    
    NSDate *create = [fmt dateFromString:dateString];
    
    if (create.isThisYear) { // 今年
        if (create.isToday) { // 今天
            fmt.dateFormat = @"HH:mm";
            return [fmt stringFromDate:create];
        } else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:create];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:create] ;
    }
    
}

- (NSString *)interceptStringFrom:(NSString *)startString to:(NSString *)endString {
    
    NSRange startRange = [self rangeOfString:startString];
    NSRange endRange = [self rangeOfString:endString];
    if (startRange.length==0 || endRange.length==0) {
        return @"截取失败";
    }
    
    NSRange range = NSMakeRange(startRange.location+startRange.length, endRange.location-startRange.location-startRange.length);
    NSString *string = [self substringWithRange:range];
    
    return string;
}

- (NSDictionary *)jsonStringToDic {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return dic;
}

+ (NSString *)dicToJsonString:(NSDictionary *)dic {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonString;
}


@end
