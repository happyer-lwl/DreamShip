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
#import "MJRefresh.h"
#import "UIBarButtonItem+Extension.h"

@interface HomeViewController()

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

//-(AVAudioPlayer *)player{
//    if (_player == nil) {
//        _player = [[AVAudioPlayer alloc] init];
//    }
//    
//    return _player;
//}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [NSThread sleepForTimeInterval:kLaunchImageShowSec];
    
    [self setNavigationView];
    [self setTableViewInfo];
    [self setHeaderRefreshView];
    
    [kNotificationCenter addObserver:self selector:@selector(getNewDreams) name:kNotificationComposed object:nil];
}

/**
 *  设置导航
 */
-(void)setNavigationView{
    UIBarButtonItem *addDreamBarItem = [UIBarButtonItem itemWithAction:@selector(addDream) target:self image:@"navigationbar_add" highImage:@"navigationbar_add_highlighted"];
    _addDreamBarItem = addDreamBarItem;
    self.navigationItem.rightBarButtonItem = addDreamBarItem;
    
    //self.navigationController.navigationBar.hidden = YES;
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
    //self.tableView.backgroundColor = kViewBgColor;
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
    bgImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ufo" ofType:@"jpeg"]];
    self.tableView.backgroundView = bgImageView;
    
//    UIView *headerView = [[UIView alloc] init];
//    headerView.frame = CGRectMake(0, 0, kScreenWidth, 150);
//    
//    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 130)];
//    NSString *imageFile = [[NSBundle mainBundle] pathForResource:@"DreamAndMoon" ofType:@"jpg"];
//    headImage.image = [UIImage imageWithContentsOfFile:imageFile];
//    
//    [headerView addSubview:headImage];
//    self.tableView.tableHeaderView = headerView;
    
    
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
    if (self.dreamRange == DreamRangeSelf) {
        AccountModel *account = [AccountTool account];
        params[@"user_id"] = account.userID;
    }else if (self.dreamRange == DreamRangeFriend){
        params[@"user_id"] = self.dreamModel.user.user_id;
    }else if (self.dreamRange == DreamRangeAll) {
        params[@"user_id"] = @"all";
    }
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {

        NSArray *dreams = [DSDreamModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
        NSArray *dreamFrames = [self dreamFramesWithDreams:dreams];
        
        self.dreamFrames = [NSMutableArray arrayWithArray:dreamFrames];

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
        [MBProgressHUD showError:@"网络错误!"];
    }];
}

// 设置头和尾刷新
-(void)setHeaderRefreshView{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getNewDreams];
    }];
    [self.tableView.mj_header beginRefreshing];
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

    [kNotificationCenter addObserver:self selector:@selector(updateCellInfo) name:kUpdateCellInfoFromCell object:nil];
    
    homeDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeDetailVC animated:YES];
}
/**
 *  观察者，更新内容
 */
-(void)updateCellInfo{
    self.dreamRange = DreamRangeAll;
    [self getNewDreams];
}
/**
 *  toolBar按键回调
 *
 *  @param tag        按键类型
 *  @param dreamFrame 返回的数据模型
 */
-(void)cellToolBarClickedWithTag:(NSInteger)tag dreamFrame:(DSDreamFrame *)dreamFrame{
    switch (tag) {
        case kTagSupport:
        case kTagUnSupport:
            break;
        case kTagComment:
            [self commentDream:dreamFrame];
            break;
        default:
            break;
    }
    
    for (NSInteger i = 0; i < self.dreamFrames.count; i++) {
        DSDreamFrame *frame = self.dreamFrames[i];
        if ([frame.dream.idStr isEqualToString:dreamFrame.dream.idStr]) {
            self.dreamFrames[i] = dreamFrame;
        }
    }
}
/**
 *  点击评论按键
 *
 *  @param dreamFrame <#dreamFrame description#>
 */
-(void)commentDream:(DSDreamFrame*)dreamFrame{
    HomeDetailVC *homeDetailVC = [[HomeDetailVC alloc] init];
    [homeDetailVC setDreamFrame:dreamFrame];
    
    homeDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeDetailVC animated:YES];
}

@end
