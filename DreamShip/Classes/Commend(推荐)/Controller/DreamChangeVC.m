//
//  DreamChangeVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/19.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "DreamChangeVC.h"
#import "UserSkillModel.h"
#import "UserSkillShowVC.h"
#import "UserSkillCell.h"
#import "UserSkillModel.h"
#import "DSUser.h"

#import "HttpTool.h"
#import "MJExtension.h"
#import "UIBarButtonItem+Extension.h"

#import "AddUserSkillVC.h"

@interface DreamChangeVC ()

@property (nonatomic, strong) NSMutableArray *userSkillsArray;
@property (nonatomic, weak)   UITableView *tableView;

@end

@implementation DreamChangeVC

-(NSMutableArray *)userSkillsArray{
    if (_userSkillsArray == nil) {
        _userSkillsArray = [NSMutableArray array];
    }
    
    return _userSkillsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewBgColor;
    
    [self setNavgationView];
    [self setTableViewInfo];
    
    [kNotificationCenter addObserver:self selector:@selector(getUserSkills) name:kGetUserSkills object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  设置导航栏信息
 */
-(void)setNavgationView{
    self.title = @"技能交换吧";
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *rightBarButtonItem = [UIBarButtonItem itemWithAction:@selector(addNewSkill) target:self image:@"navigationbar_add" highImage:@""];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)addNewSkill{
    AddUserSkillVC *addSkillVC = [[AddUserSkillVC alloc] init];
    [self.navigationController pushViewController:addSkillVC animated:YES];
}
/**
 *  设置tableView列表信息
 */
-(void)setTableViewInfo{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height - 64) style:UITableViewStyleGrouped];
    
    tableView.backgroundColor = kViewBgColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    [self getUserSkills];
}

-(void)getUserSkills{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"users";
    params[@"api_type"] = @"getUserSkills";
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {
        DBLog(@"%@", json);
        NSArray *userSkills = [UserSkillModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
 
        [self.userSkillsArray removeAllObjects];
        [self.userSkillsArray addObjectsFromArray:userSkills];
        
        if (self.userSkillsArray.count == 0) {
            [CommomToolDefine addNoDataForView:self.view];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
        [MBProgressHUD showError:@"网络错误!"];
    }];
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userSkillsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kSkillCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserSkillCell *userSkillCell = [UserSkillCell cellWithTableView:tableView];
    userSkillCell.userSkillModel = [self.userSkillsArray objectAtIndex:indexPath.row];
    
    return userSkillCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserSkillModel *skillModel = [self.userSkillsArray objectAtIndex:indexPath.row];
    
    UserSkillShowVC *skillDetailVC = [[UserSkillShowVC alloc] init];
    skillDetailVC.title = skillModel.user.userRealName;
    skillDetailVC.userSkill = skillModel;
    [self.navigationController pushViewController:skillDetailVC animated:YES];
}

@end
