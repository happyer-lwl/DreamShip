//
//  NSDate+Extensiton.m
//  SinaWeibo
//
//  Created by 刘伟龙 on 15/12/1.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "NSDate+Extensiton.h"

@implementation NSDate (Extensiton)

/**
 *  判断是不是今年
 *
 *  @return isThisYear
 */
-(BOOL)isThisYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *curComponents = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSDateComponents *selfComponents = [calendar components:NSCalendarUnitYear fromDate:self];
    
    return (curComponents.year == selfComponents.year);
}

/**
 *  是不是昨天
 *
 *  @return 
 */
-(BOOL)isYestoday{
    // 格式
    NSDateFormatter *fmt    = [[NSDateFormatter alloc]init];
    fmt.dateFormat          = @"yyyy-MM-dd";
    
    // 日期字符串
    NSString *todayString   = [fmt stringFromDate:[NSDate date]];
    NSString *selfString    = [fmt stringFromDate:self];
    
    // 日期
    NSDate *nowDate         = [fmt dateFromString:todayString];
    NSDate *selfDate        = [fmt dateFromString:selfString];
    
    // 日历
    NSCalendar *calendar    = [NSCalendar currentCalendar];
    
    // 比较内容
    NSCalendarUnit unit     = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    // 比较结果
    NSDateComponents *cmp   = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return (cmp.year == 0) && (cmp.month == 0) && (cmp.day == 1);
}

/**
 *  判断是不是今天
 *
 *  @return 
 */
-(BOOL)isToday{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    
    return ([nowString isEqualToString:selfString]);
}
@end
