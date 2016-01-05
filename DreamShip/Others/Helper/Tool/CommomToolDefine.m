//
//  CommomToolDefine.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/3.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "CommomToolDefine.h"
#import "NSDate+Extensiton.h"

@implementation CommomToolDefine

+(NSString *)currentDateStr{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    
    [formater setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    [formater setDateStyle:(NSDateFormatterMediumStyle)];
    [formater setTimeStyle:(NSDateFormatterShortStyle)];
    [formater setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString *dateStr = [formater stringFromDate:[NSDate date]];
    
    //NSString *dateStr = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    return dateStr;
}

+(NSDate *)dateFromString:(NSString *)dateStr{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    
    [formater setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    [formater setDateStyle:(NSDateFormatterMediumStyle)];
    [formater setTimeStyle:(NSDateFormatterShortStyle)];
    [formater setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *date = [formater dateFromString:dateStr];
    return date;
}

/**
 1 今年
 1> 今天
 * 1分钟内: 刚刚
 * 1-59:   xx分钟前
 * 大于60:  xx小时前
 2> 昨天
 * 昨天 xx:xx
 3> 其他
 * xx-xx xx:xx
 2 非今年
 1> xxxx-xx-xx xx:xx
 */
+(NSString*)created_at:(NSString *)timeStr{
    NSString *createTimeString = @"";
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //    // 如果是真机调试，转换这种欧美时间，需要设置locale
    //    //fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];  // 中国
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];  // 欧美

    // dateFormat   YYYY-MM-dd HH:mm:ss
    // 设置日期格式 声明字符串每个数字和单词的含义
    fmt.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    // 微博创建日期
    NSDate *createDate = [fmt dateFromString:timeStr];
    
    if ([createDate isThisYear]) { // 是今年
        if ([createDate isToday]) { // 今天
            double totalSecs = fabs([createDate timeIntervalSinceNow]);
            if (totalSecs < 60) { // 小于1分钟，刚刚
                createTimeString = @"刚刚";
            }else if ((60 <= totalSecs) && (totalSecs < 3600)){ // 1-60分
                int mins = totalSecs / 60;
                createTimeString = [NSString stringWithFormat:@"%d分钟前", mins];
            }else{ // 小时
                int hours = totalSecs / 3600;
                createTimeString = [NSString stringWithFormat:@"%d小时前", hours];
            }
        }else if ([createDate isYestoday]){ // 昨天
            fmt.dateFormat = @"HH:mm";
            createTimeString = [fmt stringFromDate:createDate];
        }else{ // 其他日期
            fmt.dateFormat = @"MM-dd HH:mm";
            createTimeString = [fmt stringFromDate:createDate];
        }
        
    }else{// 不是今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        createTimeString = [fmt stringFromDate:createDate];
    }
    
    return createTimeString;
}

@end
