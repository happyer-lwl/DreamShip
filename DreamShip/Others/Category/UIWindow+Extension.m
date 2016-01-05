//
//  UIWindow+Extension.m
//  SinaWeibo
//
//  Created by 刘伟龙 on 15/11/29.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "MainTabbarController.h"
#import "NewFeatureViewController.h"

@implementation UIWindow (Extension)

-(void)switchRootViewController{
    // 切换窗口的根控制器
    NSString *versionKey = @"CFBundleVersion";
    // 获取上次版本号
    NSString *preVersion = [[NSUserDefaults standardUserDefaults] objectForKey:versionKey];
    // 获取当前软件版本号
    NSDictionary *info = [[NSBundle mainBundle]infoDictionary];
    NSString *currentVersion = [info objectForKey:versionKey];
    DBLog(@"%@", currentVersion);
    if ([currentVersion isEqualToString:preVersion]) {
        // 创建根控制器
        self.rootViewController = [[MainTabbarController alloc] init];
    }else{
        // 当前版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:versionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];    //立即存储
        
        // 进入新特性界面
        self.rootViewController = [[NewFeatureViewController alloc] init];
    }
}

@end
