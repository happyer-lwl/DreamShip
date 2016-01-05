//
//  AppDelegate.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/17.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "AppDelegate.h"
#import "AccountTool.h"
#import "AccountModel.h"
#import "UIWindow+Extension.h"
#import "registerOrLoginViewController.h"
#import "NewFeatureViewController.h"

#import <Bugly/CrashReporter.h>
#import <SMS_SDK/SMSSDK.h>
#import "DataBaseSharedManager.h"

#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

#define kAppBuglyID         @"900016290"
#define kEaseMobAppKey      @"noer#dreamship"
#define kEaseMobCertName    @"mob_p12"

static FMDatabase* db = nil;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 设置网络监听
    [self setNetStatusCheck];
    // 设置APNs推送
    [self setAPNs];

    // 注册腾讯Bugly监测
    [[CrashReporter sharedInstance] installWithAppId:kAppBuglyID];
    // 短信验证注册
    [SMSSDK registerApp: MOB_SMS_APPKEY withSecret:MOB_SMS_SECRET];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    AccountModel *model = [AccountTool account];
    if (model.userPhone.length) {
        [self.window switchRootViewController];
    }else{
        self.window.rootViewController = [[registerOrLoginViewController alloc] init];
    }
    //self.window.rootViewController = [[registerOrLoginViewController alloc] init];
    //self.window.rootViewController = [[NewFeatureViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    if (db == nil) {
        db = [[DataBaseSharedManager sharedManager] getDB];
    }
    
    return YES;
}

/**
 设置网络状态监听
 */
-(void)setNetStatusCheck{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    // 设置基准网址
    NSURL *url = [NSURL URLWithString:@"http://baidu.com"];
    
    // 初始化监听
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    NSOperationQueue *operationQueue = manager.operationQueue;

    // 监听结果回调
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DBLog(@"有网络");
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                DBLog(@"无网络");
                [operationQueue setSuspended:YES];
                break;
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    //
    [manager.reachabilityManager startMonitoring];
}


/**
    设置APNs推送
 */
-(void)setAPNs{
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 8.0) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil]];
    }
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@", deviceToken];
    DBLog(@"DeviceToken is: %@", deviceTokenStr);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    DBLog(@"Error -- %@", error);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
