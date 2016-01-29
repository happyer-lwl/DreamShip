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

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getFocusedUsers];
    }];
    [self.tableView.mj_header beginRefreshing];
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
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
        [MBProgressHUD showError:@"网络错误!"];
        [self.tableView.mj_header endRefreshing];
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
