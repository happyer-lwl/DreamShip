//
//  LWLFileManager.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/15.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "LWLFileManager.h"
#import "SDWebImageManager.h"

@implementation LWLFileManager

+(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:path]) {
        
        long long size = [[manager attributesOfItemAtPath:path error:nil] fileSize];
        return size / 1024.0 / 1024.0;
    }
    
    return 0;
}

+(float)folderSizeAthPath:(NSString *)path{
    NSFileManager *manager = [NSFileManager defaultManager];
    float folderSize;
    if ([manager fileExistsAtPath:path]) {
        NSArray *childerFiles = [manager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            folderSize += [LWLFileManager fileSizeAtPath:absolutePath];
        }
        
        return folderSize;
    }
    
    return 0;
}

+(void)clearCache:(NSString *)path{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        NSArray *childerFiles = [manager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            [manager removeItemAtPath:absolutePath error:nil];
        }
    }
    
    [[SDImageCache sharedImageCache] clearDisk];
}

@end
