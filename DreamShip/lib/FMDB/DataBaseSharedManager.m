//
//  DataBaseSharedManager.m
//  LoseYourTemper
//
//  Created by 刘伟龙 on 15/11/18.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "DataBaseSharedManager.h"

@implementation DataBaseSharedManager

static FMDatabase *db = nil;

+(FMDatabase*)sharedManager{
    static dispatch_once_t predicate;
    static DataBaseSharedManager* sharedManager;
    
    dispatch_once(&predicate, ^{
        sharedManager = [[self alloc]init];
        
        NSArray *docArrays = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        // 数据库文件夹路径
        NSString* dirPath = [docArrays objectAtIndex:0];
        // 数据库文件路径
        NSString* dbPath = [dirPath stringByAppendingPathComponent:@"dream.db"];
        NSLog(@"%@", dbPath);
        
        db = [FMDatabase databaseWithPath:dbPath];
        if (![db open]) {
            return;
        }else{
            if (![sharedManager isTableExist:@"users" dbName:db]) {
                [db executeUpdate:@"CREATE TABLE users (id integer PRIMARY KEY AUTOINCREMENT, phone text,pwd text,image text)"];
            }
        }
    });
    
    return sharedManager;
}

-(FMDatabase *)getDB{
    if (db) {
        return db;
    }else{
        return nil;
    }
}

-(BOOL)isTableExist:(NSString *)tableName dbName:(FMDatabase*)db{
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        
        NSInteger count = [rs intForColumn:@"count"];
        //NSLog(@"isTableOK %ld", count);
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

-(void)initTable{
    [db executeUpdate:@"CREATE TABLE users (id integer PRIMARY KEY AUTOINCREMENT, phone text,pwd text,image text)"];
}

@end
