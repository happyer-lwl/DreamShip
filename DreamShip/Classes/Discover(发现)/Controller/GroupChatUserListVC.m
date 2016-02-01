//
//  GroupChatUserListVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/29.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "GroupChatUserListVC.h"
#import "GroupChatVC.h"
#import "SimpleUserCellView.h"

#import "DSUser.h"
#import "UserGroupModel.h"

#import "HttpTool.h"
#import "AccountModel.h"
#import "AccountTool.h"

#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MJRefreshGifHeader.h"

@interface GroupChatUserListVC()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) UITableViewCellEditingStyle cellEditStyle;
@property (nonatomic, weak) UITextField *groupName;
@property (nonatomic, weak) UITextField *groupBrief;

@property (nonatomic, strong) NSMutableArray *usersArray;
@property (nonatomic, strong) NSMutableArray *selectedUsers;

@end

@implementation GroupChatUserListVC

-(NSMutableArray *)usersArray{
    if (_usersArray == nil) {
        _usersArray = [NSMutableArray array];
    }
    
    return _usersArray;
}

-(NSMutableArray *)selectedUsers{
    if (_selectedUsers == nil) {
        _selectedUsers = [NSMutableArray array];
    }
    
    return _selectedUsers;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = kTitleFireColorNormal;
    
    self.navigationItem.title = @"选择梦友";
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(confirmGroupPerson)];
    self.navigationItem.rightBarButtonItem = confirmButton;
    
    [self setGroupInfoView];
    [self setTableViewInfo];
}

-(void)confirmGroupPerson{
    AccountModel *account = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"users";
    params[@"api_type"]= @"createGroupChat";
    
    params[@"appKey"] = kRongCloudAppKey;
    params[@"appSecret"] = kRongCloudAppSecret;
    params[@"phone"] = account.userPhone;
    params[@"groupName"] = self.groupName.text.length ? self.groupName.text : @"群聊";
    params[@"groupBrief"] = self.groupBrief.text.length ? self.groupBrief.text : @"群主很懒，什么都没有。。。";
    params[@"groupUsers"] = [self getSelectedUserIDsWithArray:self.selectedUsers];
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {
        DBLog(@"%@", json);
        
        UserGroupModel *group = [UserGroupModel mj_objectWithKeyValues:json[@"data"]];
        
        GroupChatVC *groupChatVC = [[GroupChatVC alloc] initWithConversationType:ConversationType_GROUP targetId:group.idStr];
        groupChatVC.userGroup = group;
        
        [self.navigationController pushViewController:groupChatVC animated:YES];
    } failure:^(NSError *error) {
        DBLog(@"网络错误 %@", error.description);
    }];
}

-(NSMutableString *)getSelectedUserIDsWithArray:(NSArray *)selectedUsers{
    NSMutableString *userIDS = [NSMutableString string];
    
    for (NSInteger i = 0; i < selectedUsers.count - 1; i++) {
        DSUser *user = [selectedUsers objectAtIndex:i];
        [userIDS appendFormat:@"%@;", user.name];
    }
    DSUser *user = [selectedUsers objectAtIndex:selectedUsers.count - 1];
    [userIDS appendString:user.name];
    
    return userIDS;
}

-(void)setGroupInfoView{
    
    UITextField *textName = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth - 10, 35)];
    textName.placeholder = @"来一个群名儿";
    textName.textAlignment = NSTextAlignmentCenter;
    textName.backgroundColor = [UIColor whiteColor];
    textName.keyboardType = UIKeyboardTypeDefault;
    textName.layer.cornerRadius = 5;
    textName.layer.borderColor = kViewBgColorDarkest.CGColor;
    textName.layer.borderWidth = 2;
    _groupName = textName;
    [self.view addSubview:textName];
    
    UITextField *briefText = [[UITextField alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(textName.frame) + 5, kScreenWidth - 10, 35)];
    briefText.placeholder = @"群简介";
    briefText.textAlignment = NSTextAlignmentCenter;
    briefText.backgroundColor = [UIColor whiteColor];
    briefText.keyboardType = UIKeyboardTypeDefault;
    briefText.layer.cornerRadius = 5;
    briefText.layer.borderColor = kViewBgColorDarkest.CGColor;
    briefText.layer.borderWidth = 2;
    _groupBrief = briefText;
    [self.view addSubview:briefText];
}

-(void)setTableViewInfo{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.groupBrief.frame) + 5, kScreenWidth, kScreenHeight - self.groupName.height - self.groupBrief.height - 64) style:UITableViewStyleGrouped];
    tableView.backgroundColor = kViewBgColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setEditing:YES animated:YES];
    
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"users";
    params[@"api_type"] = @"getAllUsers";
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {
        DBLog(@"%@", json);
        NSArray *users = [DSUser mj_objectArrayWithKeyValuesArray:json[@"data"]];
        
        self.usersArray = [NSMutableArray arrayWithArray:users];
        
        [self.tableView reloadData];
        [self.tableView.gifHeader endRefreshing];
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
        [MBProgressHUD showError:@"网络错误!"];
        [self.tableView.gifHeader endRefreshing];
    }];
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.usersArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kSimpleUserCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SimpleUserCellView *cell = [SimpleUserCellView cellWithTableView:tableView];
    cell.userModel = [self.usersArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DSUser *user = [self.usersArray objectAtIndex:indexPath.row];
    
    [self.selectedUsers addObject:user];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    DSUser *user = [self.usersArray objectAtIndex:indexPath.row];
    
    [self.selectedUsers removeObject:user];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.cellEditStyle = UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    return self.cellEditStyle;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    if (editing) {
    }
}
@end
