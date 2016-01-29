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
#import "AudioController.h"

#import "LWLFileManager.h"
#import "SDWebImageManager.h"
#import "AccountModel.h"
#import "AccountTool.h"

#define kTagPwdReset    1
#define kTagClear       2
#define kTagBgAudio     3

#define kTagQuit        6


@interface SetTableViewController ()

@property (nonatomic, strong) NSMutableArray* setGroups;
@property (nonatomic, weak) UISwitch *audioSwitch;
@property (nonatomic, weak) UIButton *quitButton;

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
    self.tableView.backgroundColor = kViewBgColor;

    self.navigationItem.title = @"设置";
    self.tableView.tableHeaderView.height = 0;
    
    [self setSwitchInfo];
    [self setGroupSetting];
    [self setGroupQuit];
}

/**
 *  设置开关按键
 */
-(void)setSwitchInfo{
    UISwitch *audioSwitch = [[UISwitch alloc] init];
    audioSwitch.frame = CGRectMake(0, 0, 50, 25);
    audioSwitch.on = NO;
    [audioSwitch addTarget:self action:@selector(audioSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    _audioSwitch = audioSwitch;
}

/**
 *  后台音乐播放开关
 *
 *  @param audioSwitch
 */
-(void)audioSwitchChanged:(UISwitch *)audioSwitch{
    if (audioSwitch.on) {
        [KUserDefaults setBool:YES forKey:@"background_audio"];
        [AudioController playMusic];
    }else{
        [KUserDefaults setBool:NO forKey:@"background_audio"];
        [AudioController stopMusic];
    }
}

/**
 设置缓存清楚
 */
-(void)setGroupSetting{
    TableGroupModel* group = [[TableGroupModel alloc]init];
    
    float tmpSize = [[SDImageCache sharedImageCache] getSize] / 1024.0 / 1024.0;
    NSString *tmpSizeStr = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
    
    TableItemModel* itemPwd = [TableItemModel initWithTitle:@"密码重置" tag:kTagPwdReset];
    TableItemModel* itemClear = [TableItemModel initWithTitle:@"清除缓存" detailTitle:tmpSizeStr tag:kTagClear];
    TableItemModel* itemBgAudio = [TableItemModel initWithTitle:@"背景音乐: 追梦人" tag:kTagBgAudio];
    
    group.items = @[itemPwd, itemClear, itemBgAudio];
    
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
        return 0.4 * kScreenHeight;
    }else{
        return 20;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* ID = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    TableGroupModel* group = [self.setGroups objectAtIndex:indexPath.section];
    TableItemModel* item = [group.items objectAtIndex:indexPath.row];

    cell.textLabel.text = item.title;
    cell.tag = item.tag;
    
    if (cell.tag == kTagQuit) {
        UIButton *quitButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 44)];
        quitButton.backgroundColor = kBtnFireColorNormal;
        [quitButton setTitle:item.title forState:UIControlStateNormal];
        [quitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [quitButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        quitButton.layer.cornerRadius = 3;
        quitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [quitButton addTarget:self action:@selector(quitToMain) forControlEvents:UIControlEventTouchUpInside];
        
        _quitButton = quitButton;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:quitButton];
        cell.backgroundColor = [UIColor clearColor];
    }else if (cell.tag == kTagBgAudio){
        UISwitch *audioSwitch = [[UISwitch alloc] init];
        audioSwitch.frame = CGRectMake(0, 0, 50, 25);
        audioSwitch.on = [KUserDefaults boolForKey:@"background_audio"];
        [audioSwitch addTarget:self action:@selector(audioSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = audioSwitch;
    }else if (cell.tag == kTagClear){
        cell.detailTextLabel.text = item.detailTitle;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        case kTagBgAudio:
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
        
        [MBProgressHUD showMessage:@"Cleaning"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[SDImageCache sharedImageCache] clearDisk];
            
           dispatch_async(dispatch_get_main_queue(), ^{
               float tmpSize = [[SDImageCache sharedImageCache] getSize] / 1024.0 / 1024.0;
               NSString *tmpSizeStr = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
               
               UITableViewCell *clearCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
               clearCell.detailTextLabel.text = tmpSizeStr;
               
               [MBProgressHUD hideHUD];
           });
        });
        
        
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
                
                AccountModel *accountModel = [AccountTool account];
                accountModel.userPwd = @"";
                [AccountTool saveAccount:accountModel];
                
                registerOrLoginViewController *loginVC = [[registerOrLoginViewController alloc] init];
                [self presentViewController:loginVC animated:YES completion:nil];
           });
    }];
    
    [alert addAction:actionCancel];
    [alert addAction:actionOK];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
