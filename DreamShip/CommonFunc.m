//
//  CommonFunc.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/21.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "CommonFunc.h"

@implementation CommonFunc

+(BOOL)isPhoneValid:(NSString *)phoneNum{
    NSPredicate *regexMB = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"];
    return [regexMB evaluateWithObject:phoneNum];
}
@end
