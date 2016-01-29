//
//  ProfileViewController.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/18.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "ProfileViewController.h"
#import "DreamsInfoVC.h"

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UINavigationBar+BackgroundColor.h"

#import "AccountTool.h"
#import "AccountModel.h"

#import "SetTableViewController.h"
#import "ProfileUserPointsVC.h"
#import "DreamProgressVC.h"
#import "HelpCenterVC.h"
#import "SelfInfoSetViewController.h"
#import "TableGroupModel.h"
#import "TableItemModel.h"
#import "DSUser.h"

#import "HomeViewController.h"
#import "MyFocusedUserVC.h"

#define kTagMine            0

#define kTagMyDream         1
#define kTagMyCollection    2
#define kTagMyFocus         3

#define kTagDreamCredit     4
#define kTagDreamLevel      5
#define kTagHelpCenter      6
#define kTagSetting         7

@interface ProfileViewController()

@property (nonatomic, strong) NSMutableArray* groups;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIImageView *headerView;
@property (nonatomic, weak) UIButton    *userImageBtn;
@property (nonatomic, weak) UILabel     *userNameLabel;

@end

@implementation ProfileViewController
-(NSArray*)groups{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    
    return _groups;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"";
    [self.navigationController.navigationBar nav_setBackgroundColorAlpha:0];
    
    [self setHeadView];
    [self setTableViewUI];
    
    [self setGroup1];
    [self setGroup2];
    [self setGroup3];
    
    [kNotificationCenter addObserver:self selector:@selector(updateUserImage) name:kUpdateUserImage object:nil];
    
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"";
    
    [self.navigationController.navigationBar nav_setBackgroundColorAlpha:0];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self performSelector:@selector(updateNavBackgroundAlpha) withObject:self afterDelay:0.2];
}

-(void)updateNavBackgroundAlpha{
    [self.navigationController.navigationBar nav_setBackgroundColorAlpha:1];
}

-(void)setHeadView{
    AccountModel *account = [AccountTool account];

    UIImageView *headBgImageView = [[UIImageView alloc] init];
    headBgImageView.frame = CGRectMake(0, 0, kScreenWidth, 1.0/4.0 * kScreenHeight);
    headBgImageView.backgroundColor = kBtnFireColorNormal;
    headBgImageView.image = [UIImage imageNamed:@"Dream2"];
    headBgImageView.userInteractionEnabled = YES;
    self.headerView = headBgImageView;
    
    CGFloat buttonWH = 80;
    UIButton *userImageBtn = [[UIButton alloc] init];
    userImageBtn.x = kScreenWidth/2.0 - buttonWH/2;
    userImageBtn.y = 30;
    userImageBtn.width = buttonWH;
    userImageBtn.height = buttonWH;
    userImageBtn.backgroundColor = [UIColor whiteColor];
    userImageBtn.layer.cornerRadius = 40;
    userImageBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    userImageBtn.layer.borderWidth = 2;
    userImageBtn.layer.masksToBounds = YES;
    [userImageBtn addTarget:self action:@selector(selfInfoSetView) forControlEvents:UIControlEventTouchUpInside];
    [userImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:account.userImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    self.userImageBtn = userImageBtn;
    [self.headerView addSubview:userImageBtn];
    
    UILabel *userName = [[UILabel alloc] init];
    userName.frame = CGRectMake(0, CGRectGetMaxY(self.userImageBtn.frame) + 10, kScreenWidth, 30);
    userName.text = account.userRealName;
    userName.textColor = [UIColor whiteColor];
    userName.textAlignment = NSTextAlignmentCenter;
    userName.userInteractionEnabled = YES;
    self.userNameLabel = userName;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfInfoSetView)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [userName addGestureRecognizer:tap];
    
    [self.headerView addSubview:userName];
    
    [self.view addSubview:self.headerView];
}

-(void)setTableViewUI{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreenWidth, kScreenHeight - self.headerView.height) style:UITableViewStyleGrouped];
    tableView.backgroundColor =kViewBgColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

/**
 *  设置头像后更新
 */
