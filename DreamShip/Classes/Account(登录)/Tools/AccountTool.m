//
//  AccountTool.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/17.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "AccountTool.h"
#import "AccountModel.h"
#import "DataBaseSharedManager.h"

#import "HttpTool.h"

#define kAccountFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archiver"]

@implementation AccountTool

+(void)saveAccount:(AccountModel *)model{
    [NSKeyedArchiver archiveRootObject:model toFile:kAccountFilePath];
}

+(AccountModel *)account{
    AccountModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:kAccountFilePath];
    
    return model;
}

+(BOOL)saveUserInfo:(NSString *)phone pwd:(NSString *)pwd{

    FMDatabase *db = [[DataBaseSharedManager sharedManager] getDB];
    
    return [db executeUpdate:@"INSERT INTO users (phone, pwd) VALUES(?, ?)", phone, pwd];
}

+(BOOL)userPhoneExisted:(NSString *)phone pwd:(NSString *)pwd{
    FMDatabase *db = [[DataBaseSharedManager sharedManager] getDB];
    
    NSString *queryString = [NSString stringWithFormat:@"SELECT * from users where phone='%@'", phone];
    FMResultSet* rs = [db executeQuery:queryString];
    if ([rs next]) {
        return YES;
    }else{
        return NO;
    }
}

+(BOOL)userExisted:(NSString *)phone pwd:(NSString *)pwd{
    FMDatabase *db = [[DataBaseSharedManager sharedManager] getDB];
    
    NSString *queryString = [NSString stringWithFormat:@"SELECT * from users where phone='%@'and pwd='%@'", phone, pwd];
    FMResultSet* rs = [db executeQuery:queryString];
    if ([rs next]) {
        return YES;
    }else{
        return NO;
    }
}

+(BOOL)userTableHasData{
    FMDatabase *db = [[DataBaseSharedManager sharedManager] getDB];
    
    NSString *queryString = [NSString stringWithFormat:@"SELECT * from users"];
    FMResultSet* rs = [db executeQuery:queryString];
    if ([rs next]) {
        return YES;
    }else{
        return NO;
    }

}
@end
