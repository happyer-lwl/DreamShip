//
//  AppDelegate.h
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/17.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, RCIMUserInfoDataSource>

@property (strong, nonatomic) UIWindow *window;
-(void)connectServerWithToken;
@end

