//
//  CommomToolDefine.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/3.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "CommomToolDefine.h"
#import "NSDate+Extensiton.h"
#import "DataBaseSharedManager.h"
#import "DSDreamModel.h"

#import <CommonCrypto/CommonDigest.h>

static FMDatabase *_db;

#define MD5_STR_LEN16 16
#define MD5_STR_LEN32 32

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

+(BOOL)writeToPlistFile:(NSString *)fileName withValue:(NSString *)value key:(NSString *)key{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    //添加一项内容
    [data setObject:value forKey:key];
    
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filepath=[plistPath1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    //输入写入
    [data writeToFile:filepath atomically:YES];
    
    return YES;
}
+(void)initialize{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"dreams.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_dreams (id integer PRIMARY KEY, dream blob NOT NULL, idstr text NOT NULL);"];
}

+(NSDictionary *)readPlistFile:(NSString *)fileName{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    return data;
}

+(void)saveDataToDB:(NSArray *)dreams{
    for (DSDreamModel *dream in dreams){
        NSData *dreamData = [NSKeyedArchiver archivedDataWithRootObject:dream];
        [[[DataBaseSharedManager sharedManager] getDB] executeUpdateWithFormat:@"INSERT INTO t_dreams(dream, idstr) VALUES (%@, %@)", dreamData, dream.idStr];
    }
}

+(NSArray *)getDataFromDB{
    NSString *sql = nil;
    
    sql = @"SELECT * FROM t_dreams ORDER BY idstr DESC LIMIT 20;";
    
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *dreams = [NSMutableArray array];
    while (set.next) {
        NSData *dreamData = [set objectForColumnName:@"dream"];
        NSDictionary *dream = [NSKeyedUnarchiver unarchiveObjectWithData:dreamData];
        [dreams addObject:dream];
    }
    
    return dreams;
}

+(UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message ok:(void (^)(void))ok cancel:(void (^)(void))cancel{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        if (cancel) {
            cancel();
        }
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (ok) {
            ok();
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    return alert;
}

+(NSString *)MD5_32:(NSString *)str{
    const char *cStr = [str UTF8String];
    
    unsigned char result[MD5_STR_LEN32];
    
    CC_MD5(cStr, MD5_STR_LEN32, result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:MD5_STR_LEN32];
    
    for (int i = 0; i < MD5_STR_LEN32; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    
    return ret;
}

+(NSString *)MD5_16:(NSString *)str{
    const char *cStr = [str UTF8String];
    
    unsigned char result[MD5_STR_LEN16];
    
    CC_MD5(cStr, MD5_STR_LEN16, result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:MD5_STR_LEN16];
    
    for (int i = 0; i < MD5_STR_LEN16; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    
    return ret;
}

/**
 缩放
 */
+(UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+(void)addNoDataForView:(UIView *)view{
    UIView *cryView = [[UIView alloc] init];
    cryView.frame = CGRectMake(kScreenWidth/2 - 100, kScreenHeight / 2 - 100, 200, 139);
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 200, 139);
    imageView.image = [UIImage imageNamed:@"nodata_cry"];
    [cryView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 150, 180, 50);
    label.text = @"暂时没有数据";
    label.textAlignment = NSTextAlignmentCenter;
    [cryView addSubview:label];
    
    [view addSubview:cryView];
}
@end
