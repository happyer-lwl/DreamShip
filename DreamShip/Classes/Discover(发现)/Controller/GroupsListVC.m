//
//  GroupsListVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/31.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "GroupsListVC.h"
#import "GroupListCellView.h"
#import "GroupChatVC.h"
#import "UserGroupModel.h"
#import "MJRefresh.h"

#import "AccountModel.h"
#import "AccountTool.h"
#import "HttpTool.h"
#import "MJExtension.h"

@interface GroupsListVC()

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *groupsArray;
@end

@implementation GroupsListVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"群聊";
    
    [self initSubTableView];
}

-(void)initSubTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
    tableView.backgroundColor = kViewBgColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    //添加下拉的动画图片
    //设置下拉刷新回调
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getGroupsInfo)];
    
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

-(void)getGroupsInfo{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"users";
    params[@"api_type"] = @"getAllGroups";
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {
        DBLog(@"%@", json);
        NSArray *groups = [UserGroupModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
        
        self.groupsArray = [NSMutableArray arrayWithArray:groups];
        
        if (self.groupsArray.count == 0) {
            [CommomToolDefine addNoDataForView:self.view];
        }
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
        [MBProgressHUD showError:@"网络错误!"];
        [self.tableView.header endRefreshing];
    }];
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groupsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupListCellView *groupListCell = [GroupListCellView cellWithTableView:tableView];
    groupListCell.groupModel = [self.groupsArray objectAtIndex:indexPath.row];
    
    return groupListCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserGroupModel *groupModel = [self.groupsArray objectAtIndex:indexPath.row];
    GroupChatVC *groupChat = [[GroupChatVC alloc] initWithConversationType:ConversationType_GROUP targetId:groupModel.idStr];
    groupChat.userGroup = groupModel;
    groupChat.navigationItem.title = groupModel.name;
    
    [self.navigationController pushViewController:groupChat animated:YES];
}
@end
