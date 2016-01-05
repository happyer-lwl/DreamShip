//
//  NSDictionary+Extension.h
//  SinaWeibo
//
//  Created by 刘伟龙 on 15/11/30.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)

+(NSDictionary *)nullDic:(NSDictionary *)myDic;

+(NSArray *)nullArr:(NSArray *)myArr;

+(NSString *)stringToString:(NSString *)string;

+(NSString *)nullToString;

+(id)changeType:(id)myObj;
@end
