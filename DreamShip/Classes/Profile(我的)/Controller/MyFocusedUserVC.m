//
//  MyFocusedUserVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/6.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "MyFocusedUserVC.h"
#import "PersonDetailVC.h"

#import "UserModelCell.h"
#import "UserFrame.h"
#import "DSUser.h"

#import "MJExtension.h"
#import "HttpTool.h"
#import "MJRefresh.h"

#import "AccountModel.h"
#import "AccountTool.h"

@interface MyFocusedUserVC()

@property (nonatomic, strong) NSMutableArray *userFrames;
@property (nonatomic, weak) UITableView *tableView;

@end
@implementation MyFocusedUserVC

-(NSMutableArray *)userFrames{
    if (_userFrames == nil) {
        _userFrames = [NSMutableArray array];
    }
    return _userFrames;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setTableViewInfo];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getFocusedUsers];
}

-(void)setTableViewInfo{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    tableView.backgroundColor = kViewBgColorDarker;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    _tableView = tableView;

    //添加下拉的动画图片
    //设置下拉刷新回调
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getFocusedUsers)];
    
    //设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; ++i) {
        //        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd",i]];
        //        [idleImages addObject:image];
        UIImage *image = [UIImage imageNamed:@"icon_listheader_animation_1"];
        [idleImages addObject:image];
    }
    [self.tableView.gifHeader setImages:idleImages forState:MJRefreshHeaderStateIdle];
    
    //设置即将刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    UIImage *image1 = [UIImage imageNamed:@"icon_listheader_animation_1"];
    [refreshingImages addObject:image1];
    UIImage *image2 = [UIImage imageNamed:@"icon_listheader_animation_2"];
    [refreshingImages addObject:image2];
    [self.tableView.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStatePulling];
    
    //设置正在刷新是的动画图片
    [self.tableView.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStateRefreshing];
    
    //马上进入刷新状态
    [self.tableView.gifHeader beginRefreshing];
}

-(void)getFocusedUsers{
    AccountModel *userModel = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"users";
    params[@"api_type"] = @"getFocusedUser";
    params[@"user_id"] = userModel.userID;
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {
        DBLog(@"%@", json);
        NSArray *users = [DSUser mj_objectArrayWithKeyValuesArray:json[@"data"]];
        NSArray *userFrames = [self dreamFramesWithDreams:users];
        
        self.userFrames = [NSMutableArray arrayWithArray:userFrames];
        
        if (userFrames.count == 0) {
            [CommomToolDefine addNoDataForView:self.view];
        }
        
        [self.tableView reloadData];
        [self.tableView.gifHeader endRefreshing];
        
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
        [MBProgressHUD showError:@"网络错误!"];
        [self.tableView.gifHeader endRefreshing];
    }];
}

-(NSArray *)dreamFramesWithDreams:(NSArray*)users{
    // 将WBStatus数组转为 WBStatusFrame数组
    NSMutableArray *newUsers = [NSMutableArray array];
    for (DSUser *user in users) {
        UserFrame *frame = [[UserFrame alloc]init];
        frame.user = user;
        [newUsers addObject:frame];
    }
    
    return newUsers;
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userFrames.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserFrame *frame = [self.userFrames objectAtIndex:indexPath.row];
    return frame.cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserModelCell *userCell = [UserModelCell cellWithTableView:tableView];
    userCell.userFrame = [self.userFrames objectAtIndex:indexPath.row];
    
    return userCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserFrame *userFrame = [self.userFrames objectAtIndex:indexPath.row];
    
    PersonDetailVC *personDetailVC = [[PersonDetailVC alloc] init];
    personDetailVC.user = userFrame.user;
    
    [self.navigationController pushViewController:personDetailVC animated:YES];
}
@end
