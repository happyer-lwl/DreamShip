//
//  AccountTool.h
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/17.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AccountModel;

@interface AccountTool : NSObject

+(void)saveAccount:(AccountModel *)model;
+(AccountModel *)account;

+(BOOL)saveUserInfo:(NSString *)phone pwd:(NSString*)pwd;
+(BOOL)userExisted:(NSString *)phone pwd:(NSString*)pwd;
+(BOOL)userPhoneExisted:(NSString *)phone pwd:(NSString *)pwd;
+(BOOL)userTableHasData;
@end
