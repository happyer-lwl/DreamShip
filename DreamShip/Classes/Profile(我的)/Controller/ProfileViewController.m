//
//  ProfileViewController.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/18.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "ProfileViewController.h"

#import "UIImageView+WebCache.h"

#import "AccountTool.h"
#import "AccountModel.h"

#import "SetTableViewController.h"
#import "SelfInfoSetViewController.h"
#import "TableGroupModel.h"
#import "TableItemModel.h"

#define kTagMine            0

#define kTagDream           1
#define kTagCollection      2
#define kTagFocus           3

#define kTagDreamMoney      4
#define kTagHelper          5
#define kTagSetting         6

@interface ProfileViewController()

@property (nonatomic, strong) NSMutableArray* groups;

@end

@implementation ProfileViewController
-(NSArray*)groups{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    
    return _groups;
}

-(id)init{
    return [self initWithStyle:UITableViewStyleGrouped];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = RGBColor(240, 240, 240);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
//    self.tableView.scrollEnabled = NO;
    
    [self setGroup1];
    [self setGroup2];
    [self setGroup3];
    
    [kNotificationCenter addObserver:self selector:@selector(updateUserImage) name:kUpdateUserImage object:nil];
    
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.tabBarController.tabBar.transform = CGAffineTransformIdentity;
    } completion:nil];
}

/**
 *  设置头像后更新
 */
-(void)updateUserImage{
    [self.tableView reloadData];
}

-(void)setGroup1{
    TableGroupModel *group = [TableGroupModel group];
    
    AccountModel *model = [AccountTool account];
    TableItemModel *item = [TableItemModel initWithTitle:model.userPhone tag:kTagMine];
    group.items = @[item];
    
    [self.groups addObject:group];
}

-(void)setGroup2{
    TableGroupModel *group = [TableGroupModel group];
    
    TableItemModel *item1 = [TableItemModel initWithTitle:@"我做的梦" tag:kTagDream];
    TableItemModel *item2 = [TableItemModel initWithTitle:@"我的收藏" tag:kTagCollection];
    TableItemModel *item3 = [TableItemModel initWithTitle:@"我的关注" tag:kTagFocus];
    group.items = @[item1, item2, item3];
    
    [self.groups addObject:group];
}


-(void)setGroup3{
    TableGroupModel *group = [TableGroupModel group];
    
    TableItemModel *item1 = [TableItemModel initWithTitle:@"梦想基金" tag:kTagDreamMoney];
    TableItemModel *item2 = [TableItemModel initWithTitle:@"帮助中心" tag:kTagHelper];
    TableItemModel *item3 = [TableItemModel initWithTitle:@"设置" tag:kTagSetting];
    group.items = @[item1, item2, item3];
    
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
    }else{
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"profile";
    AccountModel *model = [AccountTool account];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    TableGroupModel *group = [self.groups objectAtIndex:indexPath.section];
    TableItemModel  *item  = [group.items objectAtIndex:indexPath.row];
    
    
    cell.tag = item.tag;
    
    if (indexPath.section == 0) {
        NSURL *imageUrl = [NSURL URLWithString:model.userImage];
        if (model.userImage.length) {
            //[UIImageView setImageForImageView:cell.imageView imageURL:imageUrl];
            [cell.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"avatar_default_big"];
        }
        cell.imageView.layer.cornerRadius = 40;
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.backgroundColor = [UIColor lightGrayColor];
        NSString *title = [NSString stringWithFormat:@" %@", item.title];
        cell.textLabel.text = title;
    }else{
        cell.textLabel.text = item.title;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(-kScreenWidth, 0);
        if (cell.tag == kTagSetting) {
            SetTableViewController *setVC = [[SetTableViewController alloc] init];
            [self.navigationController pushViewController:setVC animated:YES];
        }else if (cell.tag == kTagMine){
            SelfInfoSetViewController *selfVC = [[SelfInfoSetViewController alloc] init];
            [self.navigationController pushViewController:selfVC animated:YES];
        }
    }];
}

@end
