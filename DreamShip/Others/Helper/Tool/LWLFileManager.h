//
//  LWLFileManager.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/15.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWLFileManager : NSObject

+(float)fileSizeAtPath:(NSString *)path;
+(float)folderSizeAthPath:(NSString *)path;
+(void)clearCache:(NSString *)path;

@end
