//
//  PersonDetailVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/13.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "PersonDetailVC.h"
#import "DreamsInfoVC.h"

#import "DSUser.h"
#import "AccountModel.h"
#import "AccountTool.h"
#import "HttpTool.h"

#import "TableGroupModel.h"
#import "TableItemModel.h"

#import "UIImageView+WebCache.h"

#define kUpdateUserImage @"UPDATE_USER_IMAGE"

#define kCellTagUser        1

#define kCellTagWords       2
#define kCellTagAddr        3
#define kCellTagMail        4
#define kCellTagPhone       5

#define kCellTagDreams      6

#define kCellTagFocus       7
#define kCellTagSendMsg     8

@interface PersonDetailVC ()

@property (nonatomic, strong) NSMutableArray *groups;

@property (nonatomic, weak)   UIButton       *focusButton;
@property (nonatomic, weak)   UIButton       *sendButton;
@property (nonatomic, assign) BOOL           bFocused;

@end

@implementation PersonDetailVC

-(NSMutableArray *)groups{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    
    return _groups;
}

-(id)init{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kViewBgColor;
    self.title = self.user.userRealName;
    self.bFocused = NO;
    [kNotificationCenter addObserver:self forKeyPath:@"self.bFocused" options:(NSKeyValueObservingOptionNew) context:nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = kViewBgColor;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self getUserFocusStatus];
    [self setGroup1];
    [self setGroup2];
    [self setGroup3];
    [self setGroup4];
    [self setGroup5];
    
    [kNotificationCenter addObserver:self selector:@selector(updateUserImage) name:kUpdateUserImage object:nil];
    
    [self.tableView reloadData];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString: @"self.bFocused"]) {
        BOOL bFocused = [change[NSKeyValueChangeNewKey] boolValue];
        if (bFocused) {
            [self.focusButton setTitle:@"已 关 注" forState:UIControlStateNormal];
        }else{
            [self.focusButton setTitle:@"关 注 他" forState:UIControlStateNormal];
        }
    }
}

/**
 *  设置头像后更新
 */
-(void)updateUserImage{
    [self.tableView reloadData];
}

-(void)setGroup1{
    TableGroupModel *group = [TableGroupModel group];
    
    TableItemModel *item = [TableItemModel initWithTitle:self.user.userRealName detailTitle:self.user.userWords tag:kCellTagUser];
    group.items = @[item];
    
    [self.groups addObject:group];
}

-(void)setGroup2{
    TableGroupModel *group = [TableGroupModel group];
    
    TableItemModel *item1 = [TableItemModel initWithTitle:@"个性签名" detailTitle:self.user.userWords tag:kCellTagWords];
    TableItemModel *item2 = [TableItemModel initWithTitle:@"地址" detailTitle:self.user.userAddr tag:kCellTagAddr];
    TableItemModel *item3 = [TableItemModel initWithTitle:@"邮箱" detailTitle:self.user.userMail tag:kCellTagMail];
    TableItemModel *item4 = [TableItemModel initWithTitle:@"电话" detailTitle:self.user.name tag:kCellTagPhone];
    group.items = @[item4, item1, item2, item3];
    
    [self.groups addObject:group];
}


-(void)setGroup3{
    TableGroupModel *group = [TableGroupModel group];

    TableItemModel *item2 = [TableItemModel initWithTitle:@"他的梦想" tag:kCellTagDreams];
    group.items = @[item2];
    
    [self.groups addObject:group];
}

-(void)setGroup4{
    TableGroupModel *group = [TableGroupModel group];
    NSString *focusStatus = @"";
    TableItemModel *item = [TableItemModel initWithTitle:focusStatus tag:kCellTagFocus];
    group.items = @[item];
    
    [self.groups addObject:group];
}

-(void)setGroup5{
    TableGroupModel *group = [TableGroupModel group];
    TableItemModel *item = [TableItemModel initWithTitle:@"发消息" tag:kCellTagSendMsg];
    group.items = @[item];
    
    [self.groups addObject:group];
}

