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
    
    self.title = @"追梦人";
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
    
    //添加下拉的动画图片
    //设置下拉刷新回调
    [tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getFocusedUsers)];
    
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"users";
    params[@"api_type"] = @"getAllUsers";
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {
        DBLog(@"%@", json);
        NSArray *users = [DSUser mj_objectArrayWithKeyValuesArray:json[@"data"]];
        NSArray *userFrames = [self dreamFramesWithDreams:users];
        
        self.userFrames = [NSMutableArray arrayWithArray:userFrames];
        
        if (self.userFrames.count == 0) {
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

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"加入黑名单";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [CommomToolDefine alertWithTitle:@"确定将其加入黑名单吗?" message:nil ok:^{
            [MBProgressHUD showSuccess:@"已经拉黑"];
        } cancel:nil];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [self.tableView setEditing:NO animated:YES];
}
@end
