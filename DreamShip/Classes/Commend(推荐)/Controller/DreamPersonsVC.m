//
//  DreamPersonsVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/11.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "DreamPersonsVC.h"
#import "DSUser.h"
#import "UserFrame.h"
#import "UserModelCell.h"
#import "PersonDetailVC.h"

#import "AccountModel.h"
#import "AccountTool.h"
#import "HttpTool.h"

#import "MJExtension.h"
#import "MJRefresh.h"

@interface DreamPersonsVC ()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *userFrames;

@end

@implementation DreamPersonsVC

-(NSMutableArray *)userFrames{
    if (_userFrames == nil) {
        _userFrames = [NSMutableArray array];
    }
    
    return _userFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"梦想达人";
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = kViewBgColor;
    
    [self setTableViewInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTableViewInfo{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height - 64) style:UITableViewStyleGrouped];
    
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    [self getFocusedUsers];
}

-(void)getFocusedUsers{
    AccountModel *userModel = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"users";
    params[@"api_type"] = @"getAllUsers";
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {
        DBLog(@"%@", json);
        NSArray *users = [DSUser mj_objectArrayWithKeyValuesArray:json[@"data"]];
        NSArray *userFrames = [self dreamFramesWithDreams:users];
        
        self.userFrames = [NSMutableArray arrayWithArray:userFrames];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
        [MBProgressHUD showError:@"网络错误!"];
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
    return 0.1;
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
    PersonDetailVC *detailVC = [[PersonDetailVC alloc] init];
    UserFrame *userFrame = [self.userFrames objectAtIndex:indexPath.row];
    detailVC.user = userFrame.user;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
