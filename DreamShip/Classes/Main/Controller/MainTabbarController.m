//
//  MainTabbarController.m
//  SinaWeibo
//
//  Created by 刘伟龙 on 15/11/27.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "MainTabbarController.h"
#import "MainNavigationController.h"

#import "HomeViewController.h"
#import "DreamNaviVC.h"

#import "DiscoverViewController.h"
#import "ProfileViewController.h"

#import <RongIMKit/RongIMKit.h>

@interface MainTabbarController ()

@end

@implementation MainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [MBProgressHUD hideHUD];
    
    HomeViewController *home = [[HomeViewController alloc] init];
    [self addChildVc:home title:@"梦 吧" image:@"tabbar_home" selectImage:@"tabbar_home_selected"];
    
    DreamNaviVC *commend = [[DreamNaviVC alloc] init];
    [self addChildVc:commend title:@"梦 向" image:@"tabbar_discover" selectImage:@"tabbar_discover_selected"];
    
    DiscoverViewController *discover = [[DiscoverViewController alloc] init];
    [self addChildVc:discover title:@"梦 信" image:@"tabbar_message_center" selectImage:@"tabbar_message_center_selected"];
    
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    [self addChildVc:profile title:@"梦 我" image:@"tabbar_profile" selectImage:@"tabbar_profile_selected"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)addChildVc:(UIViewController *)childVC title: (NSString *)title image: (NSString*)image selectImage: (NSString *)selectedImage {
    
    // 设置子控制器的文字
    //childVC.tabBarItem.title = title;
    //childVC.navigationItem.title = title;
    childVC.title = title;
    // 图片
    childVC.tabBarItem.image = [UIImage imageNamed:image];
    if (IOS7) {
        childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        childVC.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    }
    
    // 设置文字样式
    NSMutableDictionary *profileAttri = [NSMutableDictionary dictionary];
    profileAttri[NSForegroundColorAttributeName] = kViewTabbarNormal;
    [childVC.tabBarItem setTitleTextAttributes:profileAttri forState:UIControlStateNormal];
    profileAttri[NSFontAttributeName] = [UIFont boldSystemFontOfSize:12];
    [childVC.tabBarItem setTitleTextAttributes:profileAttri forState:UIControlStateNormal];
    profileAttri[NSForegroundColorAttributeName] = kViewTabbarSelected;
    [childVC.tabBarItem setTitleTextAttributes:profileAttri forState:UIControlStateSelected];
    [childVC.tabBarItem setTitleTextAttributes:profileAttri forState:UIControlStateSelected];
    // 设置子控制器的背景颜色, 设置view会创建该窗口，如果不设置则不会提前设置
    // childVC.view.backgroundColor = WBRandomColor;
    
    MainNavigationController* nav = [[MainNavigationController alloc]initWithRootViewController:childVC];
    [self addChildViewController:nav];
}
@end
