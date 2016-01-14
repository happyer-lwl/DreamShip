//
//  DiscoverViewController.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/17.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "DiscoverViewController.h"

@implementation DiscoverViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    UIImage *bgImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DreamUFO" ofType:@"jpeg"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE), @(ConversationType_DISCUSSION)]];
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStylePlain target:self action:@selector(openListInfo)];
    
    [self signIn];
}

-(void)openListInfo{
    
}

-(void)signIn{
    NSString *token = @"UmxUvmGofoc1yF3CcpUXxeUO7UUKkLoTmIelV1RTHhAs9yHaVjuhtHzTiGkjGSY9tVOTAfff2RXu3RGeVmbysA==";
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        DBLog(@"Sucessfull with userId: %@.", userId);
        
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        
    } error:^(RCConnectErrorCode status) {
        DBLog(@"Error: %ld", (long)status);
    } tokenIncorrect:^{
        DBLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
    }];
}
@end