-(void)updateUserImage{
    AccountModel *account = [AccountTool account];
    [self.userImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:account.userImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
}

-(void)setGroup1{
    TableGroupModel *group = [TableGroupModel group];
    
    AccountModel *model = [AccountTool account];
    TableItemModel *item = [TableItemModel initWithTitle:model.userRealName detailTitle:model.userWords tag:kTagMine];
    group.items = @[item];
    
    //[self.groups addObject:group];
}

-(void)setGroup2{
    TableGroupModel *group = [TableGroupModel group];
    
    TableItemModel *item1 = [TableItemModel initWithTitle:@"我做的梦" icon:@"vip" tag:kTagMyDream];
    TableItemModel *item2 = [TableItemModel initWithTitle:@"我的收藏" icon:@"collect" tag:kTagMyCollection];
    TableItemModel *item3 = [TableItemModel initWithTitle:@"我的关注" icon:@"like" tag:kTagMyFocus];
    group.items = @[item1, item2, item3];
    
    [self.groups addObject:group];
}


-(void)setGroup3{
    TableGroupModel *group = [TableGroupModel group];
    
    TableItemModel *item1 = [TableItemModel initWithTitle:@"梦想积分" icon:@"album" tag:kTagDreamCredit];
    TableItemModel *item2 = [TableItemModel initWithTitle:@"梦想高度" icon:@"pay" tag:kTagDreamLevel];
    TableItemModel *item3 = [TableItemModel initWithTitle:@"帮助中心" icon:@"draft" tag:kTagHelpCenter];
    TableItemModel *item4 = [TableItemModel initWithTitle:@"设置" icon:@"card" tag:kTagSetting];
    group.items = @[item1, item2, item3, item4];
    
    [self.groups addObject:group];
}

-(void)selfInfoSetView{
    SelfInfoSetViewController *selfVC = [[SelfInfoSetViewController alloc] init];
    selfVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:selfVC animated:YES];
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
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"profile";
    AccountModel *model = [AccountTool account];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    TableGroupModel *group = [self.groups objectAtIndex:indexPath.section];
    TableItemModel  *item  = [group.items objectAtIndex:indexPath.row];
    
    
    cell.tag = item.tag;
    
//    if (indexPath.section == 0) {
//        NSURL *imageUrl = [NSURL URLWithString:model.userImage];
//        if (model.userImage.length) {
//            [cell.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
//        }else{
//            cell.imageView.image = [UIImage imageNamed:@"avatar_default_big"];
//        }
//        cell.imageView.layer.cornerRadius = 40;
//        cell.imageView.layer.masksToBounds = YES;
//        cell.imageView.backgroundColor = [UIColor lightGrayColor];
//        NSString *title = [NSString stringWithFormat:@"追梦人: %@", item.title];
//        NSString *detailTitle = [NSString stringWithFormat:@"  %@", item.detailTitle];
//        cell.textLabel.text = title;
////        cell.detailTextLabel.text = detailTitle;
//    }else{
        cell.textLabel.text = item.title;
        if (item.icon.length) {
            cell.imageView.image = [UIImage imageNamed:item.icon];
        }
//    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (cell.tag == kTagMine){
        SelfInfoSetViewController *selfVC = [[SelfInfoSetViewController alloc] init];
        selfVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:selfVC animated:YES];
    }else if (cell.tag == kTagSetting) {
        SetTableViewController *setVC = [[SetTableViewController alloc] init];
        setVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setVC animated:YES];
    }else if (cell.tag == kTagMyDream){
        AccountModel *model = [AccountTool account];
        DSUser *userInfo = [DSUser userWithAccountModel:model];
        
        DreamsInfoVC *dreamInfoVC = [[DreamsInfoVC alloc] init];
        dreamInfoVC.title = model.userRealName;
        dreamInfoVC.user = userInfo;
        dreamInfoVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:dreamInfoVC animated:YES];
    }else if (cell.tag == kTagMyFocus){
        MyFocusedUserVC *focusedUserVC = [[MyFocusedUserVC alloc] init];
        focusedUserVC.title = @"我的关注";
        focusedUserVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:focusedUserVC animated:YES];
    }else if (cell.tag == kTagMyCollection){
        AccountModel *model = [AccountTool account];
        DSUser *userInfo = [DSUser userWithAccountModel:model];
        
        DreamsInfoVC *dreamInfoVC = [[DreamsInfoVC alloc] init];
        dreamInfoVC.title = model.userRealName;
        dreamInfoVC.user = userInfo;
        dreamInfoVC.api_type = @"getCollections";
        dreamInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dreamInfoVC animated:YES];
    }else if (cell.tag == kTagDreamCredit){
        ProfileUserPointsVC *userPointsVC = [[ProfileUserPointsVC alloc] init];
        [self.navigationController pushViewController:userPointsVC animated:YES];
    }else if (cell.tag == kTagDreamLevel){
        DreamProgressVC *dreamProgress = [[DreamProgressVC alloc] init];
        [self.navigationController pushViewController:dreamProgress animated:YES];
    }else if (cell.tag == kTagHelpCenter){
        HelpCenterVC *helpCenterVC = [[HelpCenterVC alloc] init];
        [self.navigationController pushViewController:helpCenterVC animated:YES];
    }
}

@end
