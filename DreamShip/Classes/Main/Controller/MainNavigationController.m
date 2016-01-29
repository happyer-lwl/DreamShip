//
//  WBNavigationController.m
//  SinaWeibo
//
//  Created by 刘伟龙 on 15/11/27.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "MainNavigationController.h"
#import "UIBarButtonItem+Extension.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置navigationBar主题
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background_fire"] forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    self.navigationBar.titleTextAttributes = dict;
    
    // 设置按键主题
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    
    // 设置整个项目的Item的主题
    UIBarButtonItem *item = [UIBarButtonItem appearance];

    // 普通状态
    NSMutableDictionary *textAttri = [NSMutableDictionary dictionary];
    textAttri[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttri[NSFontAttributeName] = [UIFont boldSystemFontOfSize:15];
    [item setTitleTextAttributes:textAttri forState:UIControlStateNormal];
    
    // 禁用状态
    NSMutableDictionary *textAttriDisable = [NSMutableDictionary dictionary];
    textAttriDisable[NSForegroundColorAttributeName] = [UIColor lightTextColor];
    textAttriDisable[NSFontAttributeName] = textAttri[NSFontAttributeName];
    [item setTitleTextAttributes:textAttriDisable forState:UIControlStateDisabled];
    
    // 添加右滑手势
    [self addSwipeRecognizer];
}

#pragma mark 添加右滑手势
- (void)addSwipeRecognizer
{
    // 初始化手势并添加执行方法
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(return)];
    
    // 手势方向
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    // 响应的手指数
    swipeRecognizer.numberOfTouchesRequired = 1;
    
    // 添加手势
    [[self view] addGestureRecognizer:swipeRecognizer];
}

#pragma mark 返回上一级
- (void)return
{
    // 最低控制器无需返回
    if (self.viewControllers.count <= 1) return;
    
    // pop返回上一级
    [self popViewControllerAnimated:YES];
}

-(void)backToPre{
    [self popViewControllerAnimated:YES];
}

-(void)backToMain{
    [self popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIBarButtonItem *leftButtonItem = [UIBarButtonItem itemWithAction:@selector(backToPre) target:self image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
        
//        UIBarButtonItem *rightButtonItem = [UIBarButtonItem itemWithAction:@selector(backToMain) target:self image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"M" style:UIBarButtonItemStyleDone target:self action:@selector(backToMain)];
        
        viewController.navigationItem.leftBarButtonItem = leftButtonItem;
        viewController.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    [super pushViewController:viewController animated:animated];
}

@end
