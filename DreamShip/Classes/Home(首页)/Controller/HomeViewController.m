//
//  HomeViewController.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/17.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "HomeViewController.h"
#import "MainNavigationController.h"

#import "HomeDetailVC.h"
#import "ComposeDreamVC.h"

#import "DSHomeViewCell.h"
#import "DSDreamFrame.h"
#import "DSDreamModel.h"
#import "DSUser.h"

#import "AccountModel.h"
#import "AccountTool.h"
#import "HttpTool.h"
#import "MJExtension.h"
#import "UIBarButtonItem+Extension.h"

@interface HomeViewController()

@property (nonatomic, weak) UIRefreshControl *refreshControl;
@property (nonatomic, weak) UIBarButtonItem *addDreamBarItem;

@property (nonatomic, strong) NSMutableArray *dreamFrames;

@end

@implementation HomeViewController

-(NSMutableArray *)dreamFrames{
    if (_dreamFrames == nil) {
        _dreamFrames = [NSMutableArray array];
    }
    
    return _dreamFrames;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [NSThread sleepForTimeInterval:kLaunchImageShowSec];
    
    [self setNavigationView];
    [self setTableViewInfo];
    [self setHeaderRefreshView];
    
    [kNotificationCenter addObserver:self selector:@selector(getNewDreams) name:kNotificationComposed object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.tabBarController.tabBar.transform = CGAffineTransformIdentity;
    } completion:nil];
}
/**
 *  设置导航
 */
-(void)setNavigationView{
    UIBarButtonItem *addDreamBarItem = [UIBarButtonItem itemWithAction:@selector(addDream) target:self image:@"navigationbar_add" highImage:@"navigationbar_add_highlighted"];
    _addDreamBarItem = addDreamBarItem;
    self.navigationItem.rightBarButtonItem = addDreamBarItem;
}

/**
 *  发表梦想
 */
-(void)addDream{
    ComposeDreamVC *addDreamVC = [[ComposeDreamVC alloc] init];
    addDreamVC.view.backgroundColor = kViewBgColor;
    
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:addDreamVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 *  设置tableview
 */
-(void)setTableViewInfo{
    self.tableView.backgroundColor = kNavBgColor;//RGBColor(240, 240, 240);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = YES;
}

// 获取梦想
-(void)getNewDreams{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"dreams";
    params[@"api_type"] = @"getData";
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {

        NSArray *dreams = [DSDreamModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
        NSArray *dreamFrames = [self dreamFramesWithDreams:dreams];
        
        self.dreamFrames = [NSMutableArray arrayWithArray:dreamFrames];

        [self.refreshControl endRefreshing];
        
        [self.tableView reloadData];
        
        DBLog(@"刷新成功");
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
        [MBProgressHUD showError:@"网络错误!"];
        [self.refreshControl endRefreshing];
    }];
}

// 设置头和尾刷新
-(void)setHeaderRefreshView{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getNewDreams) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.refreshControl = refreshControl;
    [refreshControl beginRefreshing];
    
    [self getNewDreams];
}

-(void)getMoreDreams:(UIRefreshControl *)refreshControl{
    
}

-(NSArray *)dreamFramesWithDreams:(NSArray*)dreams{
    // 将WBStatus数组转为 WBStatusFrame数组
    NSMutableArray *newFrames = [NSMutableArray array];
    for (DSDreamModel *dream in dreams) {
        DSDreamFrame *frame = [[DSDreamFrame alloc]init];
        frame.dream = dream;
        [newFrames addObject:frame];
    }
    
    return newFrames;
}

#pragma mark  TableViewDelegate/Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dreamFrames.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DSDreamFrame *dreamF = [self.dreamFrames objectAtIndex:indexPath.row];
    return dreamF.cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DSHomeViewCell *cell = [DSHomeViewCell cellWithTableView:tableView];
    cell.dreamFrame = [self.dreamFrames objectAtIndex:indexPath.row];
    cell.userInteractionEnabled = YES;
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DSDreamFrame *selectedDream = [self.dreamFrames objectAtIndex:indexPath.row];
    
    HomeDetailVC *homeDetailVC = [[HomeDetailVC alloc] init];
    [homeDetailVC setDreamFrame:selectedDream];

    //self.tabBarController.tabBar.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(-kScreenWidth, 0);
        [self.navigationController pushViewController:homeDetailVC animated:YES];
    }];
}

-(void)cellToolBarClickedWithTag:(NSInteger)tag dreamFrame:(DSDreamFrame *)dreamFrame{
    switch (tag) {
        case kTagSupport:
            [self supportDream:dreamFrame];
            break;
        case kTagUnSupport:
            [self unsupportDream:dreamFrame];
            break;
        case kTagComment:
            [self commentDream:dreamFrame];
            break;
        default:
            break;
    }
}

-(void)supportDream:(DSDreamFrame*)dreamFrame{
    DSDreamModel *dreamModel = dreamFrame.dream;
    DSUser *dsUser = dreamModel.user;
    
    AccountModel *accounter = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"comments";
    params[@"api_type"] = @"support";
    params[@"dream_id"] = dreamModel.idStr;
    params[@"user_id"] = accounter.userID;
    params[@"time"] = [CommomToolDefine currentDateStr];
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary* json) {
        DBLog(@"%@", json);
        [self getNewDreams];
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
    }];
}

-(void)unsupportDream:(DSDreamFrame*)dreamFrame{
    DSDreamModel *dreamModel = dreamFrame.dream;
    DSUser *dsUser = dreamModel.user;
    
    AccountModel *accounter = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"comments";
    params[@"api_type"] = @"unsupport";
    params[@"dream_id"] = dreamModel.idStr;
    params[@"user_id"] = accounter.userID;
    params[@"time"] = [CommomToolDefine currentDateStr];
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary* json) {
        DBLog(@"%@", json);
        [self getNewDreams];
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
    }];
}

-(void)commentDream:(DSDreamFrame*)dreamFrame{
    HomeDetailVC *homeDetailVC = [[HomeDetailVC alloc] init];
    [homeDetailVC setDreamFrame:dreamFrame];
    
    //self.tabBarController.tabBar.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(-kScreenWidth, 0);
        [self.navigationController pushViewController:homeDetailVC animated:YES];
    }];
}

@end
