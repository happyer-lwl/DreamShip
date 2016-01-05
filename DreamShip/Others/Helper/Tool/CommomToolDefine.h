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

@end
