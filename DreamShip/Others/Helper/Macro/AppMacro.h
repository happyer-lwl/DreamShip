//
//  AppMacro.h
//  MinFramework
//  app相关的宏定义
//
//  Created by ligh on 14-3-10.
//
//

#ifndef MinFramework_AppMacro_h
#define MinFramework_AppMacro_h

#import "AppDelegate.h"

//主域名
//#define _TEST_ 1

#ifdef _TEST_
    #define Host_Url @"http://localhost/"
#else
    //#define Host_Url @"http://www.runlwl.win/"
#define Host_Url @"http://121.42.38.84"

#endif

//APP版本
#define ApiVersion @"K10"

//NSUserDefaults
#define KUserDefaults [NSUserDefaults standardUserDefaults]

//判断设备是否是iphone4
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//判断设备是否是iphone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//判断设备是否是iphone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//AppDelegate
#define KAPP_DELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate
#define KAPP_WINDOW   (UIWindow *)[KAPP_DELEGATE window]

#endif
