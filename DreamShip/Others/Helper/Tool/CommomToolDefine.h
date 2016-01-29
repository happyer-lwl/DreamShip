//
//  CommomToolDefine.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/3.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommomToolDefine : NSObject

+(NSString *)currentDateStr;
+(NSDate *)dateFromString:(NSString *)dateStr;
+(NSString *)created_at:(NSString *)timeStr;

+(BOOL)writeToPlistFile:(NSString *)fileName withValue:(NSString *)value key:(NSString *)key;
+(NSDictionary *)readPlistFile:(NSString *)fileName;

+(void)saveDataToDB:(NSArray *)dreams;
+(NSArray *)getDataFromDB;

+(UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message ok:(void(^)(void))ok cancel:(void(^)(void))cancel;

+(NSString *)MD5_32:(NSString *)str;
+(NSString *)MD5_16:(NSString *)str;

+(UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size;
+(void)addNoDataForView:(UIView *)view;
@end
