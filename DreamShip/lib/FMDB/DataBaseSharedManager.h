//
//  DataBaseSharedManager.h
//  LoseYourTemper
//
//  Created by 刘伟龙 on 15/11/18.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DataBaseSharedManager : NSObject

+(DataBaseSharedManager*)sharedManager;

-(FMDatabase *)getDB;
-(BOOL)isTableExist: (NSString*)tableName dbName:(FMDatabase*)db;
-(void)initTable;
@end
