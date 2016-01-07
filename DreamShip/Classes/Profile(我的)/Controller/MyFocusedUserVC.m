//
//  MyFocusedUserVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/6.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "MyFocusedUserVC.h"
#import "UserModelCell.h"
#import "UserFrame.h"
#import "DSUser.h"

#import "MJExtension.h"
#import "HttpTool.h"

#import "AccountModel.h"
#import "AccountTool.h"

@interface MyFocusedUserVC()

@property (nonatomic, strong) NSMutableArray *userFrames;

@end
@implementation MyFocusedUserVC

-(NSMutableArray *)userFrames{
    if (_userFrames == nil) {
        _userFrames = [NSMutableArray array];
    }
    return _userFrames;
}

-(id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setTableViewInfo];
    
    [self getFocusedUsers];
}

-(void)setTableViewInfo{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserFrame *frame = [self.userFrames objectAtIndex:indexPath.row];
    return frame.cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserModelCell *userCell = [UserModelCell cellWithTableView:tableView];
    userCell.userFrame = [self.userFrames objectAtIndex:indexPath.row];
    
    return userCell;
}
@end