#pragma mark tableViewDelegate/ dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groups.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TableGroupModel *group = [self.groups objectAtIndex:section];
    
    return group.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 88;
    }else if (indexPath.section == 1){
        return 1.0/15.0*kScreenHeight;
    }else if (indexPath.section == 2){
        return 1.0/12.0*kScreenHeight;
    }else{
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.5;
    }else if (section == 3){
        return 20;
    }else{
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IDOther = @"other";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDOther];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IDOther];
    }
    
    TableGroupModel *group = [self.groups objectAtIndex:indexPath.section];
    TableItemModel  *item  = [group.items objectAtIndex:indexPath.row];
    
    
    cell.tag = item.tag;
    
    if (cell.tag == kCellTagFocus) {
        UIButton *focusButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 44)];
        focusButton.backgroundColor = kButtonBgIconGray;
        [focusButton setTitle:item.title forState:UIControlStateNormal];
        [focusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [focusButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        focusButton.layer.cornerRadius = 3;
        focusButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [focusButton addTarget:self action:@selector(focusOnCurUser) forControlEvents:UIControlEventTouchUpInside];
        
        _focusButton = focusButton;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:focusButton];
        cell.backgroundColor = [UIColor clearColor];
    }else if (cell.tag == kCellTagSendMsg) {
        UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 44)];
        sendButton.backgroundColor = kButtonBgIconGray;
        [sendButton setTitle:item.title forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        sendButton.layer.cornerRadius = 3;
        sendButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [sendButton addTarget:self action:@selector(sendMessageToCurUser) forControlEvents:UIControlEventTouchUpInside];
        
        _sendButton = sendButton;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:sendButton];
        cell.backgroundColor = [UIColor clearColor];
    }else{
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        if (cell.tag == kCellTagUser) {
            NSURL *imageUrl = [NSURL URLWithString:self.user.image];
            if (self.user.image.length) {
                [cell.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
            }else{
                cell.imageView.image = [UIImage imageNamed:@"avatar_default_big"];
            }
            cell.imageView.layer.cornerRadius = 40;
            cell.imageView.layer.masksToBounds = YES;
            cell.imageView.backgroundColor = [UIColor lightGrayColor];
            NSString *title = [NSString stringWithFormat:@"追梦人: %@", item.title];
            NSString *detailTitle = [NSString stringWithFormat:@"  %@", item.detailTitle];
            cell.textLabel.text = title;
        }else if (cell.tag == kCellTagDreams){
            cell.textLabel.text = item.title;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.textLabel.text = item.title;
            cell.detailTextLabel.text = item.detailTitle;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.tag == kCellTagDreams){
        DreamsInfoVC *dreamInfoVC = [[DreamsInfoVC alloc] init];
        dreamInfoVC.title = self.user.userRealName;
        dreamInfoVC.user = self.user;
        dreamInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dreamInfoVC animated:YES];
    }else if (cell.tag == kCellTagPhone){
        NSString *phoneNum = cell.detailTextLabel.text;

        if (phoneNum.length) {
            UIAlertController *alert = [CommomToolDefine alertWithTitle:@"拨打电话给" message:phoneNum ok:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNum]]];
            } cancel:nil];
        [self presentViewController:alert animated:YES completion:nil];
        }else{
            [MBProgressHUD showError:@"电话号为空"];
        }
    }else if (cell.tag == kCellTagMail){
        NSString *mail = cell.detailTextLabel.text;
        
        if (mail.length) {
            UIAlertController *alert = [CommomToolDefine alertWithTitle:@"发送邮件给" message:mail ok:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", mail]]];
            } cancel:nil];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            [MBProgressHUD showError:@"邮箱为空"];
        }
    }
//    else if (cell.tag == kTagSetting) {
//        SetTableViewController *setVC = [[SetTableViewController alloc] init];
//        setVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:setVC animated:YES];
//    }else if (cell.tag == kTagMyDream){
//        HomeViewController *homeVC = [[HomeViewController alloc] init];
//        homeVC.title = @"我的梦想";
//        homeVC.dreamRange = DreamRangeSelf;
//        homeVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:homeVC animated:YES];
//    }else if (cell.tag == kTagMyFocus){
//        MyFocusedUserVC *focusedUserVC = [[MyFocusedUserVC alloc] init];
//        focusedUserVC.title = @"我的关注";
//        focusedUserVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:focusedUserVC animated:YES];
//    }
}

/**
 *  发消息
 */
-(void)sendMessageToCurUser{
    
}

/**
 *  关注或者取消关注
 */
-(void)focusOnCurUser{
    AccountModel *account = [AccountTool account];
    if ([account.userID isEqualToString:self.user.user_id]) {
        [MBProgressHUD showError:@"亲，不能关注自己哦"];
    }else if ([self.focusButton.titleLabel.text isEqualToString:@"取 消 关 注"]){
        [self cancelUserFocus];
    }else{
        [self postUserFocus];
    }
}

-(void)postUserFocus{
    AccountModel *account = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"users";
    params[@"api_type"] = @"createFocus";
    params[@"user_id_from"] = account.userID;
    params[@"user_id_to"] = self.user.user_id;
    
    [HttpTool postWithUrl:Host_Url params:params success:^(NSDictionary *json) {
        NSNumber *result = json[@"result"];
        if ([result integerValue] == 200) {
            self.bFocused = YES;
            [self.focusButton setTitle:@"取 消 关 注" forState:UIControlStateNormal];
            [MBProgressHUD showSuccess:@"已关注"];
        }else{
            self.bFocused = NO;
            [MBProgressHUD showError:@"关注失败"];
        }
        
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
        [MBProgressHUD showError:@"网络错误!"];
    }];
}

-(void)cancelUserFocus{
    AccountModel *account = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"users";
    params[@"api_type"] = @"cancelFocus";
    params[@"user_id_from"] = account.userID;
    params[@"user_id_to"] = self.user.user_id;
    
    [HttpTool postWithUrl:Host_Url params:params success:^(NSDictionary *json) {
        DBLog(@"取消关注成功");
        NSNumber *result = json[@"result"];
        if ([result integerValue] == 200) {
            self.bFocused = NO;
            [self.focusButton setTitle:@"关 注 他" forState:UIControlStateNormal];
            [MBProgressHUD showSuccess:@"取消成功"];
        }else{
            self.bFocused = YES;
            [MBProgressHUD showError:@"取消失败"];
        }
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
        [MBProgressHUD showError:@"网络错误!"];
    }];
}

-(void)getUserFocusStatus{
    AccountModel *account = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"users";
    params[@"api_type"] = @"getFocusStatus";
    params[@"user_id_from"] = account.userID;
    params[@"user_id_to"] = self.user.user_id;
    
    [HttpTool postWithUrl:Host_Url params:params success:^(NSDictionary *json) {
        NSNumber *iExistedResult = json[@"result"];
        if ([iExistedResult integerValue] ==  200) {
            self.bFocused = YES;
            [self.focusButton setTitle:@"取 消 关 注" forState:UIControlStateNormal];
        }else{
            self.bFocused = NO;
            [self.focusButton setTitle:@"关 注 他" forState:UIControlStateNormal];
        }
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
        [MBProgressHUD showError:@"网络错误!"];
    }];
}
@end
