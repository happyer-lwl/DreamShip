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
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    
    tableView.backgroundColor = kViewBgColorDarker;
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
        
        self.dreamFrames = [NSMutableArray arrayWithArray:dreamFrames];
        
        if (dreamFrames.count == 0) {
            [CommomToolDefine addNoDataForView:self.view];
        }
        
        [self.tableView reloadData];
        [self.tableView.gifHeader endRefreshing];
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
        [MBProgressHUD showError:@"网络错误!"];
        [self.tableView.gifHeader endRefreshing];
    }];
}

// 设置头和尾刷新
-(void)setHeaderRefreshView{
    //添加下拉的动画图片
    //设置下拉刷新回调
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getNewDreams)];
    
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CATransform3D rotation;
    if (indexPath.row % 2 == 0) {
        rotation                = CATransform3DMakeTranslation(kScreenWidth, 0.0, 0.0);
    }else{
        rotation                = CATransform3DMakeTranslation(-kScreenWidth, 0.0, 0.0);
    }
    
    cell.layer.transform    = rotation;
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.5];
    cell.layer.transform    = CATransform3DIdentity;
    [UIView commitAnimations];
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

-(void)cellCollectionClicked:(DSDreamFrame *)dreamFrame state:(BOOL)selected view:(UIView *)view{
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
