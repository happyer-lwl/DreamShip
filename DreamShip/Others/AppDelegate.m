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
#import "MainTabbarController.h"

#import <Bugly/CrashReporter.h>
#import <SMS_SDK/SMSSDK.h>
#import "DataBaseSharedManager.h"

#import "AFNetworking.h"
#import "HttpTool.h"
#import "MJExtension.h"

#import "UIKit+AFNetworking.h"

#import "DSUser.h"

#define kAppBuglyID         @"900016290"

#define kShareSDKKey        @"fe467950896c"
#define kShareSDKSecret     @"07ced222bff568a36d51813ae2ec7681"

static FMDatabase* db = nil;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    // 设置网络监听
    //[self setNetStatusCheck];
    // 设置IMSDK
    [[RCIM sharedRCIM] initWithAppKey:kRongCloudAppKey];
    // 设置APNs推送
    [self setAPNs];
    
    // 注册腾讯Bugly监测
    [[CrashReporter sharedInstance] installWithAppId:kAppBuglyID];
    // 短信验证注册
    [SMSSDK registerApp: MOB_SMS_APPKEY withSecret:MOB_SMS_SECRET];
    
    // shareSDK
    //[ShareSDK registerApp:kShareSDKKey];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    AccountModel *model = [AccountTool account];
    if (model.userPwd.length) {
        [self.window switchRootViewController];
    }else{
        self.window.rootViewController = [[registerOrLoginViewController alloc] init];
    }
    
    [self.window makeKeyAndVisible];
    
    if (db == nil) {
        db = [[DataBaseSharedManager sharedManager] getDB];
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    
    return YES;
}

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
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

    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    DBLog(@"DeviceToken is: %@", token);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    DBLog(@"Error -- %@", error);
}

-(void)didReceiveMessageNotification:(NSNotification *)notification{
    NSInteger iconBadgeNum = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = iconBadgeNum;

    [kNotificationCenter postNotificationName:kNotificationUpdataBadge object:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents]; // 让后台可以处理多媒体的事件
//    NSLog(@"%s",__FUNCTION__);
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setActive:YES error:nil];
//    [session setCategory:AVAudioSessionCategoryPlayback error:nil]; //后台播放
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //[AudioController playMusic];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //[g_pIMSDK applicationWillEnterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{

    [self getUserWithUserID:userId finish:^(DSUser *user) {
        RCUserInfo *userInfo = [[RCUserInfo alloc] init];
        
        userInfo.userId = userId;
        userInfo.name = user.userRealName;
        userInfo.portraitUri = user.image;
        
        completion(userInfo);
    }];
}

-(void)connectServerWithToken{
    NSString *token = [KUserDefaults objectForKey:@"RongCloudToken"];
    
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        DBLog(@"Sucessfull with userId: %@.", userId);
        
        [RCIM sharedRCIM].userInfoDataSource = self;
    } error:^(RCConnectErrorCode status) {
        DBLog(@"Error: %ld", (long)status);
    } tokenIncorrect:^{
        DBLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
    }];
}

-(DSUser *)getUserWithUserID:(NSString *)userID finish:(void(^)(DSUser *user))finish{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"users";
    params[@"api_type"] = @"getUserWithID";
    params[@"user_id"] = userID;
    
    DSUser *user = [[DSUser alloc] init];
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {
        NSString *result = [json[@"result"] stringValue];
        NSDictionary *dataDict = json[@"data"];
        
        DBLog(@"%@", json);
        if ([result isEqualToString:@"200"]) {//登录
            
            user.name = dataDict[@"name"];
            user.userRealName = dataDict[@"userRealName"];
            user.image = dataDict[@"image"];
            user.userMail = dataDict[@"userMail"];
            user.user_id = dataDict[@"user_id"];
            user.userAddr = dataDict[@"userAddr"];
            user.userSex = dataDict[@"sex"];
            user.userWords = dataDict[@"userWords"];
            
            finish(user);
            
        }else if ([result isEqualToString:@"201"]){
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"当前用户不存在11，请确认!"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误!"];
    }];
    
    return user;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([[url scheme] isEqualToString:@"dreamship"]) {
        [application setApplicationIconBadgeNumber:10];
        return YES;
    }else{
        return NO;
    }
}

@end
