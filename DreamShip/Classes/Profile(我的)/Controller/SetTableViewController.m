//
//  SetTableViewController.m
//  LoseYourTemper
//
//  Created by 刘伟龙 on 15/11/18.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "SetTableViewController.h"
#import "registerOrLoginViewController.h"
#import "PwdResetController.h"

#define kTagPwdReset    1
#define kTagClear       2
#define kTagQuit        6


@interface SetTableViewController ()

@property (nonatomic, strong) NSMutableArray* setGroups;

@end

@implementation SetTableViewController

-(NSArray *)setGroups{
    if (_setGroups == nil) {
        _setGroups = [NSMutableArray array];
    }
    return _setGroups;
}

-(instancetype)init{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = RGBColor(240, 240, 240);

    self.navigationItem.title = @"设置";
    self.tableView.tableHeaderView.height = 0;
//    self.tableView.scrollEnabled = NO;
    
    [self setGroupClear];
    
    [self setGroupQuit];
}

/**
 设置缓存清楚
 */
-(void)setGroupClear{
    TableGroupModel* group = [[TableGroupModel alloc]init];
    
    TableItemModel* itemPwd = [TableItemModel initWithTitle:@"密码重置" tag:kTagPwdReset];
    TableItemModel* itemClear = [TableItemModel initWithTitle:@"清空缓存" tag:kTagClear];
    
    group.items = @[itemPwd, itemClear];
    
    [self.setGroups addObject:group];
}

/**
 设置系统退出
 */
-(void)setGroupQuit{
    TableGroupModel* group = [[TableGroupModel alloc]init];
    
    TableItemModel* item = [TableItemModel initWithTitle:@"退出我的帐号" tag:kTagQuit];
    group.items = @[item];
    
    [self.setGroups addObject:group];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    NSLog(@"sections");
    return [self.setGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    TableGroupModel* group = [self.setGroups objectAtIndex:section];
    NSLog(@"rows");
    return [group.items count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 385;
    }else{
        return 20;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* ID = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    TableGroupModel* group = [self.setGroups objectAtIndex:indexPath.section];
    TableItemModel* item = [group.items objectAtIndex:indexPath.row];

    cell.textLabel.text = item.title;
    cell.tag = item.tag;
    
    if (cell.tag == kTagQuit) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch ([tableView cellForRowAtIndexPath:indexPath].tag) {
        case kTagPwdReset:
            [self pwdReset];
            break;
        case kTagClear:
            [self clearData];
            break;
        case kTagQuit:
            [self quitToMain];
            break;
        default:
            break;
    }
}

// 重置密码
-(void)pwdReset{
    PwdResetController *pwdResetVC = [[PwdResetController alloc] init];
    [self.navigationController pushViewController:pwdResetVC animated:YES];
}

// 清除缓存
-(void)clearData{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"确定要清空缓存吗?" message:@"" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction* actionOk = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //        FMDatabase* db = [[DataBaseSharedManager sharedManager] getDB];
        //        [db executeUpdate:@"drop table mod"];
    }];
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:actionOk];
    [alert addAction:actionCancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// 注销
-(void)quitToMain{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要退出?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
            dispatch_after(0.2, dispatch_get_main_queue(), ^{
                
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                
                registerOrLoginViewController *loginVC = [[registerOrLoginViewController alloc] init];
                [self presentViewController:loginVC animated:YES completion:nil];
           });
    }];
    
    [alert addAction:actionCancel];
    [alert addAction:actionOK];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
