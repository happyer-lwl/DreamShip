//
//  HomeViewController.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/17.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "DreamsInfoVC.h"
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

#define kDreamTypeSegHeight 40

@interface DreamsInfoVC()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIBarButtonItem *addDreamBarItem;

@property (nonatomic, strong) NSMutableArray *dreamFrames;
@end

@implementation DreamsInfoVC

-(NSMutableArray *)dreamFrames{
    if (_dreamFrames == nil) {
        _dreamFrames = [NSMutableArray array];
    }
    
    return _dreamFrames;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //self.view.backgroundColor = kTitleDarkBlueColor;
    self.view.backgroundColor = [UIColor grayColor];
    
    [NSThread sleepForTimeInterval:kLaunchImageShowSec];
    
    [self setTableViewInfo];
    [self setHeaderRefreshView];
    
    [kNotificationCenter addObserver:self selector:@selector(getNewDreams) name:kNotificationComposed object:nil];
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    
    tableView.backgroundColor = kViewBgColor220;
    
    tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.userInteractionEnabled = YES;
    [self.view addSubview:tableView];
    
    _tableView = tableView;
}

// 获取梦想
-(void)getNewDreams{
    AccountModel *account = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"dreams";
    if (self.api_type == nil)
        params[@"api_type"] = @"getData";
    else
        params[@"api_type"] = self.api_type;
    
    params[@"user_id"] = self.user.user_id;
    params[@"cur_user_id"] = account.userID;
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {
        
        NSArray *dreams = [DSDreamModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
        NSArray *dreamFrames = [self dreamFramesWithDreams:dreams];
        
        [self.dreamFrames removeAllObjects];
        self.dreamFrames = [NSMutableArray arrayWithArray:dreamFrames];
        
        [self.tableView reloadData];
        if (dreamFrames.count == 0){
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showError:@"没有数据"];
        }else{
            [self.tableView.mj_header endRefreshing];
        }
        
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
        [MBProgressHUD showError:@"网络错误!"];
        [self.tableView.mj_header endRefreshing];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

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
    [self getNewDreams];
}

#pragma mark #HomeViewCellDelegate
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

-(void)cellUserIconClicked:(DSDreamFrame *)dreamFrame{
    DBLog(@"User icon clicked");
}

-(void)cellPhotoViewClicked:(DSDreamFrame *)dreamFrame{
    DBLog(@"Photo clicked");
}

-(void)cellCollectionClicked:(DSDreamFrame *)dreamFrame state:(BOOL)selected{
    DBLog(@"Collection Clicked");
    
    AccountModel *account = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"api_uid"] = @"dreams";
    params[@"api_type"] = selected ? @"cancelCollectedDream" : @"collectDream";
    params[@"user_id"] = account.userID;
    params[@"dream_id"] = dreamFrame.dream.idStr;
    
    [HttpTool getWithUrl:Host_Url params:params success:^(id json) {
        NSString *msg = json[@"msg"];
        
        [self modifyDreamFrames:dreamFrame collectState:!selected];
        [self.tableView reloadData];
        [MBProgressHUD showSuccess:msg];
    } failure:^(NSError *error) {
        DBLog(@"error %@", error.description);
    }];
}

-(void)modifyDreamFrames:(DSDreamFrame *)dreamFrame collectState:(BOOL)collectState{
    for (DSDreamFrame *dreamFrameIn in self.dreamFrames) {
        if (dreamFrameIn == dreamFrame) {
            dreamFrame.dream.collection = collectState ? @"1" : @"0";
        }
    }
}
@end
